import 'package:flutter/material.dart';
import 'package:kahoot_clone/common/common.dart';
import 'package:kahoot_clone/screen/authentication/login_screen.dart';

class CreateQuizPage extends StatefulWidget {
  const CreateQuizPage({super.key});

  @override
  _CreateQuizPageState createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final TextEditingController quizNameController = TextEditingController();
  final TextEditingController quizDescriptionController = TextEditingController();
  final TextEditingController quizTimeController = TextEditingController();

  late Future<bool> _isLoggedInFuture;

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
          return const Center(child: CircularProgressIndicator()); // Đợi kết quả
        }

        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!) {
          // Nếu người dùng chưa đăng nhập, chuyển hướng đến trang LoginPage
          return const LoginPage();
        }

        // Nếu người dùng đã đăng nhập, hiển thị trang tạo quiz
        return Scaffold(
          appBar: AppBar(
        title: const Text(
          'Create a new quiz',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 0,
        leading: null,
        automaticallyImplyLeading: false,
      ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
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
                      prefixIcon: const Icon(Icons.description, color: Colors.red),
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
                  const SizedBox(height: 32),

                  // Create Quiz Button
                  ElevatedButton(
                    onPressed: () {
                      final String quizName = quizNameController.text.trim();
                      final String quizDescription = quizDescriptionController.text.trim();
                      final String quizTime = quizTimeController.text.trim();

                      if (quizName.isEmpty || quizDescription.isEmpty || quizTime.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all the fields!'),
                          ),
                        );
                        return;
                      }

                      // Navigate to Quiz Overview Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizOverviewPage(
                            quizName: quizName,
                            quizDescription: quizDescription,
                            quizTime: quizTime,
                          ),
                        ),
                      );
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

class QuizOverviewPage extends StatelessWidget {
  final String quizName;
  final String quizDescription;
  final String quizTime;

  const QuizOverviewPage({
    super.key,
    required this.quizName,
    required this.quizDescription,
    required this.quizTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Overview'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Quiz Details',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Quiz Name: $quizName',
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Text(
              'Description: $quizDescription',
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Text(
              'Duration: $quizTime minutes',
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Go Back',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
