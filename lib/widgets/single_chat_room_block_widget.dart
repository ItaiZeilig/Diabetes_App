import '../models/chat.dart';
import '../screens/single_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SingleChatRoomBlock extends StatefulWidget {
  SingleChatRoomBlock({
    Key key,
    @required Size deviceSize,
    @required this.chat,
  })  : _deviceSize = deviceSize,
        super(key: key);

  final Size _deviceSize;
  final Chat chat;

  @override
  _SingleChatRoomBlockState createState() => _SingleChatRoomBlockState();
}

class _SingleChatRoomBlockState extends State<SingleChatRoomBlock> {
  var loading = true;

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
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: widget._deviceSize.width / 1.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.chat.createdBy.name,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              DateFormat('kk:mm').format(
                                widget.chat.lastMessage.createTimestamp
                                    .toDate(),
                              ),
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            "${widget.chat.lastMessage.userName}: ",
                            style: TextStyle(
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
