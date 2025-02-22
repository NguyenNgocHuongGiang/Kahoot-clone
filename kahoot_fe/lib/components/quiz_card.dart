import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kahoot_clone/common/common.dart';
import 'package:kahoot_clone/components/notification_login_modal.dart';
import 'package:kahoot_clone/screen/game-session/waiting_public_screen.dart';
import 'package:kahoot_clone/services/user/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizCard extends StatelessWidget {
  final int index;
  final int? quizId;
  final String imageUrl;
  final String title;
  final String description;
  final double height;
  final double width;

  const QuizCard({
    super.key,
    required this.index,
    this.quizId = 0,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.height,
    required this.width,
  });

  void _onCardTapped(BuildContext context) async {
    final isLoggedIn = await checkUserLoginStatus();

    if (isLoggedIn) {
      // Nếu người dùng đã đăng nhập, chuyển đến trang quiz
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WaitingPublicPage(quizId: quizId.toString()),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const NotificationLoginModal(
            message: 'You must login before playing game',
          );
        },
      );
    }
  }

  Future<Map<String, dynamic>> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    return await UserService().getUserInfoByUserId(
      userId!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth > 600 ? 400.w : width.w;
    double cardHeight = screenWidth > 600 ? 350.h : height-50.h;

    double imageHeight =
        screenWidth > 600 ? cardHeight * 0.55 : cardHeight * 0.45;

    String shortDescription = description.length > 30
        ? '${description.substring(0, 30)}...'
        : description;

    String shortTitle =
        title.length > 15 ? '${title.substring(0, 15)}...' : title;

    return InkWell(
      onTap: () => _onCardTapped(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: SizedBox(
          height: cardHeight,
          width: cardWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hình ảnh
              Container(
                height: imageHeight,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child; // Ảnh đã tải xong thì hiển thị bình thường
                      }

                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null, // Hiển thị progress nếu có tổng byte
                        ),
                      ); // Hiển thị vòng tròn loading trong khi tải ảnh
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.broken_image,
                            size: 50, color: Colors.grey),
                      ); // Nếu lỗi, hiển thị icon báo lỗi
                    },
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shortTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth > 600 ? 20.0 : 16.sp,
                      ),
                    ),
                    Text(
                      shortDescription,
                      style: TextStyle(
                        fontSize: screenWidth > 600 ? 16.0 : 10.sp, // Tăng font chữ trên màn hình lớn
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
