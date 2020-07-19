import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_app/screens/edit_challenge_screen.dart';
import '../models/challenge.dart';
import '../models/createdBy.dart';
import '../widgets/all_challenges_list_widget.dart';
import '../providers/auth_provider.dart';
import '../providers/challenge_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AllChallengesScreen extends StatefulWidget {
  static const routeName = '/AllChallenges';

  @override
  _AllChallengesScreenState createState() => _AllChallengesScreenState();
}

class _AllChallengesScreenState extends State<AllChallengesScreen> {
  ChallengesProvider _challengesProvider;
  AuthProvider _auth;

  String _searchText;
  var uuid = Uuid();

  var firstInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (firstInit) {
      _auth = Provider.of<AuthProvider>(context);
      _challengesProvider = Provider.of<ChallengesProvider>(context);
      setState(() {
        firstInit = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size _deviceSize = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
            body: SafeArea(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                  IconButton(
                    onPressed: () {
                      Challenge challenge = Challenge(
                          active: true,
                          diabetesType: 1,
                          done: false,
                          doneItems: 0,
                          name: "This is header",
                          numberOfItems: 0,
                          type: "Nutrition",
                          id: uuid.v4(),
                          createTimestamp: FieldValue.serverTimestamp(),
                          createdBy: CreatedBy(
                              name: _auth.user.name,
                              type: _auth.user.type,
                              userId: _auth.user.id));
                      Navigator.of(context).pushNamed(
                          EditChallengeScreen.routeName,
                          arguments: [challenge]);
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              Container(
                child: TabBar(
                  onTap: (value) {
                    _challengesProvider.setTabIndex(value);
                  },
                  isScrollable: false,
                  labelColor: Colors.black,
                  indicatorColor: Theme.of(context).primaryColor,
                  tabs: [
                    Tab(
                      text: "Active",
                    ),
                    Tab(
                      text: "Disabled",
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(
                    horizontal: _deviceSize.width / 8, vertical: 20),
                height: _deviceSize.height * 0.1,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _challengesProvider.setSearchText(value);
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
              Expanded(
                flex: 1,
                child: TabBarView(
                  children: [
                    AllChallengesList(mainContext: context),
                    AllChallengesList(mainContext: context),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
