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
  TextEditingController searchController = TextEditingController();
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
                            padding: EdgeInsets.only(bottom: 80),
                            decoration: BoxDecoration(
                                color: Theme.of(context).accentColor),
                            height: _deviceSize.height * 0.23,                           
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
                            //height: _deviceSize.height,
                            //height: double.infinity,
                            width: double.infinity,
                            margin:
                                //EdgeInsets.only(top: _deviceSize.height * 0.1,),
                                EdgeInsets.only(top: 140.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.all(
                                Radius.circular(25.0),
                              ),
                            ),
                            child: StreamBuilder(
                              stream: _chatProvider.getAllChatsSnapShot(),
                              builder: (BuildContext context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Text("Loading...");
                                }
                                return Container(                                  
                                  height: _deviceSize.height * 0.85 ,
                                  //height: double.infinity,
                                  //width: double.infinity,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                      itemCount: snapshot.data.documents.length,                                      
                                      itemBuilder: (context, index) {
                                        Chat chat = Chat.fromSnapshot(
                                            snapshot.data.documents[index]);
                                        if (chat.name
                                                .toLowerCase()
                                                .contains(_searchText) ||
                                            _searchText.isEmpty) {
                                          return SingleChatRoomBlock(
                                              deviceSize: _deviceSize,
                                              chat: chat);
                                        }
                                      },
                                      //decoration: InputDecorationTheme(hoverColor: Colors.red),
                                  ),
                                  
                                );
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            // margin: EdgeInsets.symmetric(
                            //     //vertical: _deviceSize.height * 0.12,
                            //     vertical: 72.5,
                            //     horizontal: _deviceSize.width / 8),
                            // height: _deviceSize.height * 0.1,
                            margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 65.0, bottom: 20.0),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],                                
                                borderRadius: BorderRadius.circular(25.0)),
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  _searchText = value;
                                });
                              },
                              
                              controller: searchController,
                              decoration: InputDecoration(
                                hintText: 'Search',
                                border: InputBorder.none,
                                fillColor: Colors.grey[500],
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                  size: 25.0,
                                ),
                                suffixIcon: IconButton(
                                    padding: EdgeInsets.only(right: 1.0),
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback(
                                        (_) => setState(() {
                                          _searchText = "";
                                          searchController.clear();
                                        }),
                                      );
                                    }),
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
