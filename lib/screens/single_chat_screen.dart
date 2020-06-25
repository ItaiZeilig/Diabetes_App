import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_bubble_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleChatScreen extends StatefulWidget {
  static const routeName = '/singleChat';

  @override
  _SingleChatScreenState createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends State<SingleChatScreen> {
  ChatProvider _chatProvider;
  AuthProvider _auth;
  var firstInit = true;
  final myController = TextEditingController();
  Chat _chat;

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();
    if (firstInit) {
      _auth = Provider.of<AuthProvider>(context);
      _chatProvider = Provider.of<ChatProvider>(context);
      _chat = ModalRoute.of(context).settings.arguments;
      if (_chat == null) {
        _chatProvider
            .fetchAndSetChat(_auth.getUser.id)
            .whenComplete(() => {
                  setState(() {
                    _chat = _chatProvider.getSingleChat;
                    firstInit = false;
                  })
                });
      }else{
        firstInit = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: firstInit
            ? Center(child: CircularProgressIndicator())
            : GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(bottom: 30),
                            decoration: BoxDecoration(
                                color: Theme.of(context).accentColor),
                            height: _deviceSize.height * 0.15,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_back_ios),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ),
                                Flexible(
                                  flex: 4,
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                        text: _chat.name),
                                  ),
                                ),
                                Spacer(
                                  flex: 1,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: _deviceSize.height * 0.1),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            child: StreamBuilder(
                              stream: _chatProvider
                                  .getChatSnapShot(_chat.createdBy.userId),
                              builder: (BuildContext context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Text("Loading...");
                                }
                                return Container(
                                  height: _deviceSize.height * 0.8,
                                  child: ListView.builder(
                                      reverse: true,
                                      itemCount: snapshot.data.documents.length,
                                      itemBuilder: (context, index) {
                                        Message msg = Message.fromSnapshot(
                                            snapshot.data.documents[index]);
                                        return ChatBubble(
                                            messageData: msg,
                                            isSent:
                                                _auth.getUser.id == msg.userId);
                                      }),
                                );
                              },
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: _deviceSize.height * 0.88),
                            decoration: BoxDecoration(
                              color: Color(0xFFe1e3fc),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: TextField(
                                      textInputAction: TextInputAction.send,
                                      onSubmitted: (value) {
                                        _chatProvider.sendMessage(
                                            new Message(
                                                userId: _auth.getUser.id,
                                                type: _auth.getUser.type,
                                                userName: _auth.getUser.name,
                                                createTimestamp: FieldValue
                                                    .serverTimestamp(),
                                                message: value),
                                            _chat.createdBy.userId);
                                        myController.clear();
                                      },
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15.0),
                                      controller: myController,
                                      decoration: InputDecoration.collapsed(
                                        hintText: 'Type your message...',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                                  child: IconButton(
                                    icon: Icon(Icons.send),
                                    onPressed: () {
                                      _chatProvider.sendMessage(
                                          new Message(
                                              userId: _auth.getUser.id,
                                              type: _auth.getUser.type,
                                              userName: _auth.getUser.name,
                                              createTimestamp:
                                                  FieldValue.serverTimestamp(),
                                              message: myController.text),
                                          _chat.createdBy.userId);
                                      myController.clear();
                                    },
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
