import 'package:diabetes_app/dailyChallenge/challenge_tile.dart';
import 'package:flutter/material.dart';
import 'package:diabetes_app/dailyChallenge/challenge.dart';

enum UserMode { HCP, Costomer }

class ChallengeList extends StatefulWidget {
  Function onTileClicked;
  List<Challenge> list = [];
  @override
  _ChallengeListState createState() => _ChallengeListState();

  ChallengeList(this.list, this.onTileClicked);
}

class _ChallengeListState extends State<ChallengeList> {
  //UserMode _userMode = UserMode.Costomer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final challenges = Provider.of<List<Challenge>>(context) ?? [];
    var list = widget.list;
    // todo load chalanges list from pref

    return Expanded(
      child: ListView.builder(
          itemCount: list?.length ?? 0,
          itemBuilder: (context, index) {
            return ChallengeTile( list[index], widget.onTileClicked);
          }
        ),
    );
  }
}
