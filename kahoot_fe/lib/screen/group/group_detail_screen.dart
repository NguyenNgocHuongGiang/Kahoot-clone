import 'package:flutter/material.dart';
import 'package:kahoot_clone/services/group/group_model.dart';
import 'package:kahoot_clone/services/group/group_service.dart';
import 'package:kahoot_clone/services/user/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kahoot_clone/services/socket/socket_service.dart';

class GroupDetailScreen extends StatefulWidget {
  final GroupStudy group;

  const GroupDetailScreen({super.key, required this.group});

  @override
  _GroupDetailScreenState createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  late Future<List<Member>> _membersFuture;
  static const int _maxVisibleMembers = 4;
  List<GroupMessage> messages = []; // Danh sách tin nhắn
  bool isLoading = true; // Trạng thái loading
  String? userId; // Define userId variable

  // @override
  // void initState() {
  //   super.initState();
  //   getUserId();
  //   _membersFuture =
  //       GroupService().getMemberInGroup(widget.group.groupId.toString());
  //   fetchMessages();

  //   SocketService().connect();
  //   SocketService().emitEvent('joinGroup', {'group_id': widget.group.groupId});

  //   SocketService().socket.on("newMessage", (data) {
  //     print("Nhận tin nhắn mới từ server: $data");

  //     setState(() {
  //       messages.insert(
  //           0, GroupMessage.fromJson(data)); // Chèn tin nhắn mới vào danh sách
  //     });
  //   });
  // }

  late ScrollController _scrollController;
  int _currentPage = 1;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    getUserId();
    _membersFuture =
        GroupService().getMemberInGroup(widget.group.groupId.toString());
    fetchMessages();

    SocketService().connect();
    SocketService().emitEvent('joinGroup', {'group_id': widget.group.groupId});

    SocketService().socket.on("newMessage", (data) {
      print("Nhận tin nhắn mới từ server: $data");

      setState(() {
        messages.insert(0, GroupMessage.fromJson(data));
      });
    });

    _scrollController = ScrollController();
    _scrollController.addListener(_loadMoreMessages);
  }

  void _loadMoreMessages() async {
    if (_scrollController.position.pixels <= 100 && !_isFetchingMore) {
      _isFetchingMore = true;
      _currentPage++; // Tăng trang lên để lấy tin nhắn tiếp theo

      try {
        List<GroupMessage> moreMessages = await GroupService()
            .getMessages(widget.group.groupId.toString(), _currentPage, 10);

        if (moreMessages.isNotEmpty) {
          setState(() {
            messages
                .addAll(moreMessages); // Thêm tin nhắn mới vào cuối danh sách
          });
        } else {
          // Không còn tin nhắn nào để load thêm
          _currentPage--;
        }
      } catch (e) {
        print("Lỗi khi tải thêm tin nhắn: $e");
        _currentPage--; // Nếu lỗi, giảm số trang lại
      }

      _isFetchingMore = false;
    }
  }

  void fetchMessages() async {
    try {
      List<GroupMessage> fetchedMessages = await GroupService()
          .getMessages(widget.group.groupId.toString(), 1, 10);
      setState(() {
        messages = fetchedMessages;
        isLoading = false;
      });
      print(fetchedMessages);
    } catch (e) {
      print("Lỗi khi lấy tin nhắn: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id');
  }

  Future<int?> getUserIdByEmail(String email) async {
    return await UserService().getUserIdByEmail(email);
  }

  void _removeMember(Member member, List<Member> members) async {
    print(111111111111);
    try {
      await GroupService().removeMemberFromGroup(member.memberId!);

      // Hiển thị thông báo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Xóa thành viên thành công!")),
      );

      // Cập nhật danh sách thành viên
      setState(() {
        _membersFuture =
            GroupService().getMemberInGroup(widget.group.groupId.toString());
      });

      // Đóng modal sheet
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi xóa: $e")),
      );
    }
  }

  void _showDeleteConfirmation(Member member, List<Member> members) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Confirmation"),
          content: Text("Are you sure you want to remove ${member.email} from the group?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Đóng popup
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Đóng popup trước khi xóa
                _removeMember(member, members);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _showAllMembers(List<Member> members) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'List members',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    spacing: 8.0, // Khoảng cách ngang giữa các chip
                    runSpacing: 8.0, // Khoảng cách dọc giữa các dòng
                    children: members.map((member) {
                      return Container(
                        width:
                            (constraints.maxWidth - 16) / 2, // Chia thành 2 cột
                        child: GestureDetector(
                          onLongPress: () {
                            _showDeleteConfirmation(member, members);
                          },
                          child: Chip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    member.email,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12.0),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: Colors.grey,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddMemberDialog() {
    TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add member"),
          content: TextField(
            controller: emailController, // ✅ Lấy email nhập vào
            decoration: const InputDecoration(
              labelText: "Enter email",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text.trim();
                if (email.isEmpty) return; // Kiểm tra nhập email chưa

                int? userId = await getUserIdByEmail(email);
                if (userId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Không tìm thấy user!")),
                  );
                  return;
                }

                MemberGroup newMember = MemberGroup(
                  groupId: widget.group.groupId!,
                  userId: userId,
                );

                try {
                  await GroupService()
                      .addMember(newMember); // Gửi request thêm thành viên
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Add member successfully!")),
                  );
                  Navigator.pop(context);
                  setState(() {
                    _membersFuture = GroupService()
                        .getMemberInGroup(widget.group.groupId.toString());
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Lỗi: $e")),
                  );
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMessage(String message, bool isMe, String senderName) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            senderName, // Hiển thị tên người gửi
            style: TextStyle(color: Colors.grey[700], fontSize: 10.0),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue[100] : Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(message),
          ),
        ],
      ),
    );
  }

  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() async {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      try {
        // GroupMessage newMessage = await GroupService().sendMessage(
        //   widget.group.groupId!,
        //   int.parse(userId!),
        //   message,
        // );

        // print(newMessage);

        // setState(() {
        //   messages.insert(0, newMessage); // Chèn tin nhắn mới vào danh sách
        // });

        SocketService().emitEvent("sendMessage", {
          "group_id": widget.group.groupId,
          "user_id": int.parse(userId!),
          "message": message,
        });

        _messageController.clear(); // Xóa ô nhập sau khi gửi
      } catch (e) {
        print("Lỗi khi gửi tin nhắn: $e");
      }
    }
  }

  @override
  void dispose() {
    SocketService().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.group.groupName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Members:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.blue),
                  onPressed: () {
                    _showAddMemberDialog();
                  },
                ),
              ],
            ),
          ),
          FutureBuilder<List<Member>>(
            future: _membersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No members found.'));
              }

              final members = snapshot.data!;
              final visibleMembers = members.take(_maxVisibleMembers).toList();
              final isMoreThanFour = members.length > _maxVisibleMembers;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Wrap(
                      spacing: 8.0,
                      children: visibleMembers
                          .map((member) => GestureDetector(
                                onLongPress: () => _showDeleteConfirmation(
                                    member, members), // Gọi hàm khi nhấn giữ
                                child: Chip(
                                  label: Text(
                                    member.email,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12.0),
                                  ),
                                  backgroundColor: Colors.grey,
                                ),
                              ))
                          .toList(),
                    ),
                    if (isMoreThanFour)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => _showAllMembers(members),
                          child: const Text(
                            "View more...",
                            style:
                                TextStyle(color: Colors.blue, fontSize: 14.0),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          const Divider(thickness: 2),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue[50], // Màu nền nhẹ
                borderRadius: BorderRadius.circular(10), // Bo góc
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  // Danh sách tin nhắn
                  Expanded(
                    child: isLoading
                        ? const Center(
                            child:
                                CircularProgressIndicator()) // Hiển thị loading
                        : ListView.builder(
                            controller: _scrollController,
                            reverse: true, // Để tin nhắn mới ở dưới cùng
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              bool isMe = message.userId ==
                                  int.parse(
                                      userId!); // Kiểm tra tin nhắn của mình
                              return _buildMessage(
                                  message.message, isMe, message.email!);
                            },
                          ),
                  ),

                  // Ô nhập tin nhắn
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: "Enter message...",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.blue),
                        onPressed: () {
                          _sendMessage();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
