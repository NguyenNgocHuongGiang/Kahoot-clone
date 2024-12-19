import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kahoot_clone/services/quiz/quiz_model.dart'; // Đảm bảo rằng đường dẫn đúng tới file quiz.dart
import 'package:kahoot_clone/common/constants.dart'; // Đảm bảo rằng đường dẫn đúng tới file constants.dart

class QuizService {
  Future<List<Quiz>> fetchQuizzes() async {
    final response =
        await http.get(Uri.parse('${Constants.BASE_URL}quiz/get-all-quizzes'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response
          .body); //Chuyển đổi chuỗi JSON nhận được thành một đối tượng Dart
      return data.map((json) => Quiz.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load quizzes');
    }
  }

  Future<Quiz> createQuiz(Quiz newQuiz, String token) async {
    final response = await http.post(
      Uri.parse('${Constants.BASE_URL}quiz'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(newQuiz.toJson()),
    );

    if (response.statusCode == 201) {
      return Quiz.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create quiz');
    }
  }

  Future<List<Quiz>> fetchQuizzesByUserId(String userId, String token) async {
    final response = await http.get(
      headers: {
      'Authorization': 'Bearer $token',
    }, 
    Uri.parse('${Constants.BASE_URL}quiz/get-quizzes-by-user-id/${userId}'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((quiz) => Quiz.fromJson(quiz)).toList();
    } else {
      throw Exception('Failed to load quizzes');
    }
  }
}
