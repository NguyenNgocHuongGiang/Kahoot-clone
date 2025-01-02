import 'package:flutter/material.dart';
import 'package:kahoot_clone/components/quiz_card.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kahoot_clone/providers/quiz_provider.dart';
import 'package:kahoot_clone/providers/user_provider.dart';

class Profile extends StatefulWidget {
  final VoidCallback onSave;

  const Profile({Key? key, required this.onSave}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? _userId;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('user_id');
    _token = prefs.getString('token');

    if (_userId != null && _token != null) {
      context.read<QuizProvider>().fetchQuizzesByUserId(_userId!, _token!);
    } else {
      print('User data is missing.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final quizProvider = Provider.of<QuizProvider>(context);

    if (userProvider.isLoading || quizProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userProvider.errorMessage.isNotEmpty) {
      return Center(child: Text(userProvider.errorMessage));
    }

    final usernameController =
        TextEditingController(text: userProvider.username);
    final emailController = TextEditingController(text: userProvider.email);
    final fullNameController =
        TextEditingController(text: userProvider.full_name);
    final passwordController =
        TextEditingController(text: userProvider.password);
    final phoneController = TextEditingController(text: userProvider.phone);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.18,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.1,
                    left: MediaQuery.of(context).size.width / 2 - 50,
                    child: GestureDetector(
                      onTap: () async {
                        final picker = ImagePicker();
                        final pickedImage = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (pickedImage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Avatar updated successfully')),
                          );
                        }
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: userProvider.avatar.isNotEmpty
                            ? AssetImage(userProvider.avatar)
                            : const AssetImage(
                                'assets/images/default-avatar.jpg'),
                      ),
                    ),
                  ),

                  // edit
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: const Icon(
                        Icons.more_horiz,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        // Show modal on icon click
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 32),

                                    GestureDetector(
                                      onTap: () async {
                                        final picker = ImagePicker();
                                        final pickedImage =
                                            await picker.pickImage(
                                          source: ImageSource.gallery,
                                        );
                                        if (pickedImage != null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Ảnh đại diện đã được thay đổi'),
                                            ),
                                          );
                                        }
                                      },
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: userProvider
                                                .avatar.isNotEmpty
                                            ? AssetImage(userProvider.avatar)
                                            : const AssetImage(
                                                'assets/images/default-avatar.jpg'),
                                        child: const Align(
                                          alignment: Alignment.bottomRight,
                                          child: CircleAvatar(
                                            radius: 16,
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.edit,
                                              size: 18,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    // Fullname
                                    TextField(
                                      controller: fullNameController,
                                      decoration: const InputDecoration(
                                        labelText: 'Fullname',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Email
                                    TextField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                        labelText: 'Email',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Password
                                    TextField(
                                      controller: passwordController,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        labelText: 'Password',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Username
                                    TextField(
                                      controller: usernameController,
                                      decoration: const InputDecoration(
                                        labelText: 'Username',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Phone number
                                    TextField(
                                      controller: phoneController,
                                      decoration: const InputDecoration(
                                        labelText: 'Phone number',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Save Button
                                    const SizedBox(height: 16.0),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          final updatedData = {
                                            'username': usernameController.text,
                                            'email': emailController.text,
                                            'full_name':
                                                fullNameController.text,
                                            'password': passwordController.text,
                                            'phone': phoneController.text,
                                          };

                                          try {
                                            userProvider.updateUserInfo(
                                              username:
                                                  updatedData['username']!,
                                              email: updatedData['email']!,
                                              full_name:
                                                  updatedData['full_name']!,
                                              password:
                                                  updatedData['password']!,
                                              phone: updatedData['phone']!,
                                            );

                                            Navigator.pop(context);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                backgroundColor: Colors.green,
                                                content:
                                                    Text('Update successfully'),
                                              ),
                                            );
                                          } catch (error) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text('Lỗi: $error')),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16.0),
                                        ),
                                        child: const Text(
                                          'Save',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 50),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Text(
                userProvider.full_name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // const SizedBox(height: 20),

              // Use GridView with SingleChildScrollView
              GridView.builder(
                padding: const EdgeInsets.all(16.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: quizProvider.ownQuizzes
                    .where((quiz) => quiz.visibility == 'public')
                    .toList()
                    .length,
                itemBuilder: (context, index) {
                  final quiz = quizProvider.ownQuizzes
                      .where((quiz) => quiz.visibility == 'public')
                      .toList()[index];

                  return QuizCard(
                    index: index,
                    imageUrl: quiz.coverImage.isNotEmpty
                        ? quiz.coverImage
                        : 'assets/images/default-quiz.png',
                    title: quiz.title,
                    description: quiz.description,
                    height: MediaQuery.of(context).size.height * 0.32,
                    width: MediaQuery.of(context).size.height * 0.2,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
