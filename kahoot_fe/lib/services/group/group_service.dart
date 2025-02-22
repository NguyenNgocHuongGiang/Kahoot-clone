import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kahoot_clone/common/constants.dart';
import 'package:kahoot_clone/services/group/group_model.dart';

class GroupService {
  Future<GroupStudy> createGroup(GroupStudy group) async {
    final response = await http.post(
      Uri.parse('${Constants.BASE_URL}group-study'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(group.toJson()),
    );

    if (response.statusCode == 201) {
      return GroupStudy.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add question');
    }
  }

  Future<GroupStudy> updateGroup(GroupStudy group) async {
    final response = await http.put(
      Uri.parse('${Constants.BASE_URL}group-study/${group.groupId}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(group.toJson()),
    );

    if (response.statusCode == 200) {
      return GroupStudy.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update group');
    }
  }

  Future<GroupStudy> deleteGroup(GroupStudy group) async {
    final response = await http.delete(
      Uri.parse('${Constants.BASE_URL}group-study/${group.groupId}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(group.toJson()),
    );

    if (response.statusCode == 200) {
      return GroupStudy.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to delete group');
    }
  }

  Future<List<GroupStudy>> fetchGroups(String id) async {
    final response = await http.get(
      Uri.parse('${Constants.BASE_URL}group-study/get-my-group/${id}'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> groupList = json.decode(response.body);
      return groupList.map((json) => GroupStudy.fromJson(json)).toList();
    } else {
      throw Exception('Failed to add question');
    }
  }

  Future<List<Member>> getMemberInGroup(String id) async {
    final response = await http.get(
      Uri.parse('${Constants.BASE_URL}group-study/get-member/${id}'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> memberList = json.decode(response.body);
      return memberList.map((json) => Member.fromJson(json)).toList();
    } else {
      throw Exception('Failed to add question');
    }
  }

  Future<MemberGroup> addMember(MemberGroup data) async {
    final response = await http.post(
      Uri.parse('${Constants.BASE_URL}group-study/add-member'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 201) {
      return MemberGroup.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add member');
    }
  }

  Future<void> removeMemberFromGroup(int id) async {
    final response = await http.delete(
      Uri.parse('${Constants.BASE_URL}group-study/delete-member/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception("Xóa thành viên thất bại");
    }
  }

  Future<List<GroupMessage>> getMessages(
      String groupId, int page, int limit) async {
    final response = await http.get(
      Uri.parse(
          '${Constants.BASE_URL}group-study/messages?group_id=$groupId&page=$page&limit=$limit'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> messageList = json.decode(response.body);
      return messageList.map((json) => GroupMessage.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch messages');
    }
  }

  Future<dynamic> sendMessage(int groupId, int userId, String message) async {
    final response = await http.post(
      Uri.parse('${Constants.BASE_URL}group-study/send-message'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'group_id': groupId,
        'user_id': userId,
        'message': message,
      }),
    );

    if (response.statusCode == 200) {
      return GroupMessage.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to send message');
    }
  }

  Future<List<GroupStudy>> getSharedGroups(int userId) async {
    final response = await http.get(
      Uri.parse('${Constants.BASE_URL}group-study/get-shared_group/$userId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => GroupStudy.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load shared groups');
    }
  }
}
