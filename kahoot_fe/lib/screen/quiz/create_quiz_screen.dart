import 'package:flutter/material.dart';
import 'package:kahoot_clone/common/common.dart';
import 'package:kahoot_clone/screen/authentication/login_screen.dart';
import 'package:kahoot_clone/screen/quiz/create_question_screen.dart';
import 'package:kahoot_clone/services/quiz/quiz_model.dart';
import 'package:kahoot_clone/services/quiz/quiz_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateQuizPage extends StatefulWidget {
  const CreateQuizPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateQuizPageState createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final TextEditingController quizNameController = TextEditingController();
  final TextEditingController quizDescriptionController =
      TextEditingController();
  final TextEditingController quizTimeController = TextEditingController();
  final TextEditingController quizCategoryController = TextEditingController();

  late Future<bool> _isLoggedInFuture;

  String quizVisibility = 'public'; 

  @override
  void initState() {
    super.initState();
    _isLoggedInFuture = checkUserLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isLoggedInFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!) {
          return const LoginPage();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Create a new quiz',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Colors.red,
            elevation: 0,
            leading: null,
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Quiz Name Input
                  TextField(
                    controller: quizNameController,
                    decoration: InputDecoration(
                      labelText: 'Quiz Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: const Icon(Icons.quiz, color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quiz Description Input
                  TextField(
                    controller: quizDescriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Quiz Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon:
                          const Icon(Icons.description, color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quiz Time Input
                  TextField(
                    controller: quizTimeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Quiz Time (in minutes)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: const Icon(Icons.timer, color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quiz Category Input
                  TextField(
                    controller: quizCategoryController,
                    decoration: InputDecoration(
                      labelText: 'Quiz category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: const Icon(Icons.category_outlined,
                          color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quiz Visibility Input (Public/Private)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: quizVisibility,
                              isExpanded: true,
                              onChanged: (String? newValue) {
                                setState(() {
                                  quizVisibility = newValue!;
                                });
                              },
                              dropdownColor: Colors.white,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              items: <String>[
                                'public',
                                'private'
                              ].map<DropdownMenuItem<String>>((String value) {
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

                  const SizedBox(height: 32),

                  // Create Quiz Button
                  ElevatedButton(
                    onPressed: () async {
                      final String quizName = quizNameController.text.trim();
                      final String quizDescription =
                          quizDescriptionController.text.trim();
                      final String quizTime = quizTimeController.text.trim();
                      final String quizCategory =
                          quizCategoryController.text.trim();

                      if (quizName.isEmpty ||
                          quizDescription.isEmpty ||
                          quizTime.isEmpty ||
                          quizCategory.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              'Please fill in all the fields!',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                        return;
                      }

                      final prefs = await SharedPreferences.getInstance();
                      String? token = prefs.getString('token');
                      String? userId = prefs.getString('user_id');

                      if (token != null && userId != null) {
                        final newQuiz = Quiz(
                          title: quizName,
                          description: quizDescription,
                          creator: userId,
                          coverImage: 'assets/images/default-quiz.png',
                          visibility: quizVisibility,
                          category: quizCategory,
                        );

                        try {
                          final quiz = await QuizService().createQuiz(newQuiz, token);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateQuestionScreen(quizId: quiz.id!)),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Failed to create quiz: $e')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Create Quiz',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// 