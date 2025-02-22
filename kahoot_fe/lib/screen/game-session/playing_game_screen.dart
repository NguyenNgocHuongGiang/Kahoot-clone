import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kahoot_clone/screen/game-session/ranking_screen.dart';
import 'package:kahoot_clone/services/game-session/game_session_service.dart';
import 'package:kahoot_clone/services/quiz/quiz_detail_model.dart';
import 'package:kahoot_clone/services/quiz/quiz_service.dart';
import 'package:kahoot_clone/services/socket/socket_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayingGameScreen extends StatefulWidget {
  final int sessionId;
  final int quizId;
  final String pin;
  final int sessionPlayerId;
  final String nickname;

  PlayingGameScreen(
      {required this.sessionId,
      required this.quizId,
      required this.pin,
      required this.sessionPlayerId,
      required this.nickname});

  @override
  _PlayingGameScreenState createState() => _PlayingGameScreenState();
}

class _PlayingGameScreenState extends State<PlayingGameScreen> {
  List<QuestionDetail> questions = [];
  int currentQuestionIndex = 0;
  late Future<QuizDetail> _quizFuture;
  late Timer _timer;
  int remainingTime = 0;
  int? selectedAnswerId;
  bool isAnswerSelected = false;
  bool isAnswerCorrect = false;
  int score = 0;
  int? selectedTime;
  int? userId;
  String? token = '';
  Map<int, int?> answers = {};
  late QuizDetail quizDetail;

  @override
  void initState() {
    super.initState();
    _quizFuture = QuizService().fetchQuizDetailById(widget.quizId ?? 0);
    _quizFuture.then((value) {
      setState(() {
        quizDetail = value;
      });
    });
    _loadQuestionData();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _loadQuestionData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token');
      var userIdString = prefs.getString('user_id');
      userId = userIdString != null ? int.tryParse(userIdString) : null;
      final quizDetail = await QuizService().fetchQuizDetailById(widget.quizId);
      setState(() {
        questions = quizDetail.questions;
        _startTimer();
      });
    } catch (e) {
      print('Error loading question data: $e');
    }
  }

  void _startTimer() {
    remainingTime = questions[currentQuestionIndex].timeLimit;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          _nextQuestion();
        }
      });
    });
  }

  void _nextQuestion() async {
    _timer.cancel();
    setState(() {
      selectedAnswerId = null;
      isAnswerSelected = false;
      isAnswerCorrect = false;
    });
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        _startTimer();
      });
    } else {
      setState(() {
        remainingTime = 0;
      });
      _createSessionAnswer();
      if (quizDetail.visibility == 'private') {
        _updateStatus();
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RankingScreen(sessionId: widget.sessionId),
        ),
      );
    }
  }

  Future<void> _createSessionAnswer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token');
      var userIdString = prefs.getString('user_id');
      userId = userIdString != null ? int.tryParse(userIdString) : null;
      final session = await GameSessionService()
          .getGameSessionByPIN(pin: widget.pin, token: token ?? "");

      await GameSessionService().createSessionAnswer(
        token: token ?? '',
        sessionId: session['gameSession']['session_id'],
        userId: userId ?? 0,
        answersData: answers,
      );

      await GameSessionService().updatePlayerSession(
          token: token ?? "",
          id: widget.sessionPlayerId,
          sessionId: session['gameSession']['session_id'],
          userId: userId ?? 0,
          nickname: widget.nickname,
          score: score);
    } catch (e) {
      print('Error creating session answer: $e');
    }
  }

  Future<void> _updateStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token');
      print(widget.sessionId);
      await GameSessionService().updateGameSessionStatus(
          token: token ?? '', sessionId: widget.sessionId, status: 'inactive');
    } catch (e) {
      print('Error creating session answer: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    QuestionDetail currentQuestion = questions[currentQuestionIndex];
    List<OptionDetail> options = currentQuestion.options;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Playing quiz',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage('assets/images/background-playinggame_user.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            '$remainingTime',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        currentQuestion.questionText,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (currentQuestion.mediaUrl != null && currentQuestion.mediaUrl!.isNotEmpty && currentQuestion.mediaUrl!.contains('http'))
                      Image.network(
                        currentQuestion.mediaUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    const SizedBox(height: 16),
                    // Answer options
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 100,
                      ),
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options[index];
                        Color optionColor;

                        // Kiểm tra xem câu trả lời đã được chọn chưa
                        if (answers[currentQuestionIndex] == option.optionId) {
                          optionColor = Colors.white; // Nếu đã chọn, đổi màu
                        } else {
                          optionColor = index == 0
                              ? Colors.red
                              : index == 1
                                  ? Colors.blue
                                  : index == 2
                                      ? Colors.yellow[700]!
                                      : Colors.green;
                        }

                        return GestureDetector(
                          onTap: () {
                            if (!isAnswerSelected) {
                              setState(() {
                                answers[currentQuestionIndex] =
                                    option.optionId; // Lưu câu trả lời
                                isAnswerSelected = true;
                                isAnswerCorrect = option.isCorrect;
                                selectedAnswerId = option.optionId;
                                selectedTime = remainingTime;

                                if (isAnswerSelected && isAnswerCorrect) {
                                  score += currentQuestion.points *
                                      (selectedTime ?? 1);
                                  if (quizDetail.visibility == 'private') {
                                    SocketService().emitEvent('update-score', {
                                      'user_id': userId,
                                      'pin': widget.pin,
                                      'score': score,
                                    });
                                  }
                                }
                              });
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              color: optionColor,
                              child: IntrinsicHeight(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 3),
                                    child: Text(
                                      option.optionText,
                                      style: TextStyle(
                                        color: answers[currentQuestionIndex] ==
                                                option.optionId
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white, // Màu nền (có thể thay đổi)
                        border: Border.all(
                            color: Colors.red, width: 2), // Viền trắng
                        borderRadius: BorderRadius.circular(8), // Bo góc
                      ),
                      child: Text(
                        'Score: $score',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
