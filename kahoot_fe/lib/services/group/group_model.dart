import 'dart:convert';

class GroupStudy {
  final int? groupId;
  String groupName;
  final int createdBy;
  final DateTime? createdAt;

  GroupStudy({
    this.groupId,
    required this.groupName,
    required this.createdBy,
    this.createdAt,
  });

  factory GroupStudy.fromJson(Map<String, dynamic> json) {
    return GroupStudy(
      groupId: json['group_id'],
      groupName: json['group_name'],
      createdBy: json['created_by'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'group_id': groupId,
  //     'group_name': groupName,
  //     'created_by': createdBy,
  //     'created_at': createdAt?.toIso8601String(),
  //   };
  // }
  Map<String, dynamic> toJson() {
    return {
      'group_name': groupName,
      'created_by': createdBy,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class Member {
  final int? memberId;
  final int userId;
  final String username;
  final String fullName;
  final String email;

  Member({
    this.memberId,
    required this.userId,
    required this.username,
    required this.fullName,
    required this.email,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      memberId: json['member_id'],
      userId: json['user_id'],
      username: json['username'],
      fullName: json['full_name'],
      email: json['email'],
    );
  }
}

class MemberGroup {
  final int? memberId;
  final int groupId;
  final int userId;
  final DateTime? joinedAt;

  MemberGroup({
    this.memberId,
    required this.groupId,
    required this.userId,
    this.joinedAt,
  });

  // Chuyển từ JSON thành đối tượng Member
  factory MemberGroup.fromJson(Map<String, dynamic> json) {
    return MemberGroup(
      memberId: json['member_id'],
      groupId: json['group_id'],
      userId: json['user_id'],
      joinedAt:
          json['joined_at'] != null ? DateTime.parse(json['joined_at']) : null,
    );
  }

  // Chuyển từ đối tượng Member thành JSON
  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
      'user_id': userId,
    };
  }
}

class GroupMessage {
  final int? messageId;
  final int groupId;
  final int userId;
  final String message;
  final DateTime? sentAt;
  final String? username; // Thêm username
  final String? email; // Thêm email

  GroupMessage({
    this.messageId,
    required this.groupId,
    required this.userId,
    required this.message,
    this.sentAt,
    this.username,
    this.email,
  });

  factory GroupMessage.fromJson(Map<String, dynamic> json) {
    return GroupMessage(
      messageId: json['message_id'],
      groupId: json['group_id'],
      userId: json['user_id'],
      message: json['message'],
      sentAt: json['sent_at'] != null ? DateTime.parse(json['sent_at']) : null,
      username: json['Users']['username'], // Lấy username từ Users
      email: json['Users']['email'], // Lấy email từ Users
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message_id': messageId,
      'group_id': groupId,
      'user_id': userId,
      'message': message,
      'sent_at': sentAt?.toIso8601String(),
      'Users': {
        'username': username,
        'email': email,
      },
    };
  }
}
