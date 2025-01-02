import 'package:flutter/material.dart';
import 'package:kahoot_clone/screen/quiz/create_question_screen.dart';
import 'package:kahoot_clone/services/quiz/quiz_detail_model.dart';
import 'package:kahoot_clone/services/quiz/quiz_service.dart';

class QuizDetailPage extends StatefulWidget {
  final int? quizId;

  const QuizDetailPage({super.key, required this.quizId});

  @override
  _QuizDetailPageState createState() => _QuizDetailPageState();
}

class _QuizDetailPageState extends State<QuizDetailPage> {
  late Future<QuizDetail> _quizFuture;

  @override
  void initState() {
    super.initState();
    _quizFuture = QuizService().fetchQuizDetailById(widget.quizId ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Details')),
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
                    Image.asset(quiz.coverImage,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/default-quiz.png',  // Đường dẫn đến ảnh mặc định trong assets
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
                          Text(
                            quiz.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
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
                                onPressed: () {},
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
                                child: const Text('Create new game'),
                              ),
                              const SizedBox(width: 10),
                              // Edit quiz button
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CreateQuestionScreen(
                                              quizId: widget.quizId!),
                                    ),
                                  );
                                },
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
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ExpansionTile(
                            title: Text(
                              '${index + 1}. ${question.questionText}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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
                                ],
                              ),
                            ],
                          ),
                          const Divider(),
                        ],
                      );
                    },
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
