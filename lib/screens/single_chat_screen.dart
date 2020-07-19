import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_app/models/healthInfo.dart';
import 'package:diabetes_app/providers/healthInfo_provider.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_bubble_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleChatScreen extends StatefulWidget {
  static const routeName = '/singleChat';

  SingleChatScreen({this.healthInfo});

  final HealthInfo healthInfo;

  @override
  _SingleChatScreenState createState() => _SingleChatScreenState(healthInfo:healthInfo);
}

class _SingleChatScreenState extends State<SingleChatScreen> {
  _SingleChatScreenState ({this.healthInfo});


  ChatProvider _chatProvider;
  AuthProvider _auth;
  HealthInfoProvider _healthInfoProvider;
  var _firstInit = true;
  final _myController = TextEditingController();
  Chat _chat;

  final HealthInfo healthInfo;

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();
    if (_firstInit) {
      _auth = Provider.of<AuthProvider>(context);
      _chatProvider = Provider.of<ChatProvider>(context);
      _healthInfoProvider = Provider.of<HealthInfoProvider>(context);
      _chat = ModalRoute.of(context).settings.arguments;
      
      if (_chat == null) {
        _chatProvider.fetchAndSetChat(_auth.user.id).whenComplete(() => {
              setState(() {
                _chat = _chatProvider.getSingleChat;
                _firstInit = false;
              })
            });
      } else {
        _firstInit = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: _firstInit
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
                            padding: EdgeInsets.only(bottom: 50),
                            decoration: BoxDecoration(
                                color: Theme.of(context).accentColor),
                            height: _deviceSize.height * 0.15,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceEvenly,
                                //   children: [
                                //     Text(
                                //       "Age: ${_healthInfoProvider.healthInfo.ageYears}",
                                //       style: TextStyle(
                                //           fontSize: 16,
                                //           fontWeight: FontWeight.bold),
                                //     ),
                                //     Text(
                                //         "BMI: ${_healthInfoProvider.healthInfo.bmi}",
                                //         style: TextStyle(
                                //             fontSize: 16,
                                //             fontWeight: FontWeight.bold)),
                                //     Text(
                                //         "Diabetes Type: ${_healthInfoProvider.healthInfo.diabetesType}",
                                //         style: TextStyle(
                                //             fontSize: 16,
                                //             fontWeight: FontWeight.bold)),
                                //   ],
                                // )
                              ],
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: _deviceSize.height * 0.1), // change the perpule space
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
                                  height: _deviceSize.height * 0.80, // change the white space of chat
                                  child: ListView.builder(
                                      reverse: true,
                                      itemCount: snapshot.data.documents.length,
                                      itemBuilder: (context, index) {
                                        Message msg = Message.fromSnapshot(
                                            snapshot.data.documents[index]);
                                        return ChatBubble(
                                            messageData: msg,
                                            isSent:
                                                _auth.user.id.toString() == msg.userId.toString());
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
                                                userId: _auth.user.id,
                                                type: _auth.user.type,
                                                userName: _auth.user.name,
                                                createTimestamp: FieldValue
                                                    .serverTimestamp(),
                                                message: value),
                                            _chat.createdBy.userId);
                                        _myController.clear();
                                      },
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15.0),
                                      controller: _myController,
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
                                              userId: _auth.user.id,
                                              type: _auth.user.type,
                                              userName: _auth.user.name,
                                              createTimestamp:
                                                  FieldValue.serverTimestamp(),
                                              message: _myController.text),
                                          _chat.createdBy.userId);
                                      _myController.clear();
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
