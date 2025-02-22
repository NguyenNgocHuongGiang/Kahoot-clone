import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kahoot_clone/services/quiz/quiz_detail_model.dart';
import 'package:kahoot_clone/services/quiz/quiz_model.dart';
import 'package:kahoot_clone/common/constants.dart';
// import 'package:socket_io_client/socket_io_client.dart';
import 'package:http_parser/http_parser.dart';

class QuizService {
  Future<List<Quiz>> fetchQuizzes() async {
    final response =
        await http.get(Uri.parse('${Constants.BASE_URL}quiz/get-all-quizzes'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Quiz.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load quizzes');
    }
  }

  Future<Quiz> createQuiz(Quiz newQuiz, String token) async {
    final quizCreate = {
      "title": newQuiz.title,
      "description": newQuiz.description,
      "creator": newQuiz.creator,
      "cover_image": newQuiz.coverImage,
      "visibility": newQuiz.visibility,
      "category": newQuiz.category,
    };

    final response = await http.post(
      Uri.parse('${Constants.BASE_URL}quiz'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(quizCreate),
    );

    if (response.statusCode == 201) {
      return Quiz.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create quiz');
    }
  }

  Future<List<Quiz>> fetchQuizzesByUserId(String userId, String token) async {
    final response = await http.get(headers: {
      'Authorization': 'Bearer $token',
    }, Uri.parse('${Constants.BASE_URL}quiz/get-quizzes-by-user-id/$userId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Quiz.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load quizzes');
    }
  }

  Future<QuizDetail> fetchQuizDetailById(int quizId) async {
    print(quizId);
    final response = await http.get(
      Uri.parse('${Constants.BASE_URL}quiz/$quizId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return QuizDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load quiz details');
    }
  }

  Future<void> updateQuizDetail(token, quizId, quizUpdate) async {
    final quiz = {
      "title": quizUpdate.title,
      "description": quizUpdate.description,
      "cover_image": quizUpdate.coverImage,
      "visibility": quizUpdate.visibility,
      "category": quizUpdate.category,
    };

    await http.put(
      Uri.parse('${Constants.BASE_URL}quiz/$quizId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(quiz),
    );
  }

  Future<String> uploadImage(imageFile) async {
    final uri = Uri.parse('${Constants.BASE_URL}file-upload');
    var request = http.MultipartRequest('POST', uri);

    var pic = await http.MultipartFile.fromPath('file', imageFile.path,
        contentType: MediaType('image', 'jpeg'));
    request.files.add(pic);

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    final Map<String, dynamic> responseMap = jsonDecode(responseBody);
    final String imageUrl = responseMap['imageUrl'];
    return imageUrl;
  }

  Future<List<Quiz>> getTopQuizzies() async {
    final response =
        await http.get(Uri.parse('${Constants.BASE_URL}quiz/get-top-quiz'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print(data);
      return data.map((json) => Quiz.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load quizzes');
    }
  }
}
