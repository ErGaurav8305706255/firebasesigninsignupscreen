import 'package:flutter/material.dart';
class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Text('Welcome ChatRoom',
          style: TextStyle(
              color: Colors.cyan,
              fontWeight: FontWeight.w700,
              fontSize: 20
          ),),
      ),
    );
  }
}
