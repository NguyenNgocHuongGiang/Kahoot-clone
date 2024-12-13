import 'package:flutter/material.dart';

class JoinQuizPage extends StatefulWidget {
  const JoinQuizPage({super.key});

  @override
  _JoinQuizPageState createState() => _JoinQuizPageState();
}

class _JoinQuizPageState extends State<JoinQuizPage> {
  TextEditingController codeController = TextEditingController();
  bool isPinEntered = false; // Kiểm tra xem mã PIN đã được nhập chưa
  bool isPinMode = true; // Kiểm tra chế độ hiện tại (Enter PIN hoặc Scan QR Code)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Card hiển thị nội dung chính
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Tiêu đề
                    const Text(
                      'Join a Quiz Game',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Hiển thị TextField nếu đang ở chế độ "Enter PIN"
                    if (isPinMode)
                      Column(
                        children: [
                          TextField(
                            controller: codeController,
                            decoration: InputDecoration(
                              labelText: 'Enter Quiz PIN',
                              labelStyle: const TextStyle(color: Colors.black54),
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: const Icon(Icons.vpn_key, color: Colors.red),
                            ),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              setState(() {
                                isPinEntered = value.isNotEmpty; // Kiểm tra mã PIN đã nhập hay chưa
                              });
                            },
                          ),
                          const SizedBox(height: 16),

                          // Nút Submit chỉ hiển thị khi mã PIN đã được nhập
                          if (isPinEntered)
                            ElevatedButton(
                              onPressed: () {
                                String quizCode = codeController.text.trim();
                                if (quizCode.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please enter a valid quiz code!'),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuizPage(quizCode: quizCode),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                               child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  'Join Quiz',
                                  style: TextStyle(fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      ),

                    // Chế độ Scan QR Code
                    if (!isPinMode)
                      const Center(
                        child: Text(
                          'QR Code scanning is not implemented yet.',
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Nút chuyển đổi chế độ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      isPinMode = true; // Chọn chế độ "Enter PIN"
                    });
                  },
                  icon: const Icon(Icons.keyboard),
                  label: const Text('Enter PIN'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPinMode ? Colors.red : Colors.grey[200],
                    foregroundColor: isPinMode ? Colors.white : Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      isPinMode = false; // Chọn chế độ "Scan QR Code"
                    });
                  },
                  icon: const Icon(Icons.qr_code),
                  label: const Text('Scan QR Code'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !isPinMode ? Colors.red : Colors.grey[200],
                    foregroundColor: !isPinMode ? Colors.white : Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Trang QuizPage hiển thị sau khi nhập mã thành công
class QuizPage extends StatelessWidget {
  final String quizCode;

  const QuizPage({super.key, required this.quizCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Page'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Text(
          'Welcome to Quiz $quizCode!',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
