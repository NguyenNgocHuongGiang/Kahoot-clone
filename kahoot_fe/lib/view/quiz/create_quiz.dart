import 'package:flutter/material.dart';
import 'package:kahoot_clone/view/authentication/login_page.dart';

class CreateQuizPage extends StatefulWidget {
  const CreateQuizPage({super.key});

  @override
  _CreateQuizPageState createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final TextEditingController quizNameController = TextEditingController();
  final TextEditingController quizDescriptionController = TextEditingController();
  final TextEditingController quizTimeController = TextEditingController();

  bool _isLoggedIn = false; // Replace this with actual authentication check

  @override
  void initState() {
    super.initState();
    // Simulate checking if user is logged in
    _checkUserLoginStatus();
  }

  void _checkUserLoginStatus() {
    // This should be replaced with actual login status check logic
    setState(() {
      _isLoggedIn = false; // Update based on actual login status
      if (!_isLoggedIn) {
        // Navigate directly to LoginPage if not logged in
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return const SizedBox.shrink(); // Prevent rendering while navigating
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Quiz'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Create a New Quiz',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // Quiz Name Input
              TextField(
                controller: quizNameController,
                decoration: InputDecoration(
                  labelText: 'Quiz Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: const Icon(Icons.quiz, color: Colors.purple),
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
                  prefixIcon: const Icon(Icons.description, color: Colors.purple),
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
                  prefixIcon: const Icon(Icons.timer, color: Colors.purple),
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
                  backgroundColor: Colors.purple,
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
        backgroundColor: Colors.purple,
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
                backgroundColor: Colors.purple,
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
