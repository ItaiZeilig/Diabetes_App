import '../screens/profile_screen.dart';
import '../screens/all_challenges_screen.dart';
import '../screens/all_chats_screen.dart';
import '../screens/daily_challenges_screen.dart';
import '../screens/single_chat_screen.dart';
import '../widgets/single_home_category_widget.dart';
import '../providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthProvider _auth;
  var _isLoading = true;
  var firstInit = true;
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (firstInit) {
      _auth = Provider.of<AuthProvider>(context);
      if (_auth.getUser == null) {
        _auth.fetchAndSetUser().whenComplete(() {
          setState(() {
            _isLoading = false;
          });
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
      firstInit = false;
    }
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () {
                            _scaffoldkey.currentState.openDrawer();
                          },
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context)
                              .pushNamed(ProfileScreen.routeName),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://p7.hiclipart.com/preview/14/65/239/ico-avatar-scalable-vector-graphics-icon-doctor-with-stethoscope.jpg"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Hello,",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          _auth.getUser.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "What do you need?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SingleHomeCategory(
                          name: "Online Chat",
                          icon: Icons.chat_bubble_outline,
                          routeName: _auth.getUser.type == 'Patient'
                              ? SingleChatScreen.routeName
                              : AllChatsScreen.routeName),
                      SingleHomeCategory(
                          name: "Daily Challenges",
                          icon: Icons.adjust,
                          routeName: _auth.getUser.type == 'Patient'
                              ? DailyChallengesScreen.routeName
                              : AllChallengesScreen.routeName),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
