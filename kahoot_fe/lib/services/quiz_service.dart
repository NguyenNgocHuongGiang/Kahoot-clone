import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kahoot_clone/models/quiz_model.dart';  // Đảm bảo rằng đường dẫn đúng tới file quiz.dart
import 'package:kahoot_clone/common/constants.dart'; // Đảm bảo rằng đường dẫn đúng tới file constants.dart

class QuizService {
  Future<List<Quiz>> fetchQuizzes() async {
    final response = await http.get(Uri.parse('${Constants.BASE_URL}quiz/get-all-quizzes'));

    if (response.statusCode == 200) {
      print('API response: ${response.body}');
      List<dynamic> data = json.decode(response.body);  //Chuyển đổi chuỗi JSON nhận được thành một đối tượng Dart
      return data.map((json) => Quiz.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load quizzes');
    }
  }
}
