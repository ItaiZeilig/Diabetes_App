import 'package:flutter/material.dart';
import 'package:diabetes_app/services/challenges_service.dart';

class AddChallenge extends StatefulWidget {
  @override
  _AddChallengeState createState() => _AddChallengeState();
}

class _AddChallengeState extends State<AddChallenge> {
  final _formKey = GlobalKey<FormState>();
  final List<String> categorys = ['Sport', 'Health', 'Food'];

  String _challengeName;
  String _challengecategory;
  bool _sameNames;

  ChallengeService _challengeService = ChallengeService();

  @override
  void initState() {
    super.initState();
    //_sameNames = true;
  }

  checkChallengeName<bool>(String name) {
    _challengeService.doesNameAlreadyExist(name).then((val) {
      if (val) {
        print("UserName Already Exits");
        _sameNames = val; //returns true
      } else {
        print("UserName is Available");
        _sameNames = val; // return false
      }
      return _sameNames;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text(
            'Add New Challnge',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              fillColor: Colors.grey[350],
              hintText: 'Challenge Name',
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.pink, width: 2.0),
              ),
            ),
            validator: (val) {
              if (val.isEmpty) {
                return 'Add Challenge Name';
              }
              // else if (checkChallengeName(val[0].toUpperCase() + val.substring(1))){
              //   _sameNames = true;
              //   //checkChallengeName(val[0].toUpperCase() + val.substring(1))
              //   return 'This Name Exists';
              // }
              return null;
            },
            onChanged: (val) => setState(() => _challengeName = val),
          ),
          DropdownButtonFormField(
            value: _challengecategory ?? 'Sport',
            //hint: Text('Choose Category'),
            items: categorys.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text('$category'),
              );
            }).toList(),
            onChanged: (val) => setState(() => _challengecategory = val),
            validator: (val) => val.isEmpty ? 'Please choose category' : null,
            onSaved: (value) {
              if ((_challengecategory != null)) {
                _challengecategory = value;
              } else {
                _challengecategory = 'Sport';
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: RaisedButton(
              color: Colors.white,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Add Challenge  ',
                    style: TextStyle(color: Colors.black),
                  ),
                  Icon(
                    Icons.playlist_add_check,
                    color: Colors.green,
                  ),
                ],
              ),
              onPressed: () async {
                if(_formKey.currentState.validate()){
                //_formKey.currentState.validate();
                _formKey.currentState.save();

                if ((_challengeName != null) && (_sameNames != true)) {
                  _challengeService.addNewChallenge(
                      _challengeName,
                      _challengecategory,
                      _challengeService
                          .getChallngeId(_challengeName)
                          .toString(),
                      _challengeName.substring(0, 1).toUpperCase());
                  Navigator.of(context).pop();
                } else {
                  print('Error - Adding Challenge');
                }
                }
              },
            ),
          ),
        ],
      ),
    );

    //}
    //  else {
    //   return Scaffold(
    //     body: Center(
    //       child: Container(
    //         child: Text('Loading'),
    //       ),
    //     ),
    //   );
    // }
    //});
  }
}
