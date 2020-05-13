import 'package:flutter/material.dart';
import 'package:diabetes_app/dailyChallenge/challenge.dart';

class ChallengeTileHCP extends StatefulWidget {
  final Challenge challenge;

  ChallengeTileHCP({this.challenge});

  @override
  _ChallengeTileHCPState createState() => _ChallengeTileHCPState();
}

class _ChallengeTileHCPState extends State<ChallengeTileHCP> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 2.0,
      child: Container(
        child: ListTile(
          title: Text(
            widget.challenge.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
