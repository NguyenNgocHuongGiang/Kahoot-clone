// import 'package:flutter/material.dart';
// import 'package:kahoot_clone/screen/group/group_detail_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:kahoot_clone/services/group/group_model.dart';
// import 'package:kahoot_clone/services/group/group_service.dart';
// import 'dart:math';

// class MyGroupsScreen extends StatefulWidget {
//   final VoidCallback onSave;
//   const MyGroupsScreen({super.key, required this.onSave});

//   @override
//   State<MyGroupsScreen> createState() => _MyGroupsScreenState();
// }

// class _MyGroupsScreenState extends State<MyGroupsScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   late Future<List<GroupStudy>> _myGroupsFuture = Future.value([]);
//   late Future<List<GroupStudy>> _sharedGroupsFuture = Future.value([]);
//   String? userId = '';

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     loadGroups();
//   }

//   void loadGroups() async {
//     final prefs = await SharedPreferences.getInstance();
//     String? storedUserId = prefs.getString('user_id');

//     if (storedUserId != null && storedUserId.isNotEmpty) {
//       setState(() {
//         userId = storedUserId;
//         _myGroupsFuture = GroupService().fetchGroups(userId!);
//         _sharedGroupsFuture = GroupService().getSharedGroups(int.parse(userId!));
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // TabBar không cần AppBar
//         TabBar(
//           controller: _tabController,
//           labelColor: Colors.red,
//           unselectedLabelColor: Colors.grey,
//           indicatorColor: Colors.red,
//           tabs: const [
//             Tab(text: "My groups"),
//             Tab(text: "Shared with me"),
//           ],
//         ),
//         Expanded(
//           child: TabBarView(
//             controller: _tabController,
//             children: [
//               _buildGroupList(_myGroupsFuture),
//               _buildGroupList(_sharedGroupsFuture),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildGroupList(Future<List<GroupStudy>> futureGroups) {
//     return FutureBuilder<List<GroupStudy>>(
//       future: futureGroups,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(child: Text('No groups found.'));
//         }

//         final groups = snapshot.data!;
//         final random = Random();

//         return GridView.builder(
//           padding: const EdgeInsets.all(16.0),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 12,
//             mainAxisSpacing: 12,
//             childAspectRatio: 2.2,
//           ),
//           itemCount: groups.length,
//           itemBuilder: (context, index) {
//             final group = groups[index];
//             final backgroundColor = Colors
//                 .primaries[random.nextInt(Colors.primaries.length)][200]!
//                 .withOpacity(0.6);

//             return Card(
//               elevation: 3,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               color: backgroundColor,
//               child: ListTile(
//                 leading: const Icon(Icons.group, color: Colors.white),
//                 title: Text(
//                   group.groupName.length > 10
//                       ? '${group.groupName.substring(0, 7)}...'
//                       : group.groupName,
//                   style: const TextStyle(
//                       fontWeight: FontWeight.bold, color: Colors.white),
//                 ),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => GroupDetailScreen(group: group),
//                     ),
//                   );
//                 },
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:kahoot_clone/screen/group/group_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kahoot_clone/services/group/group_model.dart';
import 'package:kahoot_clone/services/group/group_service.dart';
import 'dart:math';

class MyGroupsScreen extends StatefulWidget {
  final VoidCallback onSave;
  const MyGroupsScreen({super.key, required this.onSave});

  @override
  State<MyGroupsScreen> createState() => _MyGroupsScreenState();
}

class _MyGroupsScreenState extends State<MyGroupsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<GroupStudy>> _myGroupsFuture = Future.value([]);
  late Future<List<GroupStudy>> _sharedGroupsFuture = Future.value([]);
  String? userId = '';
  int? _selectedGroupId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadGroups();
  }

  void loadGroups() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedUserId = prefs.getString('user_id');

    if (storedUserId != null && storedUserId.isNotEmpty) {
      setState(() {
        userId = storedUserId;
        _myGroupsFuture = GroupService().fetchGroups(userId!);
        _sharedGroupsFuture =
            GroupService().getSharedGroups(int.parse(userId!));
      });
    }
  }

  void _showEditGroupDialog(GroupStudy group) {
    final TextEditingController _controller =
        TextEditingController(text: group.groupName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit group'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'New name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  group.groupName = _controller.text;
                });
                await GroupService().updateGroup(group);
                Navigator.of(context).pop();
                setState(() {
                  _selectedGroupId = null;
                });
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(GroupStudy group) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc chắn muốn xóa nhóm này?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
            ),
            TextButton(
              child: const Text('Xóa'),
              onPressed: () async {
                // Gọi hàm xóa nhóm từ GroupService
                await GroupService().deleteGroup(group);

                // Cập nhật lại danh sách nhóm sau khi xóa
                setState(() {
                  _myGroupsFuture = GroupService().fetchGroups(userId!);
                });

                Navigator.of(context).pop(); // Đóng hộp thoại
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_selectedGroupId != null) {
          setState(() {
            _selectedGroupId = null;
          });
        }
      },
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.red,
            tabs: const [
              Tab(text: "My groups"),
              Tab(text: "Shared with me"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGroupList(_myGroupsFuture, true),
                _buildGroupList(_sharedGroupsFuture, false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupList(
      Future<List<GroupStudy>> futureGroups, bool isMyGroups) {
    return FutureBuilder<List<GroupStudy>>(
      future: futureGroups,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No groups found.'));
        }

        final groups = snapshot.data!;
        final random = Random();

        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
          ),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final group = groups[index];
            final backgroundColor = Colors
                .primaries[random.nextInt(Colors.primaries.length)][200]!
                .withOpacity(0.6);

            return GestureDetector(
              onTap: () {
                if (_selectedGroupId == group.groupId) {
                  setState(() {
                    _selectedGroupId = null;
                  });
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupDetailScreen(group: group),
                    ),
                  );
                }
              },
              onLongPress: isMyGroups
                  ? () {
                      setState(() {
                        _selectedGroupId = group.groupId;
                      });
                    }
                  : null,
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: backgroundColor,
                child: Stack(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.group, color: Colors.white),
                      title: Text(
                        group.groupName.length > 10
                            ? '${group.groupName.substring(0, 7)}...'
                            : group.groupName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    if (isMyGroups && _selectedGroupId == group.groupId) ...[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        top: 0,
                        left: 0,
                        child: Container(
                          // padding: const EdgeInsets.symmetric(
                          //     vertical: 8, horizontal: 27),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.white),
                                onPressed: () {
                                  _showEditGroupDialog(group);
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(group);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
