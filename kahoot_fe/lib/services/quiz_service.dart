import 'dart:convert';
import 'http_service.dart';

class QuizService {
  final HttpService httpService;

  QuizService({required this.httpService});

  Future<List<dynamic>> getAllQuizzes() async {
    try {
      final response = await httpService.get("quiz/get-all-quizzes");
      if (response.statusCode == 200) {
        List<dynamic> quizzes = jsonDecode(response.body);
        return quizzes; 
      } else {
        throw Exception('Failed to load quizzes');
      }
    } catch (e) {
      rethrow;
    }
  }
}
