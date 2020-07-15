import '../models/challenge.dart';
import '../providers/challenge_provider.dart';
import '../widgets/single_challenge_widget.dart';
import 'package:flutter/material.dart';

class SingleChallengeSaveDialog extends StatelessWidget {
  SingleChallengeSaveDialog(this.challenge, this.alertContext, this.mainContext,
      this.deviceSize, this.challengesProvider, this.addChallenge);

  bool addChallenge;
  Challenge challenge;
  BuildContext alertContext;
  BuildContext mainContext;
  Size deviceSize;
  ChallengesProvider challengesProvider;

  final List<String> categorys = ['Sport', 'Nutrition', 'Medical'];
  final List<String> diabetesTypes = ['1', '2'];
  final _formKey = GlobalKey<FormState>();

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    if (addChallenge) {
      challengesProvider.createChallenge(challenge).whenComplete(() {
        Navigator.of(alertContext).pop();
      });
    } else {
      challengesProvider.updateSingleChallenge(challenge).whenComplete(() {
        Navigator.of(alertContext).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier valueNotifier = ValueNotifier(challenge);
    return AlertDialog(
      content: SingleChildScrollView(
        child: Container(
          width: deviceSize.width,
          child: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: valueNotifier,
                builder: (_, value, child) {
                  return SingleChallenge(value);
                },
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      cursorColor: Theme.of(alertContext).primaryColor,
                      initialValue: challenge.name,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Theme.of(alertContext).primaryColor,
                        ),
                        labelText: 'Challenge name',
                      ),
                      keyboardType: TextInputType.text,
                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Invalid name!';
                        }
                      },
                      onChanged: (value) {
                        challenge.name = value;
                        valueNotifier.notifyListeners();
                      },
                      onSaved: (value) {
                        challenge.name = value;
                      },
                    ),
                    TextFormField(
                      cursorColor: Theme.of(alertContext).primaryColor,
                      initialValue: challenge.numberOfItems.toString(),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Theme.of(alertContext).primaryColor,
                        ),
                        labelText: 'Challenge number Of Items',
                      ),
                      keyboardType: TextInputType.number,
                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Invalid number Of Items!';
                        }
                      },
                      onChanged: (value) {
                        challenge.numberOfItems = int.parse(value);
                        valueNotifier.notifyListeners();
                      },
                      onSaved: (value) {
                        challenge.numberOfItems = int.parse(value);
                      },
                    ),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Theme.of(alertContext).primaryColor,
                        ),
                        labelText: 'Challenge type',
                      ),
                      value: challenge.type,
                      items: categorys.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text('$category'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        challenge.type = value;
                        valueNotifier.notifyListeners();
                      },
                      validator: (value) =>
                          value.isEmpty ? 'Please choose type!' : null,
                      onSaved: (value) {
                        challenge.type = value;
                      },
                    ),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Theme.of(alertContext).primaryColor,
                        ),
                        labelText: 'Challenge diabetes type',
                      ),
                      value: challenge.diabetesType.toString(),
                      items: diabetesTypes.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text('$category'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        challenge.diabetesType = int.parse(value);
                        valueNotifier.notifyListeners();
                      },
                      validator: (value) =>
                          value.isEmpty ? 'Please choose type!' : null,
                      onSaved: (value) {
                        challenge.diabetesType = int.parse(value);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        ButtonTheme(
          child: RaisedButton(
            color: Theme.of(alertContext).accentColor,
            onPressed: _submit,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              addChallenge ? 'Add' : 'Save',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
        SizedBox(
          width: deviceSize.width * 0.2,
        ),
        ButtonTheme(
          child: RaisedButton(
            color: Colors.redAccent,
            onPressed: () => Navigator.of(alertContext).pop(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
          side: BorderSide(
            style: BorderStyle.none,
          ),
          borderRadius: BorderRadius.circular(10)),
    );
  }
}
