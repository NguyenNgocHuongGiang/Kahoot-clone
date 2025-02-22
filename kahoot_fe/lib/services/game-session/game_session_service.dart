import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kahoot_clone/common/constants.dart';

class GameSessionService {
  Future<dynamic> createGameSession(
      {required int quiz_id,
      required String host,
      required String token}) async {
    final body = jsonEncode({
      'quiz_id': quiz_id,
      'host': host,
    });

    final response = await http.post(
      Uri.parse('${Constants.BASE_URL}game-sessions/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to add game session');
    }
  }

  Future<dynamic> updateGameSessionStatus(
      {required String token,
      required int sessionId,
      required String status}) async {
    final body = jsonEncode({
      'sessionId': sessionId,
      'status': status,
    });

    final url = Uri.parse('${Constants.BASE_URL}game-sessions/$sessionId');

    final response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load session history');
    }
  }

  Future<dynamic> getGameSessionByPIN(
      {required String pin, required String token}) async {
    final response = await http.get(
      Uri.parse('${Constants.BASE_URL}game-sessions/$pin'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to get game session');
    }
  }

  Future<dynamic> getGameSessionById(
      {required String id, required String token}) async {
    final response = await http.get(
      Uri.parse('${Constants.BASE_URL}game-sessions/get-session-by-id/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to get game session');
    }
  }

  Future<dynamic> getGameSessionByQuizId(
      {required String id, required String token}) async {
    final response = await http.get(
      Uri.parse(
          '${Constants.BASE_URL}game-sessions/get-session-by-quiz-id/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      return List.from(data['gameSession'] ?? []);
      // return data;
    } else {
      throw Exception('Failed to get game session');
    }
  }

  Future<dynamic> createPlayerSession({
    required String token,
    required int sessionId,
    required int userId,
    required String nickname,
    int? score,
  }) async {
    final body = jsonEncode({
      'session_id': sessionId,
      'user_id': userId,
      'nickname': nickname,
      'score': score ?? 0,
    });

    final response = await http.post(
      Uri.parse('${Constants.BASE_URL}session-player/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to create player session');
    }
  }

  Future<dynamic> updatePlayerSession({
    required String token,
    required int id,
    required int sessionId,
    required int userId,
    required String? nickname,
    int? score,
  }) async {
    final body = jsonEncode({
      'session_id': sessionId,
      'user_id': userId,
      'nickname': nickname,
      'score': score ?? 0,
    });

    final response = await http.put(
      Uri.parse('${Constants.BASE_URL}session-player/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to update player session');
    }
  }

  Future<dynamic> getPlayersList(
      {required String sessionId, required String token}) async {
    final response = await http.get(
      Uri.parse('${Constants.BASE_URL}session-player/get-player/$sessionId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to get playerlist');
    }
  }

  Future<dynamic> createQuizSnapshot({
    required String token,
    required int sessionId,
    required int quizId,
    required int userId,
    required Map<String, dynamic> quizData,
  }) async {
    final body = jsonEncode({
      'sessionId': sessionId,
      'quizId': quizId,
      'userId': userId,
      'quizData': quizData,
    });

    final response = await http.post(
      Uri.parse('${Constants.BASE_URL}game-sessions/create-snapshots'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      print(response.body);
      throw Exception('Failed to create quiz snapshot');
    }
  }

  Future<dynamic> createSessionAnswer({
    required String token,
    required int sessionId,
    required int userId,
    required Map<int, int?> answersData,
  }) async {
    Map<String, int> answersDataStringKeys = {
      for (var k in answersData.keys) k.toString(): answersData[k]!
    };

    final body = jsonEncode({
      'session_id': sessionId,
      'user_id': userId,
      'answers_json': answersDataStringKeys,
    });

    final response = await http.post(
      Uri.parse('${Constants.BASE_URL}session-answer/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to create session answer');
    }
  }

  Future<dynamic> getHistory({
    required String token,
    required int userId,
  }) async {
    final url = Uri.parse(
        '${Constants.BASE_URL}session-player/get-history-quiz/$userId');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load session history');
    }
  }

  Future<dynamic> getTopPlayerBySessionId(String token, int sessionId) async {
    final response = await http.get(
      Uri.parse(
          '${Constants.BASE_URL}session-player/get-top-player/$sessionId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("hihi");
      print(data);
      return data;
    } else {
      throw Exception('Failed to load quiz details');
    }
  }

  Future<dynamic> getReport(
      {required String sessionId, required String token}) async {
    final response = await http.get(
      Uri.parse(
          '${Constants.BASE_URL}game-sessions/get-report-by-session-id/$sessionId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data['gameSession']);
      return data['gameSession'] ?? {};
    } else {
      throw Exception('Failed to get report');
    }
  }
}
