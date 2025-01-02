import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kahoot_clone/common/constants.dart';
import 'package:kahoot_clone/services/question/question_model.dart';

class QuestionAndOptionService {
  Future<QuestionDetail> addQuestion(QuestionDetail question) async {
    final response = await http.post(
      Uri.parse('${Constants.BASE_URL}question'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7InVzZXJJZCI6Mn0sImlhdCI6MTczNTA1NTI1NCwiZXhwIjoxNzM1MDU3MDU0fQ.Rraw3G4ukOWMa4PS-Bg1eN4UnuFokVBcoE_YZqGng1g',
      },
      body: json.encode(question.toJson()),
    );

    if (response.statusCode == 201) {
      return QuestionDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add question');
    }
  }

  Future<void> addOption(OptionDetail option) async {
    final response = await http.post(
      Uri.parse('${Constants.BASE_URL}options'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(option.toJson()),
    );
    print(option.toJson());
    print(response.body);

    if (response.statusCode == 201) {
      print(response.body);
    } else {
      throw Exception('Failed to add question');
    }
  }
}
