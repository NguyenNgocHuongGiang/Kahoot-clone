import 'package:flutter/material.dart';
import 'package:kahoot_clone/services/question/question_model.dart';
import 'package:kahoot_clone/services/question/question_service.dart';
import 'package:kahoot_clone/services/quiz/quiz_service.dart';

class CreateQuestionScreen extends StatefulWidget {
  final int quizId;

  CreateQuestionScreen({required this.quizId});

  @override
  _CreateQuestionScreenState createState() => _CreateQuestionScreenState();
}

class _CreateQuestionScreenState extends State<CreateQuestionScreen> {
  String question = '';
  String answerA = '', answerB = '', answerC = '', answerD = '';
  String correctAnswer = '';
  int timerDuration = 20;
  int questionId = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestionData();
  }

  void resetFields() {
    setState(() {
      question = '';
      answerA = '';
      answerB = '';
      answerC = '';
      answerD = '';
      correctAnswer = '';
      timerDuration = 20; 
      questionId = 0; 
    });
  }

  Future<void> _loadQuestionData() async {
    try {
      final questionData =
          await QuizService().fetchQuizDetailById(widget.quizId);

      print('Quiz ID: ${questionData.quizId}');
      print('Title: ${questionData.title}');
      print('Description: ${questionData.description}');
      print('Number of Questions: ${questionData.questions.length}');

      for (var question in questionData.questions) {
        print('Question ID: ${question.questionId}');
        print('Question Text: ${question.questionText}');
        print('Question Type: ${question.questionType}');
        print('Options:');

        // In chi tiết các lựa chọn cho từng câu hỏi
        for (var option in question.options) {
          print('  Option ID: ${option.optionId}');
          print('  Option Text: ${option.optionText}');
          print('  Is Correct: ${option.isCorrect}');
        }
      }
    } catch (e) {
      print('Error loading question data: $e');
    }
  }

  void _showTimeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Timer Duration'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        for (var time in [5, 10, 20, 30, 45])
                          ListTile(
                            title: Text('$time sec'),
                            onTap: () {
                              setState(() {
                                timerDuration = time;
                              });
                              Navigator.pop(context);
                            },
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        for (var time in [60, 90, 120, 180, 240])
                          ListTile(
                            title: Text('$time sec'),
                            onTap: () {
                              setState(() {
                                timerDuration = time;
                              });
                              Navigator.pop(context);
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showQuestionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController questionController = TextEditingController();
        return AlertDialog(
          title: const Text('Enter your question'),
          content: TextField(
            controller: questionController,
            decoration: const InputDecoration(hintText: "Enter the question"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                setState(() {
                  question = questionController.text;
                });
                final newQuestion = QuestionDetail(
                  quizId: widget.quizId,
                  questionText: question,
                  questionType: 'multiple_choice',
                  mediaUrl: '/assets/images/default-quiz.png',
                  timeLimit: timerDuration,
                  points: 10,
                );
                try {
                  final questionCreated =
                      await QuestionAndOptionService().addQuestion(newQuestion);
                  questionId = questionCreated.questionId ?? 0;
                } catch (e) {
                  print('Failed to add question: $e');
                }

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showOptionDialog(String option) {
    TextEditingController optionController = TextEditingController();
    bool isCorrect = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter answer for $option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: optionController,
                decoration: InputDecoration(hintText: "Enter option $option"),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Is this the correct answer?'),
                  Switch(
                    value: isCorrect,
                    onChanged: (bool value) {
                      setState(() {
                        isCorrect = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                String enteredAnswer = optionController.text;
                if (enteredAnswer.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Answer cannot be empty')),
                  );
                  return;
                }
                try {
                  final newOption = OptionDetail(
                    questionId: questionId,
                    optionText: enteredAnswer,
                    isCorrect: isCorrect,
                  );
                  print(newOption);
                  await QuestionAndOptionService().addOption(newOption);

                  setState(() {
                    if (option == 'A') answerA = enteredAnswer;
                    if (option == 'B') answerB = enteredAnswer;
                    if (option == 'C') answerC = enteredAnswer;
                    if (option == 'D') answerD = enteredAnswer;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Answer $option saved successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Failed to save answer $option: $e')),
                  );
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upload image
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 300,
                    height: 200,
                    color: Colors.grey[100],
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload),
                        Text('Add media'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            GestureDetector(
              onTap: _showQuestionDialog,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.grey[300],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      question.isEmpty ? 'Tap to enter question' : question,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showOptionDialog('A'),
                    child: Container(
                      height: 70,
                      color: Colors.red,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 2),
                      child: Center(
                        child: Text(answerA.isEmpty ? 'A' : answerA),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showOptionDialog('B'),
                    child: Container(
                      height: 70,
                      color: Colors.blue,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 2),
                      child: Center(
                        child: Text(answerB.isEmpty ? 'B' : answerB),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showOptionDialog('C'),
                    child: Container(
                      height: 70,
                      color: Colors.yellow,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 1),
                      child: Center(
                        child: Text(answerC.isEmpty ? 'C' : answerC),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showOptionDialog('D'),
                    child: Container(
                      height: 70,
                      color: Colors.green,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 1),
                      child: Center(
                        child: Text(answerD.isEmpty ? 'D' : answerD),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {},
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.timer),
                      onPressed: _showTimeDialog,
                    ),
                    Text('$timerDuration seconds'),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: resetFields,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
