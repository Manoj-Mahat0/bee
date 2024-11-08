import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart'; // Ensure you have this package in your pubspec.yaml

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = 'User'; // Placeholder for user name
  String greetingMessage = '';
  // Example data
  final double distance = 15.5; // Example distance in kilometers
  final String place = "Local Gym";

  @override
  void initState() {
    super.initState();
    _setGreetingMessage();
  }

  void _setGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greetingMessage = 'Good Morning';
    } else if (hour < 17) {
      greetingMessage = 'Good Afternoon';
    } else {
      greetingMessage = 'Good Evening';
    }
    // Fetch user name if necessary
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    if (token.isNotEmpty) {
      // Here you would fetch the user name from your backend API
      setState(() {
        userName = 'John Doe'; // Replace with fetched user name
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFF1C1F1B),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icon/settings.svg', // Replace with your settings icon path
              color: Colors.white,
              width: 24,
              height: 24,
            ),
            onPressed: () {
              // Settings action
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Full-screen gradient background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.jpg'), // Background image
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
              ),
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture and Basic Info Container
                  _buildGlassmorphicContainer(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1887&auto=format&fit=crop',
                          ),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: TextStyle(color: Colors.white, fontSize: 24),
                            ),
                            Text(
                              'ID: 12345',
                              style: TextStyle(color: Colors.grey[300]),
                            ),
                            Text(
                              'johndoe@example.com',
                              style: TextStyle(color: Colors.grey[300]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Health & Fitness Information Container
                  _buildGlassmorphicContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Health & Fitness Information'),
                        _buildInfoRow('Age', '30'),
                        _buildInfoRow('Height', '180 cm'),
                        _buildInfoRow('Weight', '75 kg'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Workout Goals Container
                  _buildGlassmorphicContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [


                        // Row for Present and Absent Containers
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // First Container for Present
                            Expanded(
                              child: _buildGoalContainer('5 \nChallanges', Colors.green),
                            ),
                            SizedBox(width: 16), // Add spacing between containers
                            // Second Container for Absent
                            Expanded(
                              child: _buildGoalContainer('3 \nTraing Plan', Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Workout Preferences Container with Two Columns
                  _buildGlassmorphicContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         // Add some spacing

                        // Two-column layout
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Column 1: Circular Progress Bar
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Container(
                                    width: 100, // Width of the circular progress
                                    height: 100, // Height of the circular progress
                                    child: CircularPercentIndicator(
                                      radius: 40.0,
                                      lineWidth: 10.0,
                                      animation: true,
                                      percent: 0.75, // Set the progress percentage
                                      center: Text(
                                        "75%", // Center text inside the circle
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                      ),
                                      progressColor: Colors.tealAccent,
                                      circularStrokeCap: CircularStrokeCap.round,
                                      backgroundColor: Colors.grey.withOpacity(0.3),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(width: 5), // Space between the columns
                            // Column 2: Weekly Progress Data
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Weekly Progress',
                                    style: TextStyle(color: Colors.tealAccent, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Distance: ${distance.toString()} km',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    'Location: $place',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Subscription Information Container
                  _buildGlassmorphicContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Subscription Information'),
                        _buildInfoRow('Membership Type', 'Premium'),
                        _buildInfoRow('Status', 'Active'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassmorphicContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.tealAccent.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(color: Colors.tealAccent, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
          Text(value, style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildGoalContainer(String text, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12), // Apply rounded corners
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Adjust blur as needed
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.tealAccent.withOpacity(0.5), width: 1.5), // Slightly transparent border
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: Colors.tealAccent, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
