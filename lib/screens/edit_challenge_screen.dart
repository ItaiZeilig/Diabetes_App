import 'package:diabetes_app/widgets/single_challenge_widget.dart';
import 'package:provider/provider.dart';
import '../models/challenge.dart';
import '../providers/challenge_provider.dart';
import 'package:flutter/material.dart';

class EditChallengeScreen extends StatefulWidget {
  static const routeName = '/editChallenge';
  @override
  _EditChallengeScreenState createState() => _EditChallengeScreenState();
}

class _EditChallengeScreenState extends State<EditChallengeScreen> {
  ChallengesProvider challengesProvider;
  Challenge challenge;

  final List<String> categorys = ['Sport', 'Nutrition', 'Medical'];
  final List<String> diabetesTypes = [
    '1',
    '2',
    'GDM',
    'MODY',
    'PREDIABETES',
    'other'
  ];
  final _formKey = GlobalKey<FormState>();

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    await challengesProvider.updateSingleChallenge(challenge).whenComplete(() {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    challengesProvider = Provider.of<ChallengesProvider>(context);
    List<Object> args = ModalRoute.of(context).settings.arguments;
    if (args.length > 0) {
      challenge = args[0];
    } else {
      challenge = Challenge(numberOfItems: 1);
    }
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.arrow_back_ios),
                ),
                IconButton(
                  onPressed: () {
                    challengesProvider
                        .deleteChallenge(challenge)
                        .whenComplete(() {
                      Navigator.of(context).pop();
                    });
                  },
                  icon: Icon(Icons.delete_outline),
                ),
              ],
            ),
            SingleChallenge(challenge),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    cursorColor: Theme.of(context).primaryColor,
                    initialValue: challenge.name,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
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
                      setState(() {
                        challenge.name = value;
                      });
                    },
                    onSaved: (value) {
                      challenge.name = value;
                    },
                  ),
                  TextFormField(
                    cursorColor: Theme.of(context).primaryColor,
                    initialValue: "1",
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
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
                      setState(() {
                        challenge.numberOfItems = int.parse(value);
                      });
                    },
                    onSaved: (value) {
                      challenge.numberOfItems = int.parse(value);
                    },
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
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
                      setState(() {
                        challenge.type = value;
                      });
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
                        color: Theme.of(context).primaryColor,
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
                      setState(() {
                        challenge.diabetesType = int.parse(value);
                      });
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
            RaisedButton(
              color: Theme.of(context).accentColor,
              onPressed: _submit,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'Save',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
