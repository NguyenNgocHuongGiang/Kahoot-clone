import 'package:flutter/material.dart';
import 'package:kahoot_clone/common/common.dart';
import 'package:kahoot_clone/screen/authentication/login_screen.dart';
import 'package:kahoot_clone/screen/game-session/waiting_room_screen.dart';
import 'package:kahoot_clone/services/game-session/game_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JoinQuizPage extends StatefulWidget {
  const JoinQuizPage({super.key});

  @override
  _JoinQuizPageState createState() => _JoinQuizPageState();
}

class _JoinQuizPageState extends State<JoinQuizPage> {
  TextEditingController codeController = TextEditingController();
  bool isPinEntered = false;
  bool isPinMode = true;
  late Future<bool> _isLoggedInFuture;

  @override
  void initState() {
    super.initState();
     _isLoggedInFuture = checkUserLoginStatus();
  }

  Future<bool> _checkPin(String token, String pin) async {
    bool flag = false;
    try {
      final response = await GameSessionService()
          .getGameSessionByPIN(token: token, pin: pin);
      if (response['gameSession']['status'] == 'active') {
        flag = true;
      }
    } catch (error) {
      print('Failed to create player session: $error');
    }
    return flag;
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
                padding: const EdgeInsets.symmetric(
                    vertical: 50.0, horizontal: 25.0),
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
                              labelStyle:
                                  const TextStyle(color: Colors.black54),
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon:
                                  const Icon(Icons.vpn_key, color: Colors.red),
                            ),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              setState(() {
                                isPinEntered = value.isNotEmpty;
                              });
                            },
                          ),
                          const SizedBox(height: 16),

                          // Nút tham gia quiz
                          if (isPinEntered)
                            ElevatedButton(
                              onPressed: () async {
                                String quizPin = codeController.text.trim();
                                if (quizPin.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Please enter a valid quiz pin!')),
                                  );
                                } else {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  String? token = prefs.getString('token');
                                  try {
                                    if (token != null) {
                                      _checkPin(token, quizPin).then((flag) {
                                        print(flag);
                                        if (flag == true) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  WaitingRoomScreen(
                                                gamePin: quizPin,
                                              ),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Quiz pin is wrong', style: TextStyle(color: Colors.white),),
                                              backgroundColor:
                                                  Colors.red,
                                            ),
                                          );
                                        }
                                      }).catchError((error) {
                                        print('Error: $error');
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Token is null. Please log in again.')),
                                      );
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Failed to join game: $e')),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  'Join Quiz',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                        ],
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
    );
  }
}
