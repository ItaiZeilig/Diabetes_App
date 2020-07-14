import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_app/providers/article_provider.dart';
import 'package:diabetes_app/screens/add_new_article_screen.dart';
import 'package:diabetes_app/screens/read_article_screen.dart';
import 'package:diabetes_app/widgets/latest_news_widget.dart';
import 'package:diabetes_app/widgets/popular_news_widget.dart';
import 'package:diabetes_app/screens/personal_info_screen.dart';

import '../screens/profile_screen.dart';
import '../screens/all_challenges_screen.dart';
import '../screens/all_chats_screen.dart';
import '../screens/daily_challenges_screen.dart';
import '../screens/single_chat_screen.dart';
import '../providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  AuthProvider _auth;
  var _isLoading = true;
  var firstInit = true;
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  ArticleProvider _articleProvider;

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Latest News'),
    Tab(text: 'Popular'),
  ];
  TabController _tabController;

  List<Article> allArticles = [];

  bool _islates = true;

  Future<List<Article>> loadArticles() async {
    return allArticles = await _articleProvider.reciveAllArticlesFromDBFuture();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (firstInit) {
      _auth = Provider.of<AuthProvider>(context);
      // If user in provider is null fetch it back from db
      if (_auth.user == null) {
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
    _auth = Provider.of<AuthProvider>(context);
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
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: InkWell(
                            onTap: () => Navigator.of(context)
                                .pushNamed(ProfileScreen.routeName),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://p7.hiclipart.com/preview/14/65/239/ico-avatar-scalable-vector-graphics-icon-doctor-with-stethoscope.jpg"),
                            ),
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
                          _auth.user.name.toString() != null
                              ? _auth.user.name.toString()
                              : "",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                                      child: Column(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Text(
                            "What would you like to do?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Flexible(
                          flex: 5,
                          fit: FlexFit.tight,
                          child: Container(
                            height: 180.0,
                            width: double.infinity,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                 _buildListItem(
                                    // TODO IF Pateint or Doctor?!?
                                    'Personal Info',
                                    'assets/images/app.png',
                                    //Color(0xFFFF9999)
                                    Color(0xFFF4C2C2) ,
                                    Color(0xFFFF4C4C),
                                    4),
                                _buildListItem(
                                    'Online Chat',
                                    'assets/images/message.png',
                                    Color(0xFFD7FADA),
                                    Color(0xFF56CC7E),
                                    1),
                                _buildListItem(
                                    'Daily Challenge',
                                    'assets/images/challenge.png',
                                    Color(0xFFC2E3FE),
                                    Color(0xFF6A8CAA),
                                    2),
                                _buildListItem(
                                    // TODO IF Pateint or Doctor?!?
                                    'News Article',
                                    'assets/images/newspaper.png',
                                    Color(0xFFFFE9C6),
                                    Color(0xFFDA9551),
                                    3),
                               
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey[450],
                      unselectedLabelStyle: TextStyle(fontSize: 14.0),
                      indicatorSize: TabBarIndicatorSize.label,
                      isScrollable: true,
                      indicatorColor: Colors.white,
                      labelStyle: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                      tabs: myTabs,
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('articles')
                        .where("diabetesType",
                            isEqualTo:
                                2) // TODO - Need to change the isEqualTo - Users diabetes type
                        .snapshots(),
                    builder: (BuildContext context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      return Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: <Widget>[
                            ListView.builder(
                                itemCount: snapshot.data.documents.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemBuilder: (context, index) {
                                  Article article = Article.fromSnapshot(
                                      snapshot.data.documents[index]);
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ReadFullArticle(
                                                      article: article)));
                                    },
                                    child: Container(
                                        width: double.infinity,
                                        height: 140.0,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 18.0, vertical: 8.0),
                                        child: LatesNews(article: article)),
                                  );
                                }),
                            StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance
                                  .collection('articles')                                  
                                  .where("isPopular", isEqualTo: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return ListView.builder(
                                    itemCount: snapshot.data.documents.length,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      Article article = Article.fromSnapshot(
                                          snapshot.data.documents[index]);
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ReadFullArticle(
                                                      article: article),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 140.0,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 18.0, vertical: 8.0),
                                          child: PopularNews(article: article),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return CircularProgressIndicator();
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
    );
  }

  gotoSelectedPage(int routhName) {
    switch (routhName) {
      case 1:
        _auth.user.type == 'Patient'
            ? Navigator.push(context,
                MaterialPageRoute(builder: (context) => SingleChatScreen()))
            : Navigator.push(context,
                MaterialPageRoute(builder: (context) => AllChatsScreen()));
        break;
      case 2:
        _auth.user.type == 'Patient'
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DailyChallengesScreen()))
            : Navigator.push(context,
                MaterialPageRoute(builder: (context) => AllChallengesScreen()));
        break;
      case 3:
        _auth.user.type == 'Patient'
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DailyChallengesScreen()))
            : Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddNewArticle()));
        break;
      case 4:
        _auth.user.type == 'Patient'
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddNewArticle()))
            : Navigator.push(context,
                MaterialPageRoute(builder: (context) => PersonalInfo()));
        break;
      default:
    }
  }

  _buildListItem(String name, String imgPath, Color bgColor, Color textColor,
      int routhName) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0),
      child: InkWell(
        onTap: () {
          gotoSelectedPage(routhName);
        },
        child: Container(
            height: 150.0,
            width: 130.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: bgColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: name,
                  child: Container(
                    height: 75.0,
                    width: 75.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        imgPath,
                        height: 50.0,
                        width: 50.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25.0),
                Text(
                  name,
                  style: TextStyle(
                      fontSize: 17.0,
                      color: textColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )),
      ),
    );
  }
}
