import 'package:flutter/material.dart';
import 'package:kahoot_clone/services/quiz/quiz_model.dart';
import 'package:kahoot_clone/services/quiz/quiz_service.dart';

class QuizProvider with ChangeNotifier {
  List<Quiz> _quizzes = [];
  bool _isLoading = false;

  List<Quiz> get quizzes => _quizzes;
  bool get isLoading => _isLoading;

  Future<void> fetchQuizzes() async {
    _isLoading = true;
    notifyListeners();   //thông báo cho các widget đang lắng nghe 

    try {
      _quizzes = await QuizService().fetchQuizzes();
    } catch (e) {
      print('Error fetching quizzes: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
