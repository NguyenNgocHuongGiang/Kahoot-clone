import 'package:flutter/material.dart';
import 'package:kahoot_clone/services/quiz/quiz_model.dart';
import 'package:kahoot_clone/providers/quiz_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyQuizziesScreen extends StatefulWidget {
  final VoidCallback onSave;

  const MyQuizziesScreen({super.key, required this.onSave});

  @override
  _MyQuizziesScreenState createState() => _MyQuizziesScreenState();
}

class _MyQuizziesScreenState extends State<MyQuizziesScreen> {
  String? _userId;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }


  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('user_id');
    _token = prefs.getString('token');

    if (_userId != null && _token != null) {
      context.read<QuizProvider>().fetchQuizzesByUserId(_userId!, _token!);
    } else {
      print('User data is missing.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          if (quizProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (quizProvider.ownQuizzes.isEmpty) {
            return const Center(child: Text('No public quizzes available.'));
          }

          return ListView.builder(
            itemCount: quizProvider.ownQuizzes.length,
            itemBuilder: (context, index) {
              Quiz quiz = quizProvider.ownQuizzes[index];
              bool isLastItem = index == quizProvider.ownQuizzes.length - 1;

              return Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0),
                    leading: Image.network(
                      quiz.coverImage,
                      width: 50.0,
                      height: 50.0,
                      fit: BoxFit.cover,
                    ),
                    title: Text(quiz.title),
                    subtitle: Text(quiz.description),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => QuizDetailPage(quizId: quiz.id),
                      //   ),
                      // );
                    },
                  ),
                  if (!isLastItem)
                    const Divider(), // Thêm Divider nếu không phải phần tử cuối
                ],
              );
            },
          );
        },
      ),
    );
  }
}
