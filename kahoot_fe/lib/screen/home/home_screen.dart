import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kahoot_clone/components/modal-create-group.dart';
import 'package:kahoot_clone/components/quiz_card.dart';
import 'package:kahoot_clone/layout/main_layout.dart';
import 'package:kahoot_clone/providers/quiz_provider.dart';
import 'package:kahoot_clone/providers/user_provider.dart';
import 'package:kahoot_clone/screen/authentication/register_screen.dart';
import 'package:kahoot_clone/screen/library/user_profile_screen.dart';
import 'package:kahoot_clone/screen/quiz/create_quiz_screen.dart';
import 'package:kahoot_clone/screen/quiz/join_quiz_screen.dart';
import 'package:kahoot_clone/services/quiz/quiz_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  String? userId;

  List<dynamic> filteredUsers = [];
  @override
  void initState() {
    super.initState();

    _loadUserId();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchAllUsers();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizProvider>().fetchTopQuizzes();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchTopUsers();
    });
  }

  void filterSearchResults(String query) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (query.isEmpty) {
      setState(() {
        filteredUsers = [];
      });
    } else {
      setState(() {
        // Lọc danh sách người dùng dựa trên tên hoặc username
        filteredUsers = userProvider.users.where((user) {
          final fullName = user['full_name']?.toLowerCase() ?? '';
          final username = user['username']?.toLowerCase() ?? '';
          return fullName.contains(query.toLowerCase()) ||
              username.contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id'); // Kiểm tra xem có userId không
    });
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = MediaQuery.of(context).size.width > 600 ? 4 : 2;
    return Scaffold(
        appBar: MediaQuery.of(context).size.width > 600
            ? null
            : AppBar(
                title: const Text(
                  'Quiz Fox',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                centerTitle: true,
                backgroundColor: Colors.red,
                elevation: 0,
                leading: null,
                automaticallyImplyLeading: false,
              ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                    MediaQuery.of(context).size.width > 600 ? 270.0 : 0.0,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 25.0),

                  // Carousel Slider
                  CarouselSlider(
                    items: [
                      {
                        'image': 'assets/images/carousel-slider-1.png',
                        'text': 'Login and play!',
                        'buttonText': 'Create Account',
                        'route': const RegisterPage(),
                      },
                      {
                        'image': 'assets/images/carousel-slider-2.png',
                        'text': 'Play some quizzies',
                        'buttonText': 'Join Quiz',
                        'route': const JoinQuizPage(),
                      },
                      {
                        'image': 'assets/images/carousel-slider-3.png',
                        'text': 'Create quizzies!',
                        'buttonText': 'Create Now',
                        'route': const CreateQuizPage(),
                      }
                    ].map((item) {
                      return Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.deepPurpleAccent,
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: AssetImage(item['image']! as String),
                                fit: BoxFit.cover,
                              ),
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            height: 200,
                          ),
                          Positioned(
                            top: 20,
                            left: 20,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          item['route'] as Widget),
                                );
                              },
                              child: Text(item['buttonText']! as String),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 30,
                            child: Text(
                              item['text']! as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                    color: Color.fromARGB(255, 173, 162,
                                        233), // Viền đen xung quanh chữ
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                    options: CarouselOptions(
                      autoPlay: false,
                      height: 200,
                      enlargeCenterPage: true,
                    ),
                  ),

                  const SizedBox(height: 25.0),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width > 600
                              ? 400
                              : double.infinity,
                        ), // Giới hạn chiều rộng trên màn hình lớn
                        child: Column(
                          children: [
                            TextField(
                              controller: searchController,
                              onChanged: filterSearchResults,
                              decoration: InputDecoration(
                                hintText: "Search by full name or username...",
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintStyle: const TextStyle(fontSize: 14.0),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 10.0),
                              ),
                            ),
                            if (searchController.text.isNotEmpty)
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width > 600
                                          ? 400
                                          : double.infinity,
                                  maxHeight:
                                      300, // Giới hạn chiều cao để tránh tràn màn hình
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                margin: const EdgeInsets.only(top: 8.0),
                                child: ListView(
                                  shrinkWrap: true,
                                  children: filteredUsers.map((user) {
                                    final fullName =
                                        user['full_name'] ?? 'Unknown';
                                    final username =
                                        user['username'] ?? 'Unknown';
                                    final userId = user['user_id'] ?? 'Unknown';

                                    return ListTile(
                                      leading: const Icon(Icons.person,
                                          color: Colors.blue),
                                      title: Text(fullName),
                                      subtitle: Text(username),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Profile(
                                                userId: userId.toString(),
                                                onSave: () {}),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20.0),

                  // 'Top picks' Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Top picks',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const MainTemplate(initialIndex: 1),
                                  ),
                                );
                              },
                              child: const Text(
                                'See All',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Consumer<QuizProvider>(
                        builder: (context, quizProvider, child) {
                          if (quizProvider.isLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          var topQuizzes = quizProvider.quizzes
                              .take(4)
                              .toList(); // Chỉ lấy 4 quiz

                          if (topQuizzes.isEmpty) {
                            return const Center(
                                child: Text('No quizzes available.'));
                          }

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  2, // Hiển thị 2 quiz trên mỗi hàng
                              mainAxisSpacing: 16.0,
                              crossAxisSpacing: 16.0,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: topQuizzes.length,
                            itemBuilder: (context, index) {
                              Quiz quiz = topQuizzes[index];
                              return QuizCard(
                                index: index,
                                quizId: quiz.id,
                                imageUrl: quiz.coverImage,
                                title: quiz.title,
                                description: quiz.description,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                width: MediaQuery.of(context).size.height * 0.2,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 25.0),

                  // 'Top Users' Section
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      if (userProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      var topUsers =
                          userProvider.topUsers.take(4).toList(); // Lấy 4 user

                      print(topUsers);

                      if (topUsers.isEmpty) {
                        return const Center(child: Text('No users available.'));
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Top Creators',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CarouselSlider.builder(
                            itemCount: topUsers.length,
                            itemBuilder: (context, index, realIndex) {
                              var user = topUsers[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Profile(
                                        userId: user['creatorId'].toString(),
                                        onSave: () {},
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  elevation: 4,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundImage: user['avatar'] !=
                                                  null
                                              ? NetworkImage(user['avatar'])
                                              : const AssetImage(
                                                      'assets/images/default_avatar.png')
                                                  as ImageProvider,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          '${user['username'] ?? 'unknown'}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            options: CarouselOptions(
                              height: 180, // Điều chỉnh chiều cao slider
                              // autoPlay: true,
                              enlargeCenterPage: true,
                              aspectRatio: 16 / 9,
                              viewportFraction:
                                  0.7, // Hiển thị một phần item kế tiếp
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 25.0),

                  // Study Groups Section
                  if (userId != null)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Study Groups',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 10.0),
                  if (userId != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: double.infinity, // Chiều rộng full màn hình
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CreateGroupDialog(userId: userId!);
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 70.0),
                            side: const BorderSide(
                              color: Color.fromARGB(160, 255, 255, 255),
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor:
                                const Color.fromARGB(160, 255, 255, 255),
                          ),
                          child: const Text(
                            '+ New group',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 20.0),
                ],
              ),
            )
          ],
        )));
  }
}
