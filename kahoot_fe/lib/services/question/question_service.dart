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
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7InVzZXJJZCI6Mn0sImlhdCI6MTczNTA1NTI1NCwiZXhwIjoxNzM1MDU3MDU0fQ.Rraw3G4ukOWMa4PS-Bg1eN4UnuFokVBcoE_YZqGng1g',
      },
      body: json.encode(question.toJson()),
    );

    if (response.statusCode == 201) {
      return QuestionDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add question');
    }
  }

  Future<OptionDetail> addOption(OptionDetail option) async {
    final response = await http.post(
      Uri.parse('${Constants.BASE_URL}options'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(option.toJson()),
    );

    if (response.statusCode == 201) {
       return OptionDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add question');
    }
  }

  Future<String> getQuestion(int questionId) async {
    final response =
        await http.get(Uri.parse('${Constants.BASE_URL}question/$questionId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['question_text'];
    } else {
      throw Exception('Failed to load question');
    }
  }

  Future<void> deleteQuestion(int questionId) async {
    await http.delete(
      Uri.parse('${Constants.BASE_URL}question/$questionId'),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7InVzZXJJZCI6Mn0sImlhdCI6MTczNTA1NTI1NCwiZXhwIjoxNzM1MDU3MDU0fQ.Rraw3G4ukOWMa4PS-Bg1eN4UnuFokVBcoE_YZqGng1g',
      },
    );
  }

  Future<void> updateQuestion(question) async {
    final questionJson = {
      'question_id': question.question_id,
      'quiz_id': question.quiz_id,
      'question_text': question.question_text,
      'question_type': question.question_type,
      'time_limit': question.time_limit,
      'media_url': question.media_url,
      'points': question.points,
    };
    await http.put(
      Uri.parse('${Constants.BASE_URL}question/${question.question_id}'),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7InVzZXJJZCI6Mn0sImlhdCI6MTczNTA1NTI1NCwiZXhwIjoxNzM1MDU3MDU0fQ.Rraw3G4ukOWMa4PS-Bg1eN4UnuFokVBcoE_YZqGng1g',
      },
      body: json.encode(questionJson),
    );
  }

  Future<void> updateOption(option) async {
    final optionJson = {
      'option_id': option.option_id,
      'question_id': option.question_id,
      'option_text': option.option_text,
      'is_correct': option.is_correct,
    };
    final response = await http.put(
      Uri.parse('${Constants.BASE_URL}options/${option.option_id}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(optionJson),
    );
    print(response.body);
  }
}
