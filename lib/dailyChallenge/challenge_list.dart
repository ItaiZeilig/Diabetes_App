import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:diabetes_app/dailyChallenge/challenge.dart';
import 'package:diabetes_app/dailyChallenge/challenge_tile.dart';
import 'dart:math';



class ChallengeList extends StatefulWidget {
  @override
  _ChallengeListState createState() => _ChallengeListState();
}

class _ChallengeListState extends State<ChallengeList> {

  //TODO - for random need to have a list<int> of all the indexes from db
  //To know the size of it
  //To disply only 3 challenges by random function (itemCount, itemBuilder)
  
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final challenges = Provider.of<List<Challenge>>(context);
    
    //int returnCounter;
    

    return Expanded(
      child: ListView.builder(
          itemCount: challenges?.length ?? 0, 
          //itemCount: challenges?.setRange(challenges[index].randIndex.round(1), 4, challenges), 
          //itemCount: challenges?.setRange(1, 4, challenges), 
          itemBuilder: (context, index) {
            return ChallengeTile(challenge: challenges[index]); //Takes everytime single challenge in index 0, 1 , 2
          }),
    );
  }
}
