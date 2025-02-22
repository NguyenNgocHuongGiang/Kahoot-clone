import 'package:flutter/material.dart';
import 'package:kahoot_clone/components/quiz_card.dart';
import 'package:kahoot_clone/providers/quiz_provider.dart';
import 'package:kahoot_clone/services/quiz/quiz_model.dart';
import 'package:provider/provider.dart';

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({super.key});

  @override
  _DiscoveryPageState createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizProvider>().fetchTopQuizzes(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Discovery',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 0,
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          if (quizProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          var quizzes = quizProvider.quizzes;

          if (quizzes.isEmpty) {
            return const Center(child: Text('No quizzes available.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7,
            ),
            itemCount: quizzes.length,
            itemBuilder: (context, index) {
              Quiz quiz = quizzes[index];
              return QuizCard(
                index: index,
                quizId: quiz.id,
                imageUrl: quiz.coverImage,
                title: quiz.title,
                description: quiz.description,
                height: MediaQuery.of(context).size.width * 1,
                width: MediaQuery.of(context).size.width - 16,
              );
            },
          );
        },
      ),
    );
  }
}
