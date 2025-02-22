import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:kahoot_clone/services/game-session/game_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RankingScreen extends StatefulWidget {
  final int sessionId;

  const RankingScreen({
    Key? key,
    required this.sessionId,
  }) : super(key: key);

  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  String? token = '';
  bool showWaiting = true;
  bool showFirstPlace = false;
  bool showSecondPlace = false;
  bool showThirdPlace = false;

  List<Map<String, dynamic>> leaderboardData = [];

  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 3));

  @override
  void initState() {
    super.initState();
    _confettiController.play();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showWaiting = false;
        showFirstPlace = true;
      });
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          showSecondPlace = true;
        });
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            showThirdPlace = true;
          });
          _getTopPlayer(); // Gọi API sau khi hiển thị xong
        });
      });
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _getTopPlayer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token');
      final response = await GameSessionService()
          .getTopPlayerBySessionId(token ?? '', widget.sessionId);

      // Kiểm tra xem response có phải là một danh sách không
      if (response is List && response.isNotEmpty) {
        List<Map<String, dynamic>> leaderboardData = [];

        // Duyệt qua danh sách response và chuyển đổi nó thành leaderboardData
        for (int i = 0; i < response.length; i++) {
          var player = response[i];
          leaderboardData.add({
            'name': player['nickname'], // Lấy tên người chơi từ response
            'score': player['score'], // Lấy điểm số từ response
            'position': i + 1, // Vị trí xếp hạng, bắt đầu từ 1
          });
        }

        leaderboardData.sort((a, b) => b['score'].compareTo(a['score']));

        setState(() {
          this.leaderboardData = leaderboardData;
        });
      } else {
        print('Dữ liệu không phải là danh sách hoặc rỗng');
      }
    } catch (e) {
      print('Error getting leaderboard data: $e');
    }
  }

  Widget buildMedal(int position) {
    switch (position) {
      case 1:
        return const Icon(Icons.emoji_events, color: Colors.orange, size: 50);
      case 2:
        return const Icon(Icons.emoji_events, color: Colors.grey, size: 50);
      case 3:
        return const Icon(Icons.emoji_events, color: Colors.brown, size: 50);
      default:
        return const Icon(Icons.star, color: Colors.blue, size: 50);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Kiểm tra và đảm bảo danh sách leaderboardData có ít nhất 3 phần tử
    List<Map<String, dynamic>> topThreePlayers = leaderboardData.length >= 3
        ? leaderboardData.sublist(0, 3)
        : leaderboardData;

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showWaiting)
                  Container(
                    color: Colors.red[400],
                    padding: const EdgeInsets.all(16.0),
                    child: const Text(
                      'Waiting to get ranking...',
                      style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (!showWaiting)
                  Container(
                    color: Colors.red[400],
                    padding: const EdgeInsets.all(16.0),
                    child: const Text(
                      'Top 3 players with the highest scores',
                      style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (showSecondPlace && topThreePlayers.length > 1)
                      buildPlayerCard(topThreePlayers[1], height: 200),
                    if (showFirstPlace && topThreePlayers.isNotEmpty)
                      buildPlayerCard(topThreePlayers[0], height: 250),
                    if (showThirdPlace && topThreePlayers.length > 2)
                      buildPlayerCard(topThreePlayers[2], height: 170),
                  ],
                ),
                
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.blue,
                Colors.red,
                Colors.yellow,
                Colors.green
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPlayerCard(Map<String, dynamic> data, {required double height}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 255, 134, 134).withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      height: height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildMedal(data['position']),
          const SizedBox(height: 10),
GestureDetector(
  onTap: () {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Full Name"),
        content: Text(data['name']),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  },
  child: Text(
    data['name'].length > 5 ? '${data['name'].substring(0, 5)}...' : data['name'],
    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
    softWrap: false,
  ),
),
          const SizedBox(height: 5),
          Text(
            '${data['score']}',
            style: TextStyle(fontSize: 16, color: Colors.red[400]),
          ),
        ],
      ),
    );
  }
}
