import '../widgets/dismissible_single_challenge_widget.dart';
import 'package:provider/provider.dart';
import '../models/challenge.dart';
import '../providers/challenge_provider.dart';
import 'package:flutter/material.dart';

class AllChallengesList extends StatefulWidget {
  @override
  _AllChallengesListState createState() => _AllChallengesListState();
}

class _AllChallengesListState extends State<AllChallengesList> {
  var firstInit = true;
  ChallengesProvider _challengesProvider;
  Size _deviceSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (firstInit) {
      _deviceSize = MediaQuery.of(context).size;
      _challengesProvider = Provider.of<ChallengesProvider>(context);
      setState(() {
        firstInit = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
        stream: _challengesProvider.getAllChallengesBySatusSnapshot(
            _challengesProvider.allChallengesTabIndex == 0 ? true : false),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return Container(
            height: _deviceSize.height,
            child: ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  Challenge challenge =
                      Challenge.fromSnapshot(snapshot.data.documents[index]);
                  if (challenge.name
                      .toLowerCase()
                      .contains(_challengesProvider.searchText) || _challengesProvider.searchText.trim().isEmpty) {
                    return DismissibleSingleChallenge(
                        challengesProvider: _challengesProvider,
                        challenge: challenge,
                        deviceSize: _deviceSize);
                  }
                }),
          );
        },
      ),
    );
  }
}


