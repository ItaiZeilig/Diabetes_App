import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_app/providers/auth.dart';
import 'package:diabetes_app/providers/user_service.dart';
import 'package:diabetes_app/screens/daily_challenge_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:diabetes_app/widgets/home_screen/category.dart';
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
                        margin: EdgeInsets.only(top: 20),
                        height: 100,
                        child: ListView(
                          // This next line does the trick.
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            SingleCategory(
                                "Daily Challenges",
                                DailyChallenge.routeName,
                                "daily_challenges_icon.png"),
                            SingleCategory("Chat", DailyChallenge.routeName,
                                "chat_icon.png"),
                          ],
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
}
