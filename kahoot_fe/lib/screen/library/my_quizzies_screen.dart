import 'package:flutter/material.dart';
import 'package:kahoot_clone/screen/quiz/quiz_detail_screen.dart';
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
  String _searchQuery = '';

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
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search quizzes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query.toLowerCase();
                });
              },
            ),
          ),
        ),
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          if (quizProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final filteredQuizzes = quizProvider.ownQuizzes.where((quiz) {
            return quiz.title.toLowerCase().contains(_searchQuery);
          }).toList();

          if (filteredQuizzes.isEmpty) {
            return const Center(child: Text('No quizzes found.'));
          }

          return ListView.builder(
            itemCount: filteredQuizzes.length,
            itemBuilder: (context, index) {
              Quiz quiz = filteredQuizzes[index];
              bool isLastItem = index == filteredQuizzes.length - 1;

              return Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0),
                    leading: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(8), // Bo tròn góc nếu cần
                      child: Image.network(
                        quiz.coverImage,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null)
                            return child; // Ảnh tải xong thì hiển thị

                          return SizedBox(
                            width: 50,
                            height: 50,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2, // Độ dày vòng tròn loading
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image,
                              size: 50, color: Colors.grey);
                        },
                      ),
                    ),
                    title: Text(quiz.title),
                    subtitle: Text(quiz.description.length > 30
                        ? quiz.description.substring(0, 30) + '...'
                        : quiz.description),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizDetailPage(quizId: quiz.id),
                        ),
                      );
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
