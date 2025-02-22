import 'package:flutter/material.dart';
import 'package:kahoot_clone/services/game-session/game_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? _userId;
  String? _token;
  List<dynamic>? _historyData;
  bool _hasError = false;

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
      _fetchHistory();
    } else {
      print('User data is missing.');
    }
  }

  Future<void> _fetchHistory() async {
    try {
      final data = await GameSessionService().getHistory(
        token: _token!,
        userId: int.parse(_userId!),
      );
      setState(() {
        _historyData = data;
        _hasError = false; // Đặt lại thành false nếu fetch thành công
      });
    } catch (error) {
      print('Error fetching history: $error');
      setState(() {
        _hasError = true; // Đánh dấu là có lỗi
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const Center(
        child: Text(
          'Not Found',
          style: TextStyle(fontSize: 14),
        ),
      );
    }

    if (_userId == null || _token == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_historyData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _historyData!.length,
        itemBuilder: (context, index) {
          final item = _historyData![index];
          final quizData = item['quiz_data']['questions'];
          final answers = item['answers'] ?? [];

          return Card(
            // margin: const EdgeInsets.symmetric(vertical: 4.0),
            // elevation: 3,
            child: ExpansionTile(
              title: Text(
                '${item['quiz_data']['quizTitle']}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text(
                DateFormat('dd/MM/yyyy')
                    .format(DateTime.parse(item['created_at'])),
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
              children: [
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...quizData.asMap().entries.map((entry) {
                        int questionIndex = entry.key;
                        var question = entry.value;

                        final answerForQuestion = answers.firstWhere(
                          (ans) => ans['session_id'] == item['session_id'],
                          orElse: () => null,
                        )?['answers_json']?[questionIndex.toString()];

                        var options = question['options'] ?? [];

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Question: ${question['question_text']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              ...options.map<Widget>((option) {
                                bool isIncorrect =
                                    answerForQuestion == option['option_id'] &&
                                        option['is_correct'] != true;
                                bool isCorrect =
                                    answerForQuestion == option['option_id'] &&
                                        option['is_correct'] == true;

                                return ListTile(
                                  leading: Icon(
                                    isCorrect
                                        ? Icons.check
                                        : isIncorrect
                                            ? Icons.close
                                            : option['is_correct'] == true
                                                ? Icons.check
                                                : Icons.circle,
                                    color: isCorrect
                                        ? Colors.green
                                        : isIncorrect
                                            ? Colors.red
                                            : option['is_correct'] == true
                                                ? Colors.green
                                                : Colors.grey[500],
                                    size: 20,
                                  ),
                                  title: Text(
                                    option['option_text'],
                                    style: TextStyle(
                                      color: isCorrect
                                          ? Colors.green
                                          : isIncorrect
                                              ? Colors.red
                                              : option['is_correct'] == true
                                                  ? Colors.green
                                                  : Colors.black,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
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
