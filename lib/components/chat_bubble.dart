import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isCurrentUser;
  final String currentText;

  const ChatBubble({
    super.key,
    required this.isCurrentUser,
    required this.currentText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, right: 10, left: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: isCurrentUser ? Colors.black : Colors.white,
        border: Border.all(
          color: isCurrentUser ? Colors.transparent : Colors.black,
          width: 1
        ),
      ),
      child: Text(
        currentText,
        style: TextStyle(
          color: isCurrentUser ? Colors.white : Colors.black
        ),
      ),
    );
  }
}
