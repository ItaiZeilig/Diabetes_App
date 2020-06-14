import 'package:diabetes_app/providers/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:diabetes_app/services/challenges_service.dart';
import 'package:provider/provider.dart';
import 'package:diabetes_app/providers/auth.dart';
import 'package:diabetes_app/dailyChallenge/challenge.dart';

class HCPChallengeScreen extends StatefulWidget {
  static const routeName = '/hcpChallenge';

  @override
  _HCPChallengeScreenState createState() => _HCPChallengeScreenState();
}

class _HCPChallengeScreenState extends State<HCPChallengeScreen> {
  final Auth _auth = Auth();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Challenge>>.value(
      value: ChallengeService().reciveAllChallengesFromDB,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('HCP - Daily Challenge Screen'),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.0,

          actions: <Widget>[
            FlatButton.icon(
                onPressed: () async {
                  await _auth.logOut();
                },
                icon: Icon(Icons.person),
                label: Text('Logout'))
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Expanded(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Search()),
                ],
              ),
            )),

            //ChallengeList(),

            // MaterialButton(
            //   onPressed: () => _auth.logOut(),
            //   splashColor: Theme.of(context).primaryColor,
            //   child: Text(
            //     'Sign Out',
            //     style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //       decoration: TextDecoration.underline,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
