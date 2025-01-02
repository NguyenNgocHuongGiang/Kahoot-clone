import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizCard extends StatelessWidget {
  final int index;
  final String imageUrl;
  final String title;
  final String description;
  final double height;
  final double width;

  const QuizCard({
    super.key,
    required this.index,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    double cardHeight = height.h;
    double cardWidth = width.w;

    String shortDescription = description.length > 30
        ? description.substring(0, 30) + '...'
        : description;

    String shortTitle =
        title.length > 15 ? title.substring(0, 15) + '...' : title;

    return Card(
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
              height: cardHeight * 0.4,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.cover,
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
                      fontSize: 16.sp,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    shortDescription,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
