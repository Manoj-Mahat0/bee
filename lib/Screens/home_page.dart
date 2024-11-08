import 'package:bee/Screens/Users_Screen/dashboard_page.dart';
import 'package:bee/Screens/Users_Screen/home_page_content.dart';
import 'package:bee/Screens/Users_Screen/reels.dart';
import 'package:bee/Screens/Users_Screen/profile_page.dart';
import 'package:bee/Screens/Users_Screen/recharge_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 2;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onTabTapped(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.grey.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            physics: BouncingScrollPhysics(),
            children: [
              ProfilePage(),
              ReelsPage(),
              HomePageContent(),
              RechargePage(),
              DashboardPage(),
            ],
          ),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              selectedItemColor: Colors.transparent,
              unselectedItemColor: Colors.white60,
              currentIndex: _currentIndex,
              onTap: (index) => onTabTapped(index),
              items: [
                BottomNavigationBarItem(
                  icon: _buildSvgIcon('assets/icon/profile.svg', 0),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: _buildSvgIcon('assets/icon/plans.svg', 1),
                  label: 'Plans',
                ),
                BottomNavigationBarItem(
                  icon: _buildSvgIcon('assets/icon/home.svg', 2),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: _buildSvgIcon('assets/icon/recharge.svg', 3),
                  label: 'Recharge',
                ),
                BottomNavigationBarItem(
                  icon: _buildSvgIcon('assets/icon/dashboard.svg', 4),
                  label: 'Dashboard',
                ),
              ],
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSvgIcon(String assetPath, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => onTabTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            assetPath,
            width: isSelected ? 36 : 28,
            height: isSelected ? 36 : 28,
            color: isSelected ? Colors.tealAccent : Colors.white60,
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 24,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.tealAccent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}
