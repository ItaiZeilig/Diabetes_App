import 'package:diabetes_app/screens/edit_challenge_screen.dart';
import '../models/challenge.dart';
import '../providers/challenge_provider.dart';
import '../widgets/single_challenge_widget.dart';
import 'package:flutter/material.dart';

class DismissibleSingleChallenge extends StatelessWidget {
  const DismissibleSingleChallenge({
    Key key,
    @required ChallengesProvider challengesProvider,
    @required this.challenge,
    this.mainContext,
    @required Size deviceSize,
  })  : _challengesProvider = challengesProvider,
        _deviceSize = deviceSize,
        super(key: key);
  final BuildContext mainContext;
  final ChallengesProvider _challengesProvider;
  final Challenge challenge;
  final Size _deviceSize;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      background: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: _challengesProvider.allChallengesTabIndex == 0
            ? Colors.orangeAccent.shade100
            : Colors.greenAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                Icon(
                  Icons.archive,
                  color: Colors.white,
                ),
                Text(
                  _challengesProvider.allChallengesTabIndex == 0
                      ? " Archive"
                      : " Active",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        if (_challengesProvider.allChallengesTabIndex == 0)
          challenge.active = false;
        else
          challenge.active = true;
        _challengesProvider.updateSingleChallenge(challenge);
      },
      key: ValueKey(challenge.id),
      child: InkWell(
        onTap: () {
          Navigator.of(mainContext)
              .pushNamed(EditChallengeScreen.routeName, arguments: [challenge]);
        },
        child: SingleChallenge(
          challenge,
        ),
      ),
    );
  }
}
