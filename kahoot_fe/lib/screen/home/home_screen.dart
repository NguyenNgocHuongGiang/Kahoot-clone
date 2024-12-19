import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kahoot_clone/components/quiz_card.dart';
import 'package:kahoot_clone/layout/main_layout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quiz Fox',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                          backgroundColor: Colors.white,
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
                // Repeat Stack for more carousel items
                // You can use the same stack structure for other carousel items
              ],
              options: CarouselOptions(
                autoPlay: false, 
                height: 200,
                enlargeCenterPage: true,
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
                          // Navigate to DiscoveryPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainTemplate(initialIndex: 1),
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
                GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: 4, // Only 4 items displayed
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
                      'Category ${index + 1}',
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
                height: 120, 
                enlargeCenterPage: true,
              ),
            ),

            const SizedBox(height: 25.0),

            // Study Groups Section
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
                      width: 2), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: const Color.fromARGB(160, 255, 255, 255),
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

            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
