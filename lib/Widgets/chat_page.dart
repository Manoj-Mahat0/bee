import 'package:bee/Screens/home_connective/MessagePage.dart';
import 'package:flutter/material.dart';
import 'chat_page_state.dart'; // Import the state class

class ChatPage extends StatefulWidget {
  final User user;

  ChatPage({required this.user});

  @override
  ChatPageState createState() => ChatPageState(); // Remove underscore
}
