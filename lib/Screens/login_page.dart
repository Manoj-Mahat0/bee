import 'dart:convert';
import 'dart:ui';
import 'package:bee/Screens/Comman_Screen/TermsAndConditionsPage.dart';
import 'package:bee/Screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:otpless_flutter/otpless_flutter.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _phoneController = TextEditingController();
  final _otplessFlutterPlugin = Otpless();
  String _errorMessage = '';
  bool _isTermsAccepted = false;
  bool _isButtonDisabled = false;

  late AnimationController _buttonController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeOtpless();
    _checkLoginStatus();

    _buttonController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _buttonScaleAnimation =
        Tween<double>(begin: 1.0, end: 1.05).animate(_buttonController);
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      _navigateToHomePage();
    }
  }

  void _initializeOtpless() {
    _otplessFlutterPlugin.initHeadless("zhba2e27i745bjofzt08");
    _otplessFlutterPlugin.setHeadlessCallback(onHeadlessResult);
  }

  void onHeadlessResult(dynamic result) {
    if (result['statusCode'] == 200 && result['responseType'] == 'ONETAP') {
      final token = result["response"]["token"];
      print("Token received: $token");
      _saveLoginStatus();
    } else {
      setState(() {
        _errorMessage = 'Verification Link had send to Your Number';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage),
          backgroundColor: Colors.tealAccent,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _saveLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }



  Future<void> _startPhoneAuth() async {
    Map<String, dynamic> arg = {
      "phone": _phoneController.text.trim(),
      "countryCode": "+91"
    };
    _otplessFlutterPlugin.startHeadless(onHeadlessResult, arg);
  }

  void _navigateToHomePage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  void _navigateToTermsPage() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => TermsAndConditionsPage()),
    );

    if (result == true) {
      setState(() {
        _isTermsAccepted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              width: screenSize.width,
              height: screenSize.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0A0F0D), Color(0xFF1C1F1B)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icon/GYMIFY.png',
                        height: screenSize.height * 0.12,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Login to your account',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: TextField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(color: Colors.tealAccent),
                            hintText: 'Enter your phone number',
                            hintStyle: TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.tealAccent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.tealAccent),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _isTermsAccepted,
                            activeColor: Colors.grey,
                            checkColor: Colors.tealAccent,
                            onChanged: (value) {
                              if (value == true) {
                                _navigateToTermsPage();
                              }
                            },
                          ),
                          GestureDetector(
                            onTap: _navigateToTermsPage,
                            child: Text(
                              'I agree to the Terms and Conditions',
                              style: TextStyle(
                                color: Colors.tealAccent,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      ScaleTransition(
                        scale: _buttonScaleAnimation,
                        child: ElevatedButton(
                          onPressed: _isTermsAccepted && !_isButtonDisabled
                              ? () {
                            setState(() {
                              _isButtonDisabled = true;
                            });
                            _startPhoneAuth();
                          }
                              : null,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.tealAccent.withOpacity(0.8),
                            padding: EdgeInsets.symmetric(
                              vertical: 14.0,
                              horizontal: screenSize.width > 600 ? 30.0 : 20.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 2.0),
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: screenSize.width > 600 ? 22 : 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
