import 'package:flutter/material.dart';
import 'package:kahoot_clone/services/game-session/game_session_service.dart';
import 'package:kahoot_clone/services/socket/socket_service.dart';

class HostScreen extends StatefulWidget {
  final int sessionId;
  final String token;

  const HostScreen({
    Key? key,
    required this.sessionId,
    required this.token,
  }) : super(key: key);

  @override
  _HostScreenState createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  List<Map<String, dynamic>> listPlayer = [];

  @override
  void initState() {
    super.initState();
    _loadPlayersList();
    _setupSocketListeners();
  }

  Future<void> _loadPlayersList() async {
    try {
      final players = await GameSessionService().getPlayersList(
        sessionId: "${widget.sessionId}",
        token: widget.token,
      );
      setState(() {
        listPlayer = players.map<Map<String, dynamic>>((player) {
          return {
            'user_id': player['user_id'],
            'nickname': player['nickname'],
            'score': 0,
          };
        }).toList();
      });
    } catch (e) {
      print('Error loading player list: $e');
    }
  }

  void _setupSocketListeners() {
    SocketService().socket.on('score-updated', (data) {
      setState(() {
        listPlayer = listPlayer.map((player) {
          if (player['user_id'] == data['userId']) {
            return {
              ...player,
              'score': data['score'],
            };
          }
          return player;
        }).toList();
         listPlayer.sort((a, b) => b['score'].compareTo(a['score']));
      });
      print(listPlayer);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background-playinggame.jpg'),
            fit: BoxFit.cover,
            opacity: 0.5,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 76),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.red,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
                ],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Text(
                'Scores of players',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Image.asset(
              'assets/images/fox-teacher.png',
              height: 200,
              fit: BoxFit.contain,
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: listPlayer.length,
                itemBuilder: (context, index) {
                  final player = listPlayer[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(235, 255, 0, 0),
                          blurRadius: 4.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Colors.red),
                      title: Text(
                        player['nickname'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Text(
                        '${player['score']} pts',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
