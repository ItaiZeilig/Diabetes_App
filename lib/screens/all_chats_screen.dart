import '../models/chat.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/single_chat_room_block_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllChatsScreen extends StatefulWidget {
  static const routeName = '/allChats';

  @override
  _AllChatsScreenState createState() => _AllChatsScreenState();
}

class _AllChatsScreenState extends State<AllChatsScreen> {
  ChatProvider _chatProvider;
  AuthProvider _auth;
  var firstInit = true;
  final myController = TextEditingController();
  String _searchText = '';

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();
    if (firstInit) {
      _auth = Provider.of<AuthProvider>(context);
      _chatProvider = Provider.of<ChatProvider>(context);
      firstInit = false;
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
                  physics: NeverScrollableScrollPhysics(),
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
                                        text: "HCP Chats Room"),
                                  ),
                                ),
                                Spacer(
                                  flex: 1,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: _deviceSize.height,
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
                              stream: _chatProvider.getAllChatsSnapShot(),
                              builder: (BuildContext context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Text("Loading...");
                                }
                                return Container(
                                  height: _deviceSize.height * 0.8,
                                  child: ListView.builder(
                                      itemCount: snapshot.data.documents.length,
                                      itemBuilder: (context, index) {
                                        Chat chat = Chat.fromSnapshot(
                                            snapshot.data.documents[index]);
                                        if (chat.name
                                            .toLowerCase()
                                            .contains(_searchText) || _searchText.trim().isEmpty)
                                          return SingleChatRoomBlock(
                                              deviceSize: _deviceSize,
                                              chat: chat);
                                      }),
                                );
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.symmetric(
                                vertical: _deviceSize.height * 0.12,
                                horizontal: _deviceSize.width / 8),
                            height: _deviceSize.height * 0.1,
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  _searchText = value;
                                });
                              },
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                              ),
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
