import 'package:kahoot_clone/components/quiz_card.dart'; // Import QuizCard widget
import 'package:flutter/material.dart';
import 'package:kahoot_clone/services/quiz/quiz_model.dart';
import 'package:kahoot_clone/providers/quiz_provider.dart';
import 'package:provider/provider.dart';

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DiscoveryPageState createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  @override
  void initState() {
    super.initState();
    // Gọi fetchQuizzes sau khi widget đã được dựng xong
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizProvider>().fetchQuizzes();
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
        leading: null,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          if (quizProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          var publicQuizzes = quizProvider.quizzes
              .where((quiz) => quiz.visibility == 'public')
              .toList();

          if (publicQuizzes.isEmpty) {
            return const Center(child: Text('No public quizzes available.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, 
              crossAxisSpacing: 10,  
              mainAxisSpacing: 10,   
              childAspectRatio: 0.7, 
            ),
            itemCount: publicQuizzes.length,
            itemBuilder: (context, index) {
              Quiz quiz = publicQuizzes[index];
              return QuizCard(
                index: index,
                imageUrl: quiz.coverImage,
                title: quiz.title,
                description: quiz.description,
                height: MediaQuery.of(context).size.width * 0.9,
                width: MediaQuery.of(context).size.width - 16,
              );
            },
          );
        },
      ),
    );
  }
}
