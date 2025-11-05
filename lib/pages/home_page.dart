import 'package:flutter/material.dart';
import 'package:minimal_chatapp/components/my_drawer.dart';
import 'package:minimal_chatapp/pages/chat_page.dart';
import 'package:minimal_chatapp/services/chat/chat_service.dart';
import '../components/user_tile.dart';
import '../services/auth/auth_service.dart';

class  HomePage extends StatelessWidget {
  HomePage({super.key});

  // chat & auth service
  final _chatService = ChatService();
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home Page"
        ),
      ),
      drawer: MyDrawer(),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {

        }

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        // return list view
        return ListView(
          children: snapshot.data!.map<Widget>((userData) => _buildUserListItem(userData, context)).toList(),
        );
      },
    );
  }

  // build individual list tile for user
  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ChatPage(
                      receiverEmail: userData["email"],
                      receiverID: userData["uid"],
                    ),
              )
          );
        },
      );
    } else {
      return Container();
    }
  }
}
