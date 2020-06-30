import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_app/providers/article_provider.dart';
import 'package:diabetes_app/screens/add_new_article.dart';
import 'package:diabetes_app/screens/read_article_screen.dart';
import 'package:diabetes_app/widgets/latest_news_widget.dart';

import '../models/createdBy.dart';
import '../screens/profile_screen.dart';
import '../screens/all_challenges_screen.dart';
import '../screens/all_chats_screen.dart';
import '../screens/daily_challenges_screen.dart';
import '../screens/single_chat_screen.dart';
import '../widgets/single_home_category_widget.dart';
import '../providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:diabetes_app/models/article.dart';

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

  Future<List<Article>> loadArticles() async {
    return allArticles =
        await _articleProvider.reciveAllChallengesFromDBFuture();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    //allArticles =
  }

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

  // Future<List<Article>> getUserTaskList() async {

  //   QuerySnapshot qShot =
  //     await Firestore.instance.collection('articles').getDocuments();

  //   return qShot.documents.map(
  //     (doc) => Article(author: doc.

  //   ).toList();
  // }

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
                      Row(
                        children: <Widget>[
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
                          SingleHomeCategory(
                              name: "Add New Article",
                              icon: Icons.crop_original,
                              routeName: _auth.getUser.type == 'Patient'
                                  ? DailyChallengesScreen.routeName
                                  : AddNewArticle.routeName),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
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
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                      tabs: myTabs,
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream:
                        Firestore.instance.collection('articles').snapshots(),
                    builder: (BuildContext context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      return Expanded(
                        child: ListView.builder(
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
                                          builder: (context) => ReadFullArticle(
                                              article: article)));
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 140.0,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 18.0, vertical: 8.0),
                                  child: News(article: article),
                                ),
                              );
                            }),
                      );
                    },
                  )
                ],
              ),
            ),
    );
  }
}
