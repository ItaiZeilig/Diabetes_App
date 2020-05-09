// import 'package:flutter/material.dart';
// import 'package:diabetes_app/providers/auth.dart';
// import 'package:diabetes_app/services/challenges_service.dart';

// class ChallegeListHCP extends StatefulWidget {
//   static const routeName = '/dailyCallengeHCP';

//   @override
//   _ChallegeListHCPState createState() => _ChallegeListHCPState();
  
// }

// class _ChallegeListHCPState extends State<ChallegeListHCP> {

//   final Auth _auth = Auth();

//   @override
//   void initState() {
//     super.initState();
//   }


//   @override
//   Widget build(BuildContext context) {
//     return StreamProvider<List<Challenge>>.value(
//       value: ChallengeService().reciveAllChallengesFromDB,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           title: Text('Daily Challenge Screen'),
//           backgroundColor: Theme.of(context).primaryColor,
//           elevation: 0.0,
//           actions: <Widget>[
//             // FlatButton.icon(
//             //     onPressed: () async {
//             //       await _auth.logOut();
//             //     },
//             //     icon: Icon(Icons.person),
//             //     label: Text('Logout'))
//           ],
//         )
//         ));
//   }
// }