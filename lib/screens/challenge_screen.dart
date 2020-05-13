import 'package:flutter/material.dart';
import 'package:diabetes_app/services/challenges_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:diabetes_app/providers/auth.dart';
import 'package:diabetes_app/dailyChallenge/challenge_list.dart';
import 'package:diabetes_app/dailyChallenge/challenge.dart';
import 'package:diabetes_app/Calendar/calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';

//TODO - Dispaly at the bottom counter of all challenges s

class NewChallengeScreen extends StatefulWidget {
  static const routeName = '/dailyCallenge';

  @override
  _NewChallengeScreenState createState() => _NewChallengeScreenState();
}

class _NewChallengeScreenState extends State<NewChallengeScreen> {
  final Auth _auth = Auth();

  //final ChallengeTile _ct = ChallengeTile();

  int counterMainScreen = 0;
  int clickedChalangsCounter = 0;
  List<Challenge> allChallenges = null;
  List<Challenge> chalangesFomMemory = [];

  @override
  void initState() {
    super.initState();
    loadChalanges();
  }

//TODO - Load list<String> clicked challenges  and clear it if not the same day
  void loadChalanges() async {
    this.allChallenges =
        await ChallengeService().reciveAllChallengesFromDBFuture();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var lastRandomTime = prefs.getInt('lastRandomTime') ?? 0;

    // load the last clicked chalanges list from prefs

    // get last randomized chalanges from pref
    String jsonToLoad = prefs.getString('chalanges') ?? '[]';
    print('json to load: $jsonToLoad');
    var map = jsonDecode(jsonToLoad);
    chalangesFomMemory = [];
    map.forEach((i) {
      chalangesFomMemory.add(Challenge.fromMap(i));
    });

    print('list size: ${chalangesFomMemory.length}');

    DateTime lastRandomDate =
        DateTime.fromMillisecondsSinceEpoch(lastRandomTime);
    DateTime now = DateTime.now();

    var isSameDay = (lastRandomDate.year == now.year &&
        lastRandomDate.month == now.month &&
        lastRandomDate.day == now.day);

    if (!isSameDay) {
      //clear list
    }
    if (!isSameDay || chalangesFomMemory.length == 0) {
      // randomize chalanges
      chalangesFomMemory = [];
      int m = min(3, allChallenges.length);
      while (chalangesFomMemory.length < m) {
        var rndItem = allChallenges[Random().nextInt(allChallenges.length)];
        if (!chalangesFomMemory.contains(rndItem))
          chalangesFomMemory.add(rndItem);
      }
      try {
        // save randomized chalanges to prefs
        String jsonToSave = jsonEncode(chalangesFomMemory);
        prefs.setString('chalanges', jsonToSave);
        print('save success!');
      } catch (e) {
        print(e);
      }
    } else {
      print('Second enterence today!');
    }

    prefs.setInt('lastRandomTime', DateTime.now().millisecondsSinceEpoch);

    setState(() {});
  }

  
  @override
  Widget build(BuildContext context) {
    if (this.allChallenges == null) {
      return Scaffold(
        body: Center(
          child: Container(
            child: Text('Loading'),
          ),
        ),
      );
    }
    return StreamProvider<List<Challenge>>.value(
      value: ChallengeService().reciveAllChallengesFromDB,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Daily Challenge Screen'),
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
              child: Expanded(child: Calendar()),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Text(
                'Challenges For Today 🏆',
                style: GoogleFonts.notoSans(
                    fontWeight: FontWeight.w800, fontSize: 27.0),
              ),
            ),
            ChallengeList(chalangesFomMemory, (isIncrement) {
              setState(() {
                if (isIncrement)
                  clickedChalangsCounter++;
                else
                  clickedChalangsCounter--;
              });
            }),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 18.0, top: 5.0),
              child: Text(
                'You Did $clickedChalangsCounter Challenges Until Today',
                style: TextStyle(color: Colors.red, fontSize: 15.0),
              ),
            ),
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
