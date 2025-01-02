import 'package:flutter/material.dart';
import 'package:kahoot_clone/services/quiz/quiz_model.dart';
import 'package:kahoot_clone/services/quiz/quiz_service.dart';

class QuizProvider with ChangeNotifier {
  List<Quiz> _quizzes = [];
  List<Quiz> _ownQuizzes = [];
  bool _isLoading = false;

  List<Quiz> get quizzes => _quizzes;
  List<Quiz> get ownQuizzes => _ownQuizzes;
  bool get isLoading => _isLoading;

  Future<void> fetchQuizzes() async {
    _isLoading = true;
    notifyListeners(); 

    try {
      _quizzes = await QuizService().fetchQuizzes();
      print(_quizzes);
    } catch (e) {
      print('Error fetching quizzes: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchQuizzesByUserId(userId, token) async {
    _isLoading = true;
    notifyListeners(); 

    try {
      _ownQuizzes = await QuizService().fetchQuizzesByUserId(userId, token);
    } catch (e) {
      print('Error fetching quizzes by userId: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
