

import 'package:flutter/material.dart';
import 'package:diabetes_app/dailyChallenge/challenge.dart';


// class BloCSetting extends State {
//   rebuildWidgets({VoidCallback setStates, List<State> states}) {
//     if (states != null) {
//       states.forEach((s) {
//         if (s != null && s.mounted) s.setState(setStates ??(){});
//       });
//     }
//   }
// @override
//   Widget build(BuildContext context) {
//     print(
//         "This build function will never be called. it has to be overriden here because State interface requires this");
//     return null;
//   }
// }




class ChallengeTile extends StatefulWidget {
  
  final Challenge challenge;

  ChallengeTile({this.challenge});

  @override
  _ChallengeTileState createState() => _ChallengeTileState();
}

class _ChallengeTileState extends State<ChallengeTile> {

  Color backgroundColorOnTap;
  Icon changeIcon;
  bool isEnableTile = true;

  int counter = 0;
  int value = 0;
  
  Map <String, int> sum;


  @override
  void initState() {
    
    super.initState();
    backgroundColorOnTap = Colors.transparent;
    changeIcon = Icon(Icons.check_circle, color: Colors.green, size: 35.0);
  }

  // int incrementCounter() {
  //   setState(() {
  //     counter++;
  //   });
  //   return counter;
  // }


  rebuildWidgets({VoidCallback setStates, List<State> states}) {
    if (states != null) {
      states.forEach((s) {
        if (s != null && s.mounted) s.setState(setStates ??(){});
      });
    }
  }

  incrementCount(state) {
    rebuildWidgets( 
      setStates: () {
      counter++;  
    },
    states: [state],
    );
  }

  int increment(int counter){
    counter++;
    return counter;
  }

  int get theValueOfCounter {
    return counter;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      
      padding: EdgeInsets.only(top:10.0),
      
      
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6, 20.0, 0),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        
        
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColorOnTap,
            borderRadius: BorderRadius.circular(20.0),
          ),

          
          child: ListTile(            
            leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.white,
              //foregroundColor: Colors.white,
              child: changeIcon,
            ),
            
            title: Text(widget.challenge.name),            
            subtitle: Text(widget.challenge.category),
            
            onTap:() { // TODO - Need to add counter to know how many times challenge made for week/month
              if(isEnableTile == true){
                setState(() {
                  isEnableTile = false;
                  backgroundColorOnTap = Color(0xFF86E3CE);
                  //backgroundColorOnTap = Color(0xFFFFDD94);
                  changeIcon = Icon(Icons.favorite, color: Colors.red, size: 35.0);
                  value = increment(counter);
                  print(value);
                }); 
              } 
              else {
                
              }
            },            
          ),
        ),
      )
    );
  }
}

