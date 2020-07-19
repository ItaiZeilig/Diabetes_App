import 'package:diabetes_app/models/healthInfo.dart';
import '../models/chat.dart';
import '../screens/single_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SingleChatRoomBlock extends StatefulWidget {
  SingleChatRoomBlock({
    Key key,
    @required Size deviceSize,
    @required this.chat,
    this.healthInfo,
  })  : _deviceSize = deviceSize,
        super(key: key);

  final Size _deviceSize;
  final Chat chat;
  final HealthInfo healthInfo;

  @override
  _SingleChatRoomBlockState createState() => _SingleChatRoomBlockState(
      deviceSize: _deviceSize, chat: chat, healthInfo: healthInfo);
}

class _SingleChatRoomBlockState extends State<SingleChatRoomBlock> {
  _SingleChatRoomBlockState({this.deviceSize, this.chat, this.healthInfo});
  var loading = true;

  final Size deviceSize;
  final Chat chat;
  final HealthInfo healthInfo;

  void initState() {
    if (widget.chat != null) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? CircularProgressIndicator()
        : InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(SingleChatScreen.routeName,
                  arguments: widget.chat);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
              margin: EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10.0, bottom: 1.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: widget._deviceSize.width / 1.25,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.chat.createdBy.name,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(
                              DateFormat('MM/dd  kk:mm').format(
                                  chat.lastMessage.createTimestamp.toDate()),
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "${widget.chat.lastMessage.userName}: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            width: widget._deviceSize.width / 3,
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                  text: widget.chat.lastMessage.message),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.chat.lastMessage.type,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
