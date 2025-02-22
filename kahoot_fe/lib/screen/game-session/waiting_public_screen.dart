import 'package:flutter/material.dart';
import 'package:kahoot_clone/providers/auth_provider.dart';
import 'package:kahoot_clone/services/quiz/quiz_detail_model.dart';
import 'package:kahoot_clone/services/quiz/quiz_service.dart';
import 'dart:async';
import 'package:kahoot_clone/services/user/user_service.dart';
import 'package:kahoot_clone/screen/game-session/playing_game_screen.dart';
import 'package:kahoot_clone/services/game-session/game_session_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaitingPublicPage extends StatefulWidget {
  final String quizId;

  WaitingPublicPage({required this.quizId});
  @override
  _WaitingPublicPageState createState() => _WaitingPublicPageState();
}

class _WaitingPublicPageState extends State<WaitingPublicPage> {
  int _countdown = 7; // Thời gian đếm ngược
  late Timer _timer;
  late Future<List<dynamic>> gameSession;
  late Future<Map<String, dynamic>> user;
  int sessionPlayerId = 0;
  String? token = '';
  String? userId;
  bool _isPlayerCreated = false;
  bool _isStarted = false;
  late Future<QuizDetail> quiz;

  Future<void> _createSnap() async {
    List<dynamic> sessionList = await gameSession;
    final quiz =
        await QuizService().fetchQuizDetailById(int.parse(widget.quizId));

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
      sessionId: sessionList[sessionList.length - 1]['session_id'],
      quizId: int.parse(widget.quizId),
      userId: userId.toString().isNotEmpty ? int.parse(userId!) : 0,
      quizData: quizData,
    );
  }

  @override
  void initState() {
    super.initState();
    gameSession = loadGameSessions();
    user = loadUser();
    // _startCountdown();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isPlayerCreated) {
      // Chỉ gọi khi chưa tạo player
      _isPlayerCreated = true;
      context.read<AuthProvider>().loadUserData();
      _createPlayer();
      _createSnap();
      quiz = fetchQuizDetailById(int.parse(widget.quizId));
    }
  }

  Future<void> _createPlayerSession(String token, int userId) async {
    Map<String, dynamic> data = await user;
    List<dynamic> sessionList = await gameSession;
    try {
      final sessionId = sessionList[sessionList.length - 1]['session_id'];
      final response = await GameSessionService().createPlayerSession(
        token: token,
        sessionId: sessionId,
        userId: userId,
        nickname: data['username'] ?? "",
      );
      sessionPlayerId = response['session_player_id'];
      print('Player session created: $response');
    } catch (error) {
      print('Failed to create player session: $error');
    }
  }

  Future<Map<String, dynamic>> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id');
    token = prefs.getString('token');
    return await UserService().getUserInfoByUserId(
      userId!,
    );
  }

  Future<List<dynamic>> loadGameSessions() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    return await GameSessionService().getGameSessionByQuizId(
      id: widget.quizId,
      token: token ?? '',
    );
  }

  Future<QuizDetail> fetchQuizDetailById(int quizId) async {
    return await QuizService().fetchQuizDetailById(quizId);
  }

  void _createPlayer() async {
    final authProvider = context.watch<AuthProvider>();
    print('userId: ${authProvider.userId}');
    if (authProvider.userId != null) {
      if (authProvider.userId != null) {
        _createPlayerSession(token!, int.parse(authProvider.userId!));
      } else {
        print('Error: userId is null');
      }
    } else {
      print('Lỗi: userId không thể chuyển đổi thành số nguyên - $userId');
    }
  }

  // Hàm đếm ngược
  void _startCountdown() async {
    setState(() {
      _isStarted = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer.cancel(); // Hủy timer khi kết thúc đếm ngược
        List<dynamic> sessionList = await gameSession;
        Map<String, dynamic> data = await user;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => PlayingGameScreen(
                    sessionId: sessionList[sessionList.length - 1]
                        ['session_id'],
                    quizId: int.parse(widget.quizId),
                    pin: sessionList[sessionList.length - 1]['pin'],
                    sessionPlayerId: sessionPlayerId,
                    nickname: data['username'] ?? "")));
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: _isStarted
              ? Container(
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
                            '$_countdown',
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
                )
              : Center(
                  child: FutureBuilder<QuizDetail>(
                    future: quiz,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      return Container(
                          decoration: BoxDecoration(
                            color: Colors.red
                                .shade200, // Đặt màu nền, có thể thay đổi theo ý muốn
                            borderRadius:
                                BorderRadius.circular(10), // Bo góc nếu cần
                          ),
                          padding:
                              const EdgeInsets.all(20), // Thêm padding nếu cần
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  snapshot.data!.coverImage,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'https://res.cloudinary.com/dlrd3ngz5/image/upload/v1738783278/kahoot_clone/tiazt9rtbc1thccrgw58.jpg',
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  snapshot.data!.title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Text(
                                    snapshot.data!.description,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: _startCountdown,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.white, // Màu nền của button
                                    shadowColor:
                                        Colors.black, // Màu của bóng đổ
                                    elevation:
                                        10, // Độ cao của bóng đổ (càng lớn, bóng càng rõ)
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Bo góc button
                                    ),
                                  ),
                                  child: const Text(
                                    'Start Game',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ));
                    },
                  ),
                )),
    );
  }
}
