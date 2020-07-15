import '../models/challenge.dart';
import '../providers/auth_provider.dart';
import '../providers/challenge_provider.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class SingleChallenge extends StatelessWidget {
  SingleChallenge(this.challenge);

  Challenge challenge;
  ChallengesProvider _challengesProvider;
  AuthProvider _auth;

  Color getBackgroundColorByType(String type) {
    switch (type) {
      case "Sport":
        return Color(0xFFffdaa7);
        break;
      case "Nutrition":
        return Color(0xFFaee3d9);
        break;
      case "Medical":
        return Color(0xFFffc5c4);
        break;
      default:
    }
  }

  Color getPrograssColorByType(String type) {
    switch (type) {
      case "Sport":
        return Color(0xFFfcc074);
        break;
      case "Nutrition":
        return Color(0xFF6dcdb8);
        break;
      case "Medical":
        return Color(0xFFffa5a4);
        break;
      default:
    }
  }

  IconData getIconByType(String type) {
    switch (type) {
      case "Sport":
        return Icons.directions_run;
        break;
      case "Nutrition":
        return Icons.fastfood;
        break;
      case "Medical":
        return Icons.filter_vintage;
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size _deviceSize = MediaQuery.of(context).size;
    _challengesProvider = Provider.of<ChallengesProvider>(context);
    _auth = Provider.of<AuthProvider>(context);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: getBackgroundColorByType(challenge.type),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              getIconByType(challenge.type),
              color: Colors.white,
            ),
          ),
          Container(
            width: _deviceSize.width * 0.5,
            child: Column(
              children: [
                Text(
                  challenge.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "${challenge.type}",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ],
            ),
          ),
          CircularPercentIndicator(
            radius: 50.0,
            lineWidth: 5.0,
            center: challenge.done
                ? Icon(
                    Icons.done_outline,
                    color: Colors.green,
                  )
                : Text("${challenge.numberOfItems - challenge.doneItems}"),
            percent: (challenge.doneItems / challenge.numberOfItems),
            backgroundColor: getBackgroundColorByType(challenge.type),
            progressColor: getPrograssColorByType(challenge.type),
          ),
        ],
      ),
    );
  }
}
