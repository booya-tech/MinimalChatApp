import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minimal_chatapp/components/chat_bubble.dart';
import 'package:minimal_chatapp/components/my_textfield.dart';

import '../services/auth/auth_service.dart';
import '../services/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  // chat & auth service
  final _chatService = ChatService();
  final _authService = AuthService();

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // add lister to focus node
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
       // cause a delay so that the keyboard has time to show up
       // then the amount of remaining space will be calculated
       // then scroll down
       Future.delayed(
         const Duration(milliseconds: 500),
         () => scrollDown(),
       );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    _messageController.dispose();
  }

  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      // send the message
      await _chatService.sendMessage(widget.receiverID, _messageController.text);

      // clear text controller
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
      ),
      body: Column(
        children: [
          Expanded(
              child: _buildMessageList()
          ),
          // user input
          _buildUserInput()
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;

    return StreamBuilder(
        stream: _chatService.getMessages(senderID, widget.receiverID),
        builder: (context, snapshot) {
          // error
          if (snapshot.hasError) {
            return const Text("Error");
          }

          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }

          // return list view
          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
          );
        },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data["senderID"] == _authService.getCurrentUser()!.uid;

    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: ChatBubble(isCurrentUser: isCurrentUser, currentText: data["message"]),
    );
  }

  // build message input
  Widget _buildUserInput() {
    return Padding(
      padding: EdgeInsets.only(bottom: 25),
      child: Row(
        children: [
          // text fild should take up most of the space
          Expanded(
            child:
            MyTextfield(
              focusNode: focusNode,
              hintText: "Type a message",
              obscureText: false,
              controller: _messageController
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            child: IconButton(
                onPressed: sendMessage,
                icon: Icon(Icons.send)
            ),
          ),
        ],
      ),
    );
  }
}
