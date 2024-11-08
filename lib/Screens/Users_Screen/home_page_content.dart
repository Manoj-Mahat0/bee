import 'dart:ui';
import 'package:bee/Screens/home_connective/MessagePage.dart';
import 'package:bee/Widgets/calendar_widget.dart';
import 'package:bee/Widgets/carousel_widget.dart';
import 'package:bee/Widgets/search_box.dart';
import 'package:bee/Widgets/workout_detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';

class HomePageContent extends StatefulWidget {
  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  String greetingMessage = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
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
  }

  Future<void> _fetchUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    if (token.isNotEmpty) {
      final url = Uri.parse('https://backend-gyms.vercel.app/api/users/me');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userName = data['name'] ?? 'User';
        });
      } else {
        setState(() {
          userName = 'User';
        });
      }
    } else {
      setState(() {
        userName = 'User';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Color(0xFF1C1F1B),
        title: Text(
          '$greetingMessage, $userName!',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icon/qr_code.svg',
              color: Colors.white,
              width: 24,
              height: 24,
            ),
            tooltip: 'QR Code',
            onPressed: () {
              // QR code action
            },
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icon/message.svg',
              color: Colors.white,
              width: 24,
              height: 24,
            ),
            tooltip: 'Messages',
            onPressed: () {
              // Navigate to the MessagePage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MessagePage()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Full-screen gradient background
          // Glassmorphism effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Increased blur for a stronger effect
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
              ),
              child: Stack(
                children: [
                  // Background Image
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/bg.jpg'), // Replace with your image path
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                  ),
                  // Semi-transparent Black Layer
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3), // Adjust opacity for desired darkness
                      borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
                    ),
                  ),
                  // Content on top
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SearchBox(),
                        SizedBox(height: 20),
                        CarouselWidget(),
                        SizedBox(height: 20),
                        CalendarWidget(),
                        SizedBox(height: 20),
                        // Improved workout summary card
                        WorkoutSummary(),
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
}
