import 'package:flutter/material.dart';
import 'package:diabetes_app/services/challenges_service.dart';

class UpdateChallenge extends StatefulWidget {

  final String challeName;
  final String cateName;
  UpdateChallenge({this.challeName, this.cateName});

  @override
  _UpdateChallengeState createState() => _UpdateChallengeState();
}

class _UpdateChallengeState extends State<UpdateChallenge> {
  final _formKey = GlobalKey<FormState>();
  final List<String> categorys = [
    'Sport',
    'Health',
    'Food'
  ]; 

  String _challengeName;
  String _challengecategory;
  String _nameBeforeUpdate;

  ChallengeService _challengeService = ChallengeService();

  @override
  void initState() {
    _nameBeforeUpdate = widget.challeName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Text(
              'Update Current Challnge',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              initialValue: widget.challeName,
              decoration: InputDecoration(
                fillColor: Colors.grey[350],
                hintText: 'Update Challenge Name',
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink, width: 2.0),
                ),
              ),
              validator: (val) => val.isEmpty ? 'Update Challenge Name' : widget.challeName,               
              onChanged: (val) => setState(() => _challengeName = val),
              onSaved: (val){
                if(_nameBeforeUpdate.toUpperCase().compareTo(val.toUpperCase()) == 0){
                  _challengeName = _nameBeforeUpdate;
                }
                else{
                  _challengeName = val;
                }
              },
              
              //onChanged: (val) => val.compareTo(_nameBeforeUpdate) == 0 ? setState(() => _challengeName = _nameBeforeUpdate) : setState(() => _challengeName = val) ,
              
            ),
            DropdownButtonFormField(
                value: _challengecategory ?? widget.cateName,
                validator: (val) => val.isEmpty ? 'Update Challenge Name' : widget.cateName,
                //challenge.category, //Need to change defaul value
                items: categorys.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text('$category'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _challengecategory = val),
                onSaved: (String value){
                  if((_challengecategory != null)){
                    _challengecategory = value;
                  }
                  else{
                  _challengecategory = 'Sport';
                  }
                }
                ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Text('Delete ',
                        style: TextStyle(color: Colors.black),
                      ),
                      Icon(Icons.delete, color: Colors.red,
                      ),
                    ],
                  ),
                  onPressed: () async {
                    print(_challengeName);
                    print(_challengecategory);
                    _challengeService.deleteChallemngeByName(widget.challeName);
                    print('Challenge Deleted');
                    Navigator.of(context).pop();
                  },
                ),
                RaisedButton(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('Update ',
                        style: TextStyle(color: Colors.black),
                      ),
                      Icon(Icons.system_update_alt, color: Colors.green,
                      ),
                    ],
                  ),
                  onPressed: () async {
                    _formKey.currentState.save(); 
        
                    _challengeService.updateChallemngeByName(
                      _nameBeforeUpdate,
                      _challengeName,
                      _challengecategory,
                      _challengeName.substring(0,1).toUpperCase());
                    print("Update Successfully");
                    print(_challengeName);
                    print(_challengecategory);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ));
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
