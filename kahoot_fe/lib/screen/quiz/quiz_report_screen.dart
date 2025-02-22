import 'package:flutter/material.dart';
import 'package:kahoot_clone/screen/quiz/report_detail_screen.dart';
import 'package:kahoot_clone/services/game-session/game_session_service.dart';
import 'package:kahoot_clone/services/quiz/quiz_detail_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ReportScreen extends StatefulWidget {
  final QuizDetail quiz;

  const ReportScreen({Key? key, required this.quiz}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late Future<List<dynamic>> _gameSessionsFuture;

  @override
  void initState() {
    super.initState();
    _gameSessionsFuture = loadGameSessions();
  }

  Future<List<dynamic>> loadGameSessions() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

print('quiz id: ${widget.quiz.quizId.toString()}');
    return await GameSessionService().getGameSessionByQuizId(
      id: widget.quiz.quizId.toString(),
      token: token ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Report Quiz',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${widget.quiz.title}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _gameSessionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No game sessions found'),
                    );
                  } else if (snapshot.hasData) {
                    final gameSessions = snapshot.data!;
                    return ListView.separated(
                      itemCount: gameSessions.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.grey, // Màu của đường kẻ
                        thickness: 1.0, // Độ dày của đường kẻ
                        height: 20, // Khoảng cách giữa các phần tử
                      ),
                      itemBuilder: (context, index) {
                        final session = gameSessions[index];

                        DateTime startTime =
                            DateTime.parse(session['start_time']);
                        String formattedStartTime =
                            DateFormat('MMM dd, yyyy HH:mm').format(startTime);

                        Color statusColor;
                        String statusText;
                        switch (session['status']) {
                          case 'active':
                            statusColor = Colors.green;
                            statusText = 'Active';
                            break;
                          case 'playing':
                            statusColor = Colors.yellow;
                            statusText = 'Playing';
                            break;
                          case 'inactive':
                            statusColor = Colors.red;
                            statusText = 'Inactive';
                            break;
                          default:
                            statusColor = Colors.grey;
                            statusText = 'Unknown';
                        }

                        return ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.quiz.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4.0),
                                      decoration: BoxDecoration(
                                        color: statusColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        statusText,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 8.0),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text('Start at: $formattedStartTime',
                                        style: const TextStyle(fontSize: 10.0)),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReportDetailScreen(
                                    quizTitle: widget.quiz.title,
                                    sessionId: session[
                                        'session_id'], // Giả sử có ID phiên
                                  ),
                                ),
                              );
                            });
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('No data available'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
