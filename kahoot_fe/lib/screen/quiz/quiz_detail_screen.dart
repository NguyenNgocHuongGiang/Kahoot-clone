import 'package:flutter/material.dart';
import 'package:kahoot_clone/components/confirm_dialog.dart';
import 'package:kahoot_clone/screen/game-session/waiting_room_screen.dart';
import 'package:kahoot_clone/screen/quiz/create_question_screen.dart';
import 'package:kahoot_clone/screen/quiz/quiz_report_screen.dart';
import 'package:kahoot_clone/services/game-session/game_session_service.dart';
import 'package:kahoot_clone/services/question/question_service.dart';
import 'package:kahoot_clone/services/quiz/quiz_detail_model.dart';
import 'package:kahoot_clone/services/quiz/quiz_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class QuizDetailPage extends StatefulWidget {
  final int? quizId;

  const QuizDetailPage({super.key, required this.quizId});

  @override
  _QuizDetailPageState createState() => _QuizDetailPageState();
}

class _QuizDetailPageState extends State<QuizDetailPage> {
  late Future<QuizDetail> _quizFuture;
  Map<int, bool> isLongPressed = {};

  @override
  void initState() {
    super.initState();
    _quizFuture = QuizService().fetchQuizDetailById(widget.quizId ?? 0);
  }

  void _showEditDialog(BuildContext context, QuestionDetail question) {
    TextEditingController questionController = TextEditingController();
    questionController.text = question.questionText;

    TextEditingController mediaUrlController = TextEditingController();
    mediaUrlController.text = question.mediaUrl;

    List<String> timeLimits = [
      "5 seconds",
      "10 seconds",
      "20 seconds",
      "30 seconds",
      "45 seconds",
      "60 seconds",
      "90 seconds",
      "120 seconds",
      "150 seconds",
      "240 seconds"
    ];
    String selectedTimeLimit = '${question.timeLimit} seconds' ?? timeLimits[0];

    List<TextEditingController> optionControllers = [];
    List<bool> isCorrectAnswers = [];
    List<String> options =
        question.options.map((option) => option.optionText).toList();

    for (int i = 0; i < options.length; i++) {
      optionControllers.add(TextEditingController());
      optionControllers[i].text = options[i];

      isCorrectAnswers
          .add(question.options[i].isCorrect); // Đánh dấu câu trả lời đúng
    }

    // Biến để lưu ảnh đã chọn
    XFile? selectedImage;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: SingleChildScrollView(
                    // Thêm phần này
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: questionController,
                            decoration: const InputDecoration(
                                hintText: "Edit your question"),
                          ),
                          const SizedBox(height: 20),
                          if (question.mediaUrl.isNotEmpty)
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final ImagePicker picker = ImagePicker();
                                    final XFile? pickedFile = await picker
                                        .pickImage(source: ImageSource.gallery);
                                    if (pickedFile != null) {
                                      setState(() {
                                        selectedImage = pickedFile;
                                      });
                                    }
                                  },
                                  child: selectedImage != null
                                      ? Image.file(
                                          File(selectedImage!.path),
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          question.mediaUrl,
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              'https://res.cloudinary.com/dlrd3ngz5/image/upload/v1738783278/kahoot_clone/tiazt9rtbc1thccrgw58.jpg',
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            )
                          else
                          // Kiểm tra nếu có ảnh mới được chọn thì hiển thị ảnh đó
                          if (selectedImage != null)
                            Column(
                              children: [
                                Image.file(
                                  File(selectedImage!.path),
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () async {
                                    final ImagePicker picker = ImagePicker();
                                    final XFile? pickedFile = await picker
                                        .pickImage(source: ImageSource.gallery);
                                    if (pickedFile != null) {
                                      setDialogState(() {
                                        selectedImage = pickedFile;
                                      });
                                    }
                                  },
                                  child: const Text('Change Image'),
                                ),
                              ],
                            )
                          else if (question.mediaUrl.isNotEmpty)
                            Column(
                              children: [
                                Image.network(
                                  question.mediaUrl,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'https://res.cloudinary.com/dlrd3ngz5/image/upload/v1738783278/kahoot_clone/tiazt9rtbc1thccrgw58.jpg',
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () async {
                                    final ImagePicker picker = ImagePicker();
                                    final XFile? pickedFile = await picker
                                        .pickImage(source: ImageSource.gallery);
                                    if (pickedFile != null) {
                                      setDialogState(() {
                                        selectedImage = pickedFile;
                                      });
                                    }
                                  },
                                  child: const Text('Change Image'),
                                ),
                              ],
                            )
                          else
                            Column(
                              children: [
                                const Text('No image attached'),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () async {
                                    final ImagePicker picker = ImagePicker();
                                    final XFile? pickedFile = await picker
                                        .pickImage(source: ImageSource.gallery);
                                    if (pickedFile != null) {
                                      setDialogState(() {
                                        selectedImage = pickedFile;
                                      });
                                    }
                                  },
                                  child: const Text('Add Image'),
                                ),
                              ],
                            ),

                          Column(
                            children: List.generate(options.length, (index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: optionControllers[index],
                                    ),
                                  ),
                                  Checkbox(
                                    value: isCorrectAnswers[index],
                                    onChanged: (bool? value) {
                                      setDialogState(() {
                                        for (int i = 0;
                                            i < isCorrectAnswers.length;
                                            i++) {
                                          isCorrectAnswers[i] = false;
                                        }
                                        isCorrectAnswers[index] = value!;
                                      });
                                    },
                                  ),
                                ],
                              );
                            }),
                          ),
                          const SizedBox(height: 20),

                          // Thêm DropdownButton để chọn timeLimit
                          DropdownButton<String>(
                            value: selectedTimeLimit,
                            onChanged: (String? newValue) {
                              setDialogState(() {
                                selectedTimeLimit = newValue!;
                              });
                            },
                            items: timeLimits
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  bool hasQuestionChanged = false;
                                  if (questionController.text !=
                                      question.questionText) {
                                    hasQuestionChanged = true;
                                  }
                                  if (selectedTimeLimit !=
                                      '${question.timeLimit} seconds') {
                                    hasQuestionChanged = true;
                                  }
                                  if (selectedImage?.path !=
                                      question.mediaUrl) {
                                    hasQuestionChanged = true;
                                  }
                                  String imageUrl = mediaUrlController.text;
                                  if (selectedImage != null) {
                                    imageUrl = await QuizService()
                                        .uploadImage(selectedImage!);
                                  }
                                  if (hasQuestionChanged) {
                                    final updatedQuestion = (
                                      question_id: question.questionId,
                                      quiz_id: question.quizId,
                                      question_text: questionController.text,
                                      question_type: question.questionType,
                                      time_limit: int.parse(
                                          selectedTimeLimit.split(' ')[0]),
                                      media_url: imageUrl,
                                      points: question.points,
                                      // options: question.options,
                                    );
                                    await QuestionAndOptionService()
                                        .updateQuestion(updatedQuestion);
                                    setState(() {
                                      _quizFuture = QuizService()
                                          .fetchQuizDetailById(
                                              widget.quizId ?? 0);
                                    });
                                  }

                                  for (int i = 0; i < options.length; i++) {
                                    if (optionControllers[i].text !=
                                            options[i] ||
                                        isCorrectAnswers[i] !=
                                            question.options[i].isCorrect) {
                                      final updatedOption = (
                                        option_id: question.options[i].optionId,
                                        question_id:
                                            question.options[i].questionId,
                                        option_text: optionControllers[i].text,
                                        is_correct: isCorrectAnswers[i],
                                      );
                                      await QuestionAndOptionService()
                                          .updateOption(updatedOption);
                                      setState(() {
                                        _quizFuture = QuizService()
                                            .fetchQuizDetailById(
                                                widget.quizId ?? 0);
                                      });
                                    }
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Save'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ));
            },
          );
        });
  }

  void _showEditQuizModal(BuildContext context, QuizDetail quiz) {
    TextEditingController titleController =
        TextEditingController(text: quiz.title);
    TextEditingController descriptionController =
        TextEditingController(text: quiz.description);
    TextEditingController categoryController =
        TextEditingController(text: quiz.category);
    TextEditingController coverImageController =
        TextEditingController(text: quiz.coverImage);
    TextEditingController visibilityController =
        TextEditingController(text: quiz.visibility);

    File? _selectedImage;

    final ImagePicker _picker = ImagePicker();

    String initialVisibility = quiz.visibility;

    Future<void> _pickImage() async {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path); // Lưu file tạm thời
          coverImageController.text = pickedFile.path; // Cập nhật đường dẫn tạm
        });
      }
      print(_selectedImage);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            // Dùng StatefulBuilder để cập nhật giao diện ngay
            builder: (context, setState) {
          return Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Edit quiz', style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 20),
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: descriptionController,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: categoryController,
                        decoration:
                            const InputDecoration(labelText: 'Category'),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: visibilityController.text,
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      visibilityController.text = newValue!;
                                    });
                                  },
                                  dropdownColor: Colors.white,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  items: <String>['public', 'private']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Row(
                                        children: [
                                          Icon(
                                            value == 'public'
                                                ? Icons.public
                                                : Icons.lock,
                                            color: value == 'public'
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(value),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // GestureDetector(
                      //   onTap: _pickImage,
                      //   child: _selectedImage != null
                      //       ? Image.file(
                      //           _selectedImage!,
                      //           width: 120,
                      //           height: 120,
                      //           fit: BoxFit.cover,
                      //         )
                      //       : coverImageController.text.isNotEmpty
                      //           ? Image.network(
                      //               coverImageController.text,
                      //               width: 120,
                      //               height: 120,
                      //               fit: BoxFit.cover,
                      //               errorBuilder: (context, error, stackTrace) {
                      //                 return Image.asset(
                      //                   'https://res.cloudinary.com/dlrd3ngz5/image/upload/v1738783278/kahoot_clone/tiazt9rtbc1thccrgw58.jpg',
                      //                   width: 120,
                      //                   height: 120,
                      //                   fit: BoxFit.cover,
                      //                 );
                      //               },
                      //             )
                      //           : Image.asset(
                      //               'https://res.cloudinary.com/dlrd3ngz5/image/upload/v1738783278/kahoot_clone/tiazt9rtbc1thccrgw58.jpg',
                      //               width: 120,
                      //               height: 120,
                      //               fit: BoxFit.cover,
                      //             ),
                      // ),
                      GestureDetector(
                        onTap: () async {
                          final XFile? pickedFile = await _picker.pickImage(
                              source: ImageSource.gallery);

                          if (pickedFile != null) {
                            setState(() {
                              _selectedImage = File(
                                  pickedFile.path); // Cập nhật hình ảnh mới
                              coverImageController.text =
                                  pickedFile.path; // Cập nhật đường dẫn mới
                            });
                          }
                        },
                        child: _selectedImage != null
                            ? Image.file(
                                _selectedImage!,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              )
                            : coverImageController.text.isNotEmpty
                                ? Image.network(
                                    coverImageController.text,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'https://res.cloudinary.com/dlrd3ngz5/image/upload/v1738783278/kahoot_clone/tiazt9rtbc1thccrgw58.jpg',
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    'https://res.cloudinary.com/dlrd3ngz5/image/upload/v1738783278/kahoot_clone/tiazt9rtbc1thccrgw58.jpg',
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                      ),

                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel',
                                style: TextStyle(color: Colors.grey)),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              var token = prefs.getString('token');
                              var userIdString = prefs.getString('user_id');

                              String imageUrl = coverImageController
                                  .text; // Mặc định là coverImageController.text
                              if (_selectedImage != null) {
                                imageUrl = await QuizService()
                                    .uploadImage(_selectedImage!);
                              }

                              final updatedQuiz = QuizDetail(
                                quizId: quiz.quizId,
                                title: titleController.text,
                                description: descriptionController.text,
                                creator: userIdString ?? "",
                                coverImage:
                                    imageUrl, // Đảm bảo coverImageController.text được cập nhật
                                category: categoryController.text,
                                questions: quiz.questions ?? [],
                                visibility: visibilityController.text,
                              );

                              try {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                final token = prefs.getString('token');
                                final userId = prefs.getString('user_id');
                                final gameSession = await GameSessionService()
                                    .getGameSessionByQuizId(
                                        id: (widget.quizId ?? 0).toString(),
                                        token: token ?? '');

                                print(visibilityController.text);
                                if (visibilityController.text !=
                                    initialVisibility) {
                                  if (visibilityController.text == 'public') {
                                    await GameSessionService()
                                        .createGameSession(
                                            quiz_id: widget.quizId!,
                                            host: userId ?? '',
                                            token: token ?? '');
                                  } else {
                                    if (gameSession[gameSession.length - 1] !=
                                        null) {
                                      await GameSessionService()
                                          .updateGameSessionStatus(
                                              token: token ?? '',
                                              sessionId: gameSession[
                                                      gameSession.length - 1]
                                                  ['session_id'],
                                              status: 'inactive');
                                    }
                                  }
                                }
                                await QuizService().updateQuizDetail(
                                    token, updatedQuiz.quizId, updatedQuiz);
                                setState(() {
                                  _quizFuture = QuizService()
                                      .fetchQuizDetailById(widget.quizId ?? 0);
                                });
                                Navigator.of(context).pop();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Failed to update quiz: $e')),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Save',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quiz Details',
          style: TextStyle(
            color: Colors.white, // Màu chữ trắng
            fontWeight: FontWeight.bold, // Chữ đậm hơn
          ),
        ),
        backgroundColor: Colors.red, // Màu nền đỏ
        iconTheme:
            const IconThemeData(color: Colors.white), // Màu mũi tên trắng
        centerTitle: true, // Căn giữa tiêu đề
      ),
      body: FutureBuilder<QuizDetail>(
        future: _quizFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Quiz not found'));
          }

          final quiz = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      quiz.coverImage,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'https://res.cloudinary.com/dlrd3ngz5/image/upload/v1738783278/kahoot_clone/tiazt9rtbc1thccrgw58.jpg',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                quiz.title.length > 10
                                    ? '${quiz.title.substring(0, 10)}...'
                                    : quiz.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert),
                                onSelected: (value) {
                                  if (value == 'report') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ReportScreen(quiz: quiz),
                                      ),
                                    );
                                  }
                                },
                                itemBuilder: (BuildContext context) => [
                                  const PopupMenuItem(
                                    value: 'report',
                                    child: Row(
                                      children: [
                                        Icon(Icons.bar_chart, size: 20),
                                        SizedBox(width: 8),
                                        Text('View report'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            quiz.description,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Category: ${quiz.category}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              // Create new game button
                              ElevatedButton(
                                onPressed: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  String? userId = prefs.getString('user_id');
                                  String? token = prefs.getString('token');
                                  try {
                                    final newGame = await GameSessionService()
                                        .createGameSession(
                                            quiz_id: widget.quizId!,
                                            host: userId ?? '',
                                            token: token ?? '');
                                    if (newGame != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              WaitingRoomScreen(
                                            gamePin: newGame['pin'],
                                          ),
                                        ),
                                      );
                                    } else {
                                      print('Failed to create game session');
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Failed to create quiz: $e')),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  textStyle: const TextStyle(
                                    fontSize: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('New game'),
                              ),
                              const SizedBox(width: 10),
                              // Edit quiz button
                              ElevatedButton(
                                onPressed: () =>
                                    _showEditQuizModal(context, quiz),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  textStyle: const TextStyle(
                                    fontSize: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Edit quiz'),
                              ),
                              const SizedBox(width: 10),
                              // More options button (Three dots)
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: quiz.questions.length,
                    itemBuilder: (context, index) {
                      final question = quiz.questions[index];
                      return GestureDetector(
                          onLongPress: () {
                            setState(() {
                              isLongPressed[index] =
                                  true; // Cập nhật trạng thái nhấn lâu cho câu hỏi này
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ExpansionTile(
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        question.questionText.length > 50
                                            ? '${question.questionText.substring(0, 50)}...'
                                            : question.questionText,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    if (question.mediaUrl
                                        .isNotEmpty) // Kiểm tra nếu có ảnh
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left:
                                                8.0), // Khoảng cách giữa chữ và ảnh
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              8), // Bo góc cho ảnh
                                          child: Image.network(
                                            question.mediaUrl,
                                            width: 50, // Kích thước ảnh nhỏ
                                            height: 50,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null)
                                                return child; // Ảnh tải xong thì hiển thị bình thường

                                              return SizedBox(
                                                width: 50,
                                                height: 50,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth:
                                                        2, // Độ dày vòng tròn loading
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            (loadingProgress
                                                                    .expectedTotalBytes ??
                                                                1)
                                                        : null,
                                                  ),
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                width: 50,
                                                height: 50,
                                                color: Colors.grey[
                                                    300], // Màu nền khi ảnh lỗi
                                                child: const Icon(
                                                    Icons.broken_image,
                                                    size: 30,
                                                    color: Colors.grey),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                children: [
                                  Column(
                                    children: [
                                      ...question.options.map((option) {
                                        return ListTile(
                                          title: Text(option.optionText),
                                          leading: Icon(
                                            option.isCorrect
                                                ? Icons.check_circle
                                                : Icons.radio_button_unchecked,
                                            color: option.isCorrect
                                                ? Colors.green
                                                : Colors.grey,
                                          ),
                                        );
                                      }).toList(),
                                      const Divider(),
                                      if (isLongPressed[index] ?? false)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                _showEditDialog(
                                                    context, question);
                                              },
                                              style: TextButton.styleFrom(
                                                backgroundColor:
                                                    Colors.yellow[700],
                                                minimumSize:
                                                    const Size(120, 40),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text(
                                                'Edit',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            TextButton(
                                              onPressed: () async {
                                                await showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return ConfirmationDialog(
                                                      onConfirmed: () async {
                                                        try {
                                                          await QuestionAndOptionService()
                                                              .deleteQuestion(
                                                                  question
                                                                      .questionId);
                                                          setState(() {
                                                            _quizFuture = QuizService()
                                                                .fetchQuizDetailById(
                                                                    widget.quizId ??
                                                                        0);
                                                          });
                                                        } catch (e) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                                content: Text(
                                                                    'Failed to delete question: $e')),
                                                          );
                                                        }
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                minimumSize:
                                                    const Size(120, 40),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text(
                                                'Delete',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          ));
                    },
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CreateQuestionScreen(quizId: widget.quizId!),
                      ),
                    );
                  }, // Hàm mở dialog thêm câu hỏi
                  child: const Text(
                    'Add Question',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
