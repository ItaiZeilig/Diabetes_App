import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_app/providers/healthInfo_provider.dart';

import '../models/challenge.dart';
import '../providers/auth_provider.dart';
import '../providers/challenge_provider.dart';
import '../widgets/single_challenge_widget.dart';
import '../widgets/week_days_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DailyChallengesScreen extends StatefulWidget {
  static const routeName = '/dailyChallenges';

  @override
  _DailyChallengesScreenState createState() => _DailyChallengesScreenState();
}

class _DailyChallengesScreenState extends State<DailyChallengesScreen> {
  int dayNumber = DateTime.now().toUtc().weekday;

  var firstInit = true;

  ChallengesProvider _challengesProvider;
  HealthInfoProvider healthInfoProvider;
  AuthProvider _auth;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (firstInit) {
      _challengesProvider = Provider.of<ChallengesProvider>(context);
      _auth = Provider.of<AuthProvider>(context);
      healthInfoProvider = Provider.of<HealthInfoProvider>(context);
      if (_auth.user == null) {
        _auth.fetchAndSetUser();
      }
      _challengesProvider
          .addChallengeToUserByDay(
              _auth.user.id, healthInfoProvider.healthInfo.diabetesType)
          .whenComplete(() {
        setState(() {
          firstInit = false;
        });
      });
    }
  }

  void handleTap(Challenge challenge) {
    challenge.doneItems += 1;
    if (challenge.doneItems == challenge.numberOfItems) {
      challenge.done = true;
    }
    _challengesProvider.updateUserChallenge(challenge, _auth.user.id);
  }

  @override
  Widget build(BuildContext context) {
    final Size _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: firstInit
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.arrow_back_ios),
                      ),
                    ],
                  ),
                  Text(
                    "Plan",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Center(
                    child: StreamBuilder(
                      stream: _challengesProvider
                          .getUserDailyChallengesSnapshot(_auth.user.id),
                      builder: (BuildContext context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text("Loading...");
                        }

                        return Container(
                          height: _deviceSize.height * 0.6,
                          width: _deviceSize.width * 0.9,
                          child: ListView.builder(
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                Challenge challenge = Challenge.fromSnapshot(
                                    snapshot.data.documents[index]);
                                // _challengesProvider.updateUserChallenge(
                                //     challenge, _auth.getUser.id);
                                return InkWell(
                                    onTap: () {
                                      if (!challenge.done) handleTap(challenge);
                                    },
                                    child: SingleChallenge(
                                      challenge,
                                    ));
                              }),
                        );
                      },
                    ),
                  ),
                  Text(
                    "Weekly Challenge",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    child: WeekDaysRow(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text(
                            "•",
                            style: TextStyle(
                                color: Colors.amber,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${((dayNumber) / 7 * 100).ceil()}% Completion",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "•",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${7 - dayNumber} days left",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
