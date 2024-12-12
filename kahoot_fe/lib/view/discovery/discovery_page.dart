import 'package:flutter/material.dart';
import 'package:kahoot_clone/common/constants.dart';
import 'package:kahoot_clone/services/http_service.dart';
import 'package:kahoot_clone/services/quiz_service.dart'; // Import service
import 'package:kahoot_clone/components/quiz_card.dart'; // Import QuizCard widget

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({super.key});

  @override
  _DiscoveryPageState createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  late Future<List<dynamic>> quizzes;
  late QuizService quizService;

  @override
  void initState() {
    super.initState();
    quizService =
        QuizService(httpService: HttpService(baseUrl: Constants.BASE_URL));
    quizzes = quizService.getAllQuizzes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: FutureBuilder<List<dynamic>>(
          future: quizzes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              List<dynamic> quizzesList = snapshot.data!;
              // Lọc chỉ các quiz có visibility là 'public'
              List<dynamic> publicQuizzes = quizzesList
                  .where((quiz) => quiz['visibility'] == 'public')
                  .toList();
              if (publicQuizzes.isEmpty) {
                return const Text('No public quizzes found');
              }
              return ListView.builder(
                itemCount: publicQuizzes.length,
                itemBuilder: (context, index) {
                  var quiz = publicQuizzes[index];
                  return QuizCard(
                    index: index,
                    imageUrl: quiz['cover_image'],
                    title: quiz['title'],
                    description: quiz['description'],
                  );
                },
              );
            } else {
              return const Text('No quizzes found');
            }
          },
        ),
      ),
    );
  }
}
