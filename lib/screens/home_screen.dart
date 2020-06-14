import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_app/providers/auth.dart';
import 'package:diabetes_app/providers/user_service.dart';
import 'package:diabetes_app/screens/challenge_screen.dart';
import 'package:diabetes_app/screens/hcp_challenge_screen.dart';
import 'package:diabetes_app/chat/hcp_chat_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:diabetes_app/widgets/home_screen/news_headline.dart';


class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Auth _auth;
  var _isLoading = true;
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    _auth = Provider.of<Auth>(context);
    _auth.getUser
        .then((value) => Provider.of<UserService>(context, listen: false)
            .fetchAndSetUser(value.uid))
        .whenComplete(() => setState(() {
              _isLoading = false;
            }));
    super.didChangeDependencies();
  }

  Future<String> currentUserId() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final uid = user.uid;
    print(uid);
    return uid;
  }

  @override
  void initState() {
    super.initState();
    _auth = Auth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              title: Text("Logout"),
              onTap: () {
                _auth.logOut();                
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () {
            _scaffoldkey.currentState.openDrawer();
          },
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Hello,",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                            ),
                            Consumer<UserService>(
                              builder: (context, user, child) {
                                return Text(
                                  user.getUser.name,
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                          ],
                        ),
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://p7.hiclipart.com/preview/14/65/239/ico-avatar-scalable-vector-graphics-icon-doctor-with-stethoscope.jpg"),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "Categories",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Container(                        
                        margin: EdgeInsets.only(top: 10, left: 45, right: 26),                        
                        height: 60,
                        child: Center(
                          child: ListView(
                            // This next line does the trick.
                            scrollDirection: Axis.horizontal,
                            //padding: EdgeInsets.all(28.0),
                            children: <Widget>[
                              // FlatButton(
                              //   onPressed: () {
                              //     gotoSelectedPage(1);
                              //   },
                              //   child: Text('Daily Challenges'),
                              // ),
                              RaisedButton(                               
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),                                
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text('Daily Challenges',
                                      style: TextStyle(color: Colors.black, fontSize: 15),
                                    ),
                                    Icon(Icons.cake, color: Colors.red,
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  gotoSelectedPage(1);
                                  currentUserId();
                                },
                              ),
                             
                              RaisedButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),                                
                                color: Colors.white,
                                //color: Color(0xFFFFDD94),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text('Chat',
                                      style: TextStyle(color: Colors.black, fontSize: 15),
                                    ),
                                    Icon(Icons.chat, color: Colors.green,
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HCPChatHomePage(currentUserId: currentUserId().toString()),
                                    ),
                                    );
                                  //gotoSelectedPage(2);
                                  //currentUserId();
                                },
                              ),
                            
                              RaisedButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),                                
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text('Search',
                                      style: TextStyle(color: Colors.black, fontSize: 15),
                                    ),
                                    Icon(Icons.search, color: Colors.lightBlue,
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  gotoSelectedPage(3);
                                  currentUserId();
                                },
                              ),
                                                            
                              // SingleCategory(
                              //     "Daily Challenges", DailyChallenge.routeName,
                              //     "daily_challenges_icon.png"),
                              // SingleCategory("Chat", HCPChatHomePage.routeName,
                              //     "chat_icon.png"),
                              // SingleCategory("Search", HCPChallengeScreen.routeName,
                              //     "chat_icon.png"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Today News",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Column(
                            children: <Widget>[
                              SingleNewsHeadline(
                                  "Why need to check up?",
                                  Timestamp.now(),
                                  4.5,
                                  "daily_challenges_icon"),
                              SingleNewsHeadline(
                                  "Why need to check up?",
                                  Timestamp.now(),
                                  4.5,
                                  "daily_challenges_icon"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  gotoSelectedPage(int routhName) {
    switch (routhName) {
      case 1:
        Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewChallengeScreen(),
      ),
    );
        break;
        case 2:
        Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HCPChatHomePage(currentUserId: currentUserId().toString()),
      ),
    );
        break;
        case 3:
        Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HCPChallengeScreen(),
      ),
    );
        break;
      default:
    }
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => HCPChallengeScreen(),
    //   ),
    // );
  }

}
