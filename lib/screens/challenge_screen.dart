import 'package:flutter/material.dart';
import 'package:diabetes_app/services/challenges_service.dart';
import 'package:provider/provider.dart';
import 'package:diabetes_app/providers/auth.dart';
import 'package:diabetes_app/dailyChallenge/challenge_list.dart';
import 'package:diabetes_app/dailyChallenge/challenge.dart';
import 'package:diabetes_app/Calendar/calendar.dart';
import 'package:diabetes_app/dailyChallenge/challenge_tile.dart';



class NewChallengeScreen extends StatefulWidget {
  static const routeName = '/dailyCallenge';

  @override
  _NewChallengeScreenState createState() => _NewChallengeScreenState();
}

class _NewChallengeScreenState extends State<NewChallengeScreen> {
  final Auth _auth = Auth();

  //final ChallengeTile _ct = ChallengeTile(); 
  
  int counterMainScreen = 0;
  
  @override
  void initState() {
    super.initState();
  }

  void getTheCounter (){
    //counterMainScreen = _ct.theValueOfCounter;
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Challenge>>.value(
      value: ChallengeService().reciveAllChallengesFromDB,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Daily Challenge Screen'),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.0,
          actions: <Widget>[
            // FlatButton.icon(
            //     onPressed: () async {
            //       await _auth.logOut();
            //     },
            //     icon: Icon(Icons.person),
            //     label: Text('Logout'))
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              child: Expanded(
                child: Calendar()
                )
            ),

          
             ChallengeList(),
             

            Text(
            'You Did $counterMainScreen until today',
             
            style: TextStyle(
              color: Colors.red,
              fontSize: 15.0
            ),
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
    );
  }
}
