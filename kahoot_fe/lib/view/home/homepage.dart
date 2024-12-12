import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kahoot_clone/components/quiz_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 25.0),

            // Carousel Slider
            CarouselSlider(
              items: [
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: NetworkImage(
                              'assets/images/carousel-slider-1.png'), // Replace with your image URL
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
                          // Handle button press
                        },
                        child: const Text('Create account'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors
                              .white, // Use 'backgroundColor' instead of 'primary'
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      bottom: 30,
                      left: 20,
                      child: Text(
                        'Step 1: Learn to use Quiz Fox!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: NetworkImage(
                              'assets/images/carousel-slider-1.png'), // Replace with your image URL
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
                          // Handle button press
                        },
                        child: const Text('Step 1'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors
                              .red, // Use 'backgroundColor' instead of 'primary'
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      bottom: 30,
                      left: 20,
                      child: Text(
                        'Step 1: Learn to use Quiz Fox!',
                        style:  TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: NetworkImage(
                              'assets/images/carousel-slider-1.png'), // Replace with your image URL
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
                          // Handle button press
                        },
                        child: Text('Step 1'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors
                              .red, // Use 'backgroundColor' instead of 'primary'
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      bottom: 30,
                      left: 20,
                      child: Text(
                        'Step 1: Learn to use Quiz Fox!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
              options: CarouselOptions(
                autoPlay: false, // Set to false to disable autoplay
                height: 200,
                enlargeCenterPage: true,
              ),
            ),

            const SizedBox(height: 20.0),

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
                          // Navigate to see all page
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
                GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: 4, // Chỉ hiển thị 4 bài
                  itemBuilder: (context, index) {
                    return QuizCard(
                      index: index,
                      imageUrl: 'assets/images/default-quiz.png',
                      title: 'Kahoot ${index + 1}',
                      description: 'This is a public Kahoot.',
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 25.0),

            // Category Slider Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            CarouselSlider(
              items: List.generate(10, (index) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Category ${index + 1}', // Category name dynamically
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
              options: CarouselOptions(
                autoPlay: false,
                height: 120, // Set appropriate height for the category slider
                enlargeCenterPage: true,
              ),
            ),

            // Study Groups Section

            const SizedBox(height: 25.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Study Groups',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to See All page
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
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Create new study group
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 70.0),
                  side: const BorderSide(
                      color: Color.fromARGB(160, 255, 255, 255),
                      width: 2), // Add border
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  backgroundColor: const Color.fromARGB(
                      160, 255, 255, 255), // Transparent background
                ),
                child: const Text(
                  '+ New group',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey, // Text color matches border
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20.0),
          ],
        ),
    );
  }
}
