import '../models/message.dart';
import '../providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble({
    Key key,
    @required this.messageData,
    @required this.isSent,
  }) : super(key: key);

  final Message messageData;
  final bool isSent;
  AuthProvider _auth;

  Color getColorByType(BuildContext context) {
    switch (messageData.type) {
      case 'Patient':
        return Theme.of(context).primaryColor;
        break;
      case 'Doctor':
        return Color(0xFF4fbbd5);
        break;
      case 'Nutritionist':
        return Color(0xFF1cc489);
        break;
      case 'Nurse':
        return Color(0xFFfe7940);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthProvider>(context);
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: getColorByType(context),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomRight: isSent ? Radius.circular(0) : Radius.circular(30),
            bottomLeft: isSent ? Radius.circular(30) : Radius.circular(0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              messageData.userName,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              messageData.type,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              messageData.message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
