
import 'package:diabetes_app/services/challenges_service.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:diabetes_app/dailyChallenge/challenge_list.dart';
import 'package:diabetes_app/dailyChallenge/challenge.dart';
import 'package:diabetes_app/providers/auth.dart';


class DailyChallenge extends StatefulWidget {
  static const routeName = '/dailyCallenge';
  @override
  _DailyChallenge createState() => _DailyChallenge();
}

class _DailyChallenge extends State<DailyChallenge> {
  CalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
   
    Future<void> _refreshList() async { 
    }

    Auth auth = Provider.of<Auth>(context);

    return StreamProvider<List<Challenge>>.value(
      value: ChallengeService().reciveAllChallengesFromDB,
      child: Scaffold(
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
        body: new RefreshIndicator(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //Calendar(),
              TableCalendar(
                initialCalendarFormat: CalendarFormat.twoWeeks,
                calendarStyle: CalendarStyle(
                    todayColor: Theme.of(context).primaryColor,
                    selectedColor: Color(0xFFB0E9EF),
                    todayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                calendarController: _controller,
              ),

              new Center(
                  child: Text(
                'Your Score is: ',
                style: TextStyle(color: Colors.deepPurple, fontSize: 20),
                textAlign: TextAlign.center,
              )
              ),

              //ChallengeList(), 
              MaterialButton(
                onPressed: () => auth.logOut(),
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
          onRefresh: _refreshList,
        ),
      ),
    );
  }
}
