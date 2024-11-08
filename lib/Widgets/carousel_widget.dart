import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselWidget extends StatelessWidget {
  final List<Map<String, String>> workouts = [
    {
      'name': 'Yoga',
      'time': '30 mins',
      'calories': '150 kcal',
      'image': 'assets/images/adv3.jpg', // Ensure appropriate image path
    },
    {
      'name': 'HIIT',
      'time': '45 mins',
      'calories': '300 kcal',
      'image': 'assets/images/adv2.jpg',
    },
    {
      'name': 'Strength Training',
      'time': '60 mins',
      'calories': '400 kcal',
      'image': 'assets/images/adv1.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 150,
        autoPlay: true,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        pauseAutoPlayOnTouch: true,
        pageSnapping: true,
        // Add more options for better usability if needed
      ),
      items: workouts.map((workout) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.transparent, // Make it transparent to see the background image
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Workout image background
                Image.asset(
                  workout['image']!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                // Overlay for improved text readability
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        workout['name']!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildDetailRow(Icons.access_time, workout['time']!, Color(0xFF059212)),
                          _buildDetailRow(Icons.local_fire_department, workout['calories']!, Color(0xFFFFB200)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDetailRow(IconData icon, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2), // Light background color for the tag
        borderRadius: BorderRadius.circular(20), // Rounded tag style
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18), // Icon matches the tag color
          SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
