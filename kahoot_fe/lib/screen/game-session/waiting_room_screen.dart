import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kahoot_clone/screen/game-session/host_screen.dart';
import 'package:kahoot_clone/screen/game-session/playing_game_screen.dart';
import 'package:kahoot_clone/services/game-session/game_session_service.dart';
import 'package:kahoot_clone/services/quiz/quiz_service.dart';
import 'package:kahoot_clone/services/socket/socket_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class WaitingRoomScreen extends StatefulWidget {
  final String gamePin;

  const WaitingRoomScreen({
    Key? key,
    required this.gamePin,
  }) : super(key: key);

  @override
  _WaitingRoomScreenState createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  int playerCount = 0;
  String hostName = '';
  int session_id = 0;
  int quiz_id = 0;
  int? userId;
  String? token = '';
  List<String> playerList = [];
  String? nickname;
  int sessionPlayerId = 0;

  final TextEditingController _nicknameController = TextEditingController();
  int countdown = 7;
  Timer? _timer;
  int remainingTime = 7;
  bool isPopupVisible = false;

  @override
  void initState() {
    super.initState();

    _loadGameSessionData();

    SocketService().connect();

    const uuid = Uuid();
    nickname = 'Player-${uuid.v4()}';

    SocketService()
        .emitEvent('join-room', {'pin': widget.gamePin, 'nickname': nickname!});

    SocketService().socket.on('player-count', (data) {
      setState(() {
        playerCount = data['count'];
      });
    });

    SocketService().socket.on('player-list', (data) {
      setState(() {
        playerList = List<String>.from(data['players']);

        if (playerList.isNotEmpty && playerList[0] != 'HOST') {
          if (playerList[0] == nickname) {
            nickname = 'HOST';
            SocketService().emitEvent('nickname-changed', {
              'nickname': 'HOST',
              'pin': widget.gamePin,
              'sessionPlayerId': sessionPlayerId,
            });
            playerList.removeAt(0);
          }
        }
      });
    });

    SocketService().socket.on('countdown-tick', (data) {
      setState(() {
        remainingTime = data['remainingTime'];
        isPopupVisible = true;
      });
    });

    SocketService().socket.on('countdown-finished', (data) async {
      final newGame = await GameSessionService().updateGameSessionStatus(
          token: token ?? '', sessionId: session_id, status: 'playing');
      print(newGame);
      if (hostName != userId?.toString()) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => PlayingGameScreen(
                    sessionId: session_id,
                    quizId: quiz_id,
                    pin: widget.gamePin,
                    sessionPlayerId: sessionPlayerId,
                    nickname: nickname ?? "")));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HostScreen(
                      sessionId: session_id,
                      token: token ?? "",
                    )));
      }
    });
  }

  // Tạo session player
  Future<void> _createPlayerSession(String token, int userId) async {
    try {
      final quiz = await QuizService().fetchQuizDetailById(quiz_id);
      print(quiz.creator);
      print(userId.toString());
      if (quiz.creator != userId.toString()) {
        final sessionId = session_id;
        final response = await GameSessionService().createPlayerSession(
          token: token,
          sessionId: sessionId,
          userId: userId,
          nickname: nickname!,
        );
        sessionPlayerId = response['session_player_id'];
        print('Player session created: $response');
      }
    } catch (error) {
      print('Failed to create player session: $error');
    }
  }

  // Lấy thông tin host và session id
  Future<void> _loadGameSessionData() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    var userIdString = prefs.getString('user_id');
    userId = userIdString != null ? int.tryParse(userIdString) : null;

    if (token != null && userId != null) {
      var gameSession = await GameSessionService()
          .getGameSessionByPIN(pin: widget.gamePin, token: token!);
      hostName = gameSession['gameSession']['host'];
      session_id = gameSession['gameSession']['session_id'];
      quiz_id = gameSession['gameSession']['quiz_id'];
      _createPlayerSession(token!, userId!);
      _createSnap();
    } else {
      print('Game session data is missing.');
    }
  }

  void _showNicknameDialog(String currentNickname) {
    _nicknameController.text = currentNickname;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Nickname'),
          content: TextField(
            controller: _nicknameController,
            decoration: const InputDecoration(
              hintText: 'Enter new nickname',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Update the nickname in the state
                setState(() {
                  nickname = _nicknameController.text;
                });

                // Update player session with new nickname
                try {
                  final data = await GameSessionService().updatePlayerSession(
                    token: token ?? '',
                    id: sessionPlayerId,
                    sessionId: session_id,
                    userId: userId ?? 0,
                    nickname: nickname,
                    score: 0, // Example score
                  );
                  print("Player session updated: $data");

                  if (data != null) {
                    SocketService().emitEvent('nickname-changed', {
                      'nickname': nickname,
                      'pin': widget.gamePin,
                      'sessionPlayerId': sessionPlayerId,
                    });
                  } else {
                    print("Error: Could not update nickname");
                  }

                  Navigator.of(context).pop();
                } catch (e) {
                  print('Error updating player session: $e');
                }

                SocketService().socket.on('nickname-changed', (data) {
                  setState(() {
                    playerList = List<String>.from(data['players']);
                    print("Nickname đã thay đổi: ${data['nickname']}");
                  });
                });
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _startGame() {
    if (hostName == userId?.toString()) {
      SocketService().emitEvent(
          'start-countdown', {'pin': widget.gamePin, 'countdown': countdown});
    }
    setState(() {
      isPopupVisible = true;
    });
  }

  // Tao snapshot cho quiz
  Future<void> _createSnap() async {
    final quiz = await QuizService().fetchQuizDetailById(quiz_id);

    final Map<String, dynamic> quizData = {
      'quizTitle': quiz.title,
      'questions': quiz.questions
          .map((question) => {
                'question_id': question.questionId,
                'question_text': question.questionText,
                'options': question.options
                    .map((option) => {
                          'option_id': option.optionId,
                          'option_text': option.optionText,
                          'is_correct': option.isCorrect
                        })
                    .toList(),
              })
          .toList(),
    };

    await GameSessionService().createQuizSnapshot(
      token: token ?? '',
      sessionId: session_id,
      quizId: quiz_id,
      userId: userId ?? 0,
      quizData: quizData,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background-waittingroom.jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 48),
                // Thông tin phòng
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Join at www.quizapp.it\nor with the Quiz app',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Game PIN: ${widget.gamePin}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                      Container(
                        width: 80,
                        height: 80,
                        color: Colors.black12,
                        child: const Center(
                          child: Text(
                            'QR',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: (playerList.length / 2).ceil(),
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (playerList[index * 2] == nickname) {
                                  _showNicknameDialog(playerList[index * 2]);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: playerList[index * 2] == nickname
                                        ? Colors.red
                                        : Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12.0))),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 4.0),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.person,
                                    color: playerList[index * 2] == nickname
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  title: Text(
                                    playerList[index * 2],
                                    style: TextStyle(
                                      color: playerList[index * 2] == nickname
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (index * 2 + 1 < playerList.length)
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (playerList[index * 2 + 1] == nickname) {
                                    _showNicknameDialog(
                                        playerList[index * 2 + 1]);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color:
                                          playerList[index * 2 + 1] == nickname
                                              ? Colors.red
                                              : Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12.0))),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4.0),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.person,
                                      color:
                                          playerList[index * 2 + 1] == nickname
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                    title: Text(
                                      playerList[index * 2 + 1],
                                      style: TextStyle(
                                        color: playerList[index * 2 + 1] ==
                                                nickname
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            if (hostName == userId?.toString())
              Positioned(
                bottom: 16,
                left: 16,
                child: GestureDetector(
                  onTap: _startGame,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.red,
                          width: 2.0,
                          style: BorderStyle.solid,
                        )),
                    child: const Text(
                      'Start',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 68, 68, 68),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Players: ${playerCount - 1}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (isPopupVisible)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isPopupVisible = false;
                    });
                  },
                  child: Container(
                    color: Colors.red.shade100,
                    child: Center(
                      child: Container(
                        width: 300,
                        height: 400,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Game starts after',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '$remainingTime',
                                  style: const TextStyle(
                                    fontSize: 48,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'second',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
