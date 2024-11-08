import 'dart:ui';
import 'package:bee/Screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenderPage extends StatefulWidget {
  @override
  _GenderPageState createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  String? _selectedGender;

  Future<void> _saveGender() async {
    if (_selectedGender != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('gender', _selectedGender!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gender saved successfully!")),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()), // Ensure LoginPage is imported
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a gender.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0F0D), Color(0xFF1C1F1B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Select Your Gender',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildGlassGenderOption('Male'),
                  _buildGlassGenderOption('Female'),
                ],
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: _saveGender,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent.withOpacity(0.8),
                  padding:
                  EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Save & Next',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassGenderOption(String gender) {
    IconData genderIcon = gender == 'Male' ? Icons.male : Icons.female;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            width: 150,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            decoration: BoxDecoration(
              color: _selectedGender == gender
                  ? Colors.white.withOpacity(0.4)
                  : Colors.white.withOpacity(0.15),
              border: Border.all(
                color: _selectedGender == gender
                    ? Colors.tealAccent
                    : Colors.white.withOpacity(0.3),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  genderIcon,
                  color: _selectedGender == gender
                      ? Colors.tealAccent
                      : Colors.white,
                  size: 30,
                ),
                SizedBox(height: 10),
                Text(
                  gender,
                  style: TextStyle(
                    fontSize: 18,
                    color: _selectedGender == gender
                        ? Colors.tealAccent
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
