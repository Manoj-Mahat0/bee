import 'package:bee/Widgets/chat_page.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:shimmer/shimmer.dart';

class User {
  final String name;
  final String id;
  final String profileImageUrl;

  User({required this.name, required this.id, required this.profileImageUrl});
}

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final List<User> _allUsers = [
    User(name: "Alice", id: "1", profileImageUrl: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
    User(name: "Bob", id: "2", profileImageUrl: "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
    User(name: "Charlie", id: "3", profileImageUrl: "https://images.unsplash.com/photo-1517630800677-932d836ab680?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
    User(name: "Aarav", id: "4", profileImageUrl: "https://plus.unsplash.com/premium_photo-1691030254390-aa56b22e6a45?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
    User(name: "Priya", id: "5", profileImageUrl: "https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3"),
    User(name: "Rohan", id: "6", profileImageUrl: "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3"),
    User(name: "Ananya", id: "7", profileImageUrl: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3"),
    User(name: "Rahul", id: "8", profileImageUrl: "https://images.unsplash.com/photo-1511367461989-f85a21fda167?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3"),
    User(name: "Sneha", id: "9", profileImageUrl: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3"),
    User(name: "Vikram", id: "10", profileImageUrl: "https://plus.unsplash.com/premium_photo-1723485639270-8298355bada8?q=80&w=1913&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
    User(name: "Sanya", id: "11", profileImageUrl: "https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3"),
    User(name: "Aditya", id: "12", profileImageUrl: "https://plus.unsplash.com/premium_photo-1729627743324-56caac2f5fdb?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
    User(name: "Lakshmi", id: "13", profileImageUrl: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3"),
    User(name: "Maya", id: "14", profileImageUrl: "https://images.unsplash.com/photo-1607746882042-944635dfe10e?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3"),
    User(name: "Arjun", id: "15", profileImageUrl: "https://images.unsplash.com/photo-1544723795-3fb6469f5b39?q=80&w=1889&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
  ];

  List<User> _filteredUsers = [];
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _filteredUsers = _allUsers;
  }

  void _filterUsers(String searchText) {
    setState(() {
      _searchText = searchText;
      _filteredUsers = _allUsers
          .where((user) => user.name.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  Future<void> _refreshUsers() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _filteredUsers = _allUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: Stack(
        children: [
          // Background Image Container with Top Border Radius
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.jpg'), // Replace with your image path
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            clipBehavior: Clip.antiAlias,
          ),

          // Black Wash Overlay with Gradient
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search users...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                  ),
                  style: TextStyle(color: Colors.white),
                  onChanged: _filterUsers,
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshUsers,
                  child: _filteredUsers.isEmpty
                      ? Shimmer.fromColors(
                    baseColor: Colors.grey[700]!,
                    highlightColor: Colors.grey[500]!,
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey[700]!,
                              highlightColor: Colors.grey[500]!,
                              child: CircleAvatar(radius: 25, backgroundColor: Colors.grey[700]),
                            ),
                            SizedBox(width: 10),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[700]!,
                              highlightColor: Colors.grey[500]!,
                              child: Container(
                                width: 150,
                                height: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                      : ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(user.profileImageUrl),
                                ),
                                title: Text(user.name, style: TextStyle(color: Colors.white)),
                                subtitle: Text('Tap to chat', style: TextStyle(color: Colors.white70)),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatPage(user: user),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


