import 'package:flutter/material.dart';
import 'package:kahoot_clone/services/group/group_model.dart';
import 'package:kahoot_clone/services/group/group_service.dart';

class CreateGroupDialog extends StatefulWidget {
  final String userId; // Nhận userId từ widget cha

  const CreateGroupDialog({Key? key, required this.userId}) : super(key: key);

  @override
  _CreateGroupDialogState createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<CreateGroupDialog> {
  final TextEditingController _groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Create Group"),
      content: TextField(
        controller: _groupNameController,
        decoration: const InputDecoration(
          labelText: "Group Name",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Đóng modal
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_groupNameController.text.trim().isEmpty) return;

            final newGroup = GroupStudy(
              groupName: _groupNameController.text.trim(),
              createdBy: int.parse(widget.userId), // Convert userId to int
            );

            await GroupService().createGroup(newGroup);

            Navigator.pop(context);
          },
          child: const Text("Create"),
        ),
      ],
    );
  }
}
