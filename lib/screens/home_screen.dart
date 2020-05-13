import 'package:diabetes_app/providers/auth.dart';
import 'package:diabetes_app/providers/user_service.dart';
import 'package:diabetes_app/screens/daily_challenge_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:diabetes_app/widgets/home_screen/category.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Auth _auth;

  var _isLoading = true;

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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
            child: Column(
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
                      MaterialButton(
                        onPressed: () => _auth.logOut(),
                        splashColor: Theme.of(context).primaryColor,
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
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
                Column(
                  children: <Widget>[
                    Text(
                      "Today News",
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text("hello"),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }
}
