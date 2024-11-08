import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bee/Widgets/details/GymDetailPage.dart';

class RechargePage extends StatefulWidget {
  @override
  _RechargePageState createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage> {
  final List<Map<String, dynamic>> gyms = [
    {
      "name": "Fitness Hub",
      "location": "123 Main St, City Center",
      "contact": "123-456-7890",
      "trainer": true,
      "unisex": true,
      "description": "24/7 access, personal trainers available",
      "monthlyPlans": [
        {"name": "Basic", "price": 50, "category": "Basic Plan"},
        {"name": "Standard", "price": 70, "category": "Standard Plan"},
        {"name": "Premium", "price": 100, "category": "Premium Plan"},
      ],
      "yearlyPlans": [
        {"name": "Basic", "price": 500, "category": "Basic Annual Plan"},
        {"name": "Standard", "price": 700, "category": "Standard Annual Plan"},
        {"name": "Premium", "price": 1000, "category": "Premium Annual Plan"},
      ],
      'images': [
        'assets/images/adv1.jpg',
        'assets/images/adv3.jpg',
        'assets/images/adv2.jpg',
      ],
      "liked": false,
    },
    {
      "name": "Powerhouse Gym",
      "location": "456 Elm St, Uptown",
      "contact": "987-654-3210",
      "trainer": true,
      "unisex": false,
      "description": "High-quality equipment and expert trainers",
      "monthlyPlans": [
        {"name": "Basic", "price": 40, "category": "Basic Plan"},
        {"name": "Standard", "price": 60, "category": "Standard Plan"},
        {"name": "Premium", "price": 90, "category": "Premium Plan"},
      ],
      "yearlyPlans": [
        {"name": "Basic", "price": 450, "category": "Basic Annual Plan"},
        {"name": "Standard", "price": 650, "category": "Standard Annual Plan"},
        {"name": "Premium", "price": 900, "category": "Premium Annual Plan"},
      ],
      'images': [
        'assets/images/adv1.jpg',
        'assets/images/adv3.jpg',
        'assets/images/adv2.jpg',
      ],
      "liked": false,
    },
  ];
  List<Map<String, dynamic>> filteredGyms = [];
  String searchQuery = '';
  bool isAscending = true;
  Timer? searchDebounceTimer;

  final List<String> searchHints = [
    'Search gyms...',
    'Find by name...',
    'Locate by location...',
  ];
  String currentHint = 'Search gyms...';
  Timer? hintTimer;
  int hintIndex = 0;

  @override
  void initState() {
    super.initState();
    filteredGyms = gyms;
    startHintTimer();
  }

  @override
  void dispose() {
    hintTimer?.cancel();
    searchDebounceTimer?.cancel();
    super.dispose();
  }

  void updateSearch(String query) {
    searchDebounceTimer?.cancel();
    searchDebounceTimer = Timer(Duration(milliseconds: 300), () {
      setState(() {
        searchQuery = query;
        filteredGyms = gyms.where((gym) {
          return gym['name'].toLowerCase().contains(query.toLowerCase()) ||
              gym['location'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    });
  }

  void startHintTimer() {
    hintTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        hintIndex = (hintIndex + 1) % searchHints.length;
        currentHint = searchHints[hintIndex];
      });
    });
  }

  void sortGyms() {
    setState(() {
      isAscending = !isAscending;
      filteredGyms.sort((a, b) {
        return isAscending
            ? a['name'].compareTo(b['name'])
            : b['name'].compareTo(a['name']);
      });
    });
  }

  void showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Filter Options',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.tealAccent,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Show only gyms with trainers',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      setState(() {
                        filteredGyms = gyms.where((gym) => gym['trainer'] == true).toList();
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Show only unisex gyms',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      setState(() {
                        filteredGyms = gyms.where((gym) => gym['unisex'] == true).toList();
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Clear filters',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      setState(() {
                        filteredGyms = gyms;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gyms'),
        backgroundColor: Color(0xFF1C1F1B),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.sort, color: Colors.tealAccent),
            onPressed: sortGyms,
            tooltip: 'Sort',
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (query) => updateSearch(query),
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: currentHint,
                          hintStyle: TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(Icons.search, color: Colors.white70),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.filter_list, color: Colors.tealAccent),
                      onPressed: showFilterOptions,
                      tooltip: 'Filter',
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Expanded(
                  child: filteredGyms.isEmpty
                      ? Center(
                    child: Text(
                      'No gyms found',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  )
                      : ListView.builder(
                    itemCount: filteredGyms.length,
                    itemBuilder: (context, index) {
                      final gym = filteredGyms[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GymDetailsScreen(gym: gym),
                            ),
                          );
                        },
                        child: _buildGlassmorphicContainer(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      gym['name'] ?? '',
                                      style: TextStyle(fontSize: 20, color: Colors.tealAccent, fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        gym['liked'] ? Icons.favorite : Icons.favorite_border,
                                        color: gym['liked'] ? Colors.red : Colors.white70,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          gym['liked'] = !gym['liked'];
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text(
                                  gym['description'] ?? '',
                                  style: TextStyle(color: Colors.white70, fontSize: 14),
                                ),
                                SizedBox(height: 10),
                                _buildInfoRow(Icons.location_on, gym['location']),
                                // Use the first monthly plan for display
                                _buildInfoRow(
                                  Icons.monetization_on,
                                  gym['monthlyPlans'][0]['name'] + ' - \$' + gym['monthlyPlans'][0]['price'].toString(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassmorphicContainer({required Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.tealAccent.withOpacity(0.4), width: 1.5),
        color: Colors.white.withOpacity(0.1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {Color color = Colors.white70}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          SizedBox(width: 5),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}