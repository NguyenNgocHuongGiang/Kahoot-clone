import 'package:flutter/material.dart';
import 'package:kahoot_clone/services/question/question_model.dart';
import 'package:kahoot_clone/services/question/question_service.dart';
import 'package:kahoot_clone/services/quiz/quiz_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

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
  String optionAId = '';
  String optionBId = '';
  String optionCId = '';
  String optionDId = '';
  File? _image;
  bool _isUploading = false;

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
    } catch (e) {
      print('Error loading question data: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _isUploading = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _image = File(pickedFile.path);
        _isUploading = false;
      });
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
            maxLength: 130,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                setState(() {
                  question = questionController.text;
                });
                String imageUrl = '';
                if (_image != null) {
                  imageUrl = await QuizService().uploadImage(_image!);
                }
                final newQuestion = QuestionDetail(
                  quizId: widget.quizId,
                  questionText: question,
                  questionType: 'multiple_choice',
                  mediaUrl: imageUrl ,
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

    String currentAnswer = '';
    bool currentIsCorrect = false;

    // Kiểm tra đáp án hiện tại
    if (option == 'A' && answerA.isNotEmpty) {
      currentAnswer = answerA;
      currentIsCorrect = correctAnswer == 'A';
    } else if (option == 'B' && answerB.isNotEmpty) {
      currentAnswer = answerB;
      currentIsCorrect = correctAnswer == 'B';
    } else if (option == 'C' && answerC.isNotEmpty) {
      currentAnswer = answerC;
      currentIsCorrect = correctAnswer == 'C';
    } else if (option == 'D' && answerD.isNotEmpty) {
      currentAnswer = answerD;
      currentIsCorrect = correctAnswer == 'D';
    }

    optionController.text = currentAnswer;
    isCorrect = currentIsCorrect;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return AlertDialog(
              title: Text('Enter answer for $option'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: optionController,
                    decoration:
                        InputDecoration(hintText: "Enter option $option"),
                    maxLength: 50,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Is this the correct answer?'),
                      Switch(
                        value: isCorrect,
                        onChanged: (bool value) {
                          setStateDialog(() {
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
                      if (currentAnswer.isEmpty) {
                        final newOption = OptionDetail(
                          questionId: questionId,
                          optionText: enteredAnswer,
                          isCorrect: isCorrect,
                        );

                        // Nếu không có câu trả lời, thêm mới
                        final optionCreated = await QuestionAndOptionService()
                            .addOption(newOption);

                        // Lưu lại ID mới trả về từ API
                        if (option == 'A')
                          optionAId = optionCreated.optionId.toString();
                        if (option == 'B')
                          optionBId = optionCreated.optionId.toString();
                        if (option == 'C')
                          optionCId = optionCreated.optionId.toString();
                        if (option == 'D')
                          optionDId = optionCreated.optionId.toString();
                      } else {
                        String? optionId;
                        if (option == 'A') optionId = optionAId;
                        if (option == 'B') optionId = optionBId;
                        if (option == 'C') optionId = optionCId;
                        if (option == 'D') optionId = optionDId;
                        if (optionId != null) {
                          final updatedOption = (
                            option_id: int.tryParse(optionId),
                            question_id: questionId,
                            option_text: enteredAnswer,
                            is_correct: isCorrect,
                          );
                          await QuestionAndOptionService()
                              .updateOption(updatedOption);
                        }
                      }

                      // Cập nhật đáp án trong trạng thái của widget
                      setState(() {
                        if (option == 'A') {
                          answerA = enteredAnswer;
                          if (isCorrect) correctAnswer = 'A';
                        } else if (option == 'B') {
                          answerB = enteredAnswer;
                          if (isCorrect) correctAnswer = 'B';
                        } else if (option == 'C') {
                          answerC = enteredAnswer;
                          if (isCorrect) correctAnswer = 'C';
                        } else if (option == 'D') {
                          answerD = enteredAnswer;
                          if (isCorrect) correctAnswer = 'D';
                        }
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Add Question', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upload image
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     GestureDetector(
            //       onTap: () {},
            //       child: Container(
            //         width: 300,
            //         height: 200,
            //         color: Colors.grey[100],
            //         child: const Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Icon(Icons.upload),
            //             Text('Add media'),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 300,
                    height: 200,
                    color: Colors.grey[100],
                    child: _isUploading
                        ? const Center(
                            child:
                                CircularProgressIndicator()) // Hiển thị loading khi đang tải lên
                        : _image == null
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.upload),
                                  Text('Add media'),
                                ],
                              )
                            : Image.file(_image!,
                                fit: BoxFit.cover), // Hiển thị ảnh khi đã chọn
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
                      height: 80,
                      color: Colors.red,
                      padding: const EdgeInsets.all(8),
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
                      height: 80,
                      color: Colors.blue,
                      padding: const EdgeInsets.all(8),
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
                      height: 80,
                      color: Colors.yellow,
                      padding: const EdgeInsets.all(8),
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
                      height: 80,
                      color: Colors.green,
                      padding: const EdgeInsets.all(8),
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
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
    )),
    );
  }
}
