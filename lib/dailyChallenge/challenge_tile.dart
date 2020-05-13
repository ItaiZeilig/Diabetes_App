import 'package:flutter/material.dart';
import 'package:diabetes_app/dailyChallenge/challenge.dart';

class ChallengeTile extends StatefulWidget {
  final Challenge challenge;
  Function onTileClicked;

  ChallengeTile(this.challenge, this.onTileClicked);

  @override
  _ChallengeTileState createState() => _ChallengeTileState();
}

class _ChallengeTileState extends State<ChallengeTile> {
  Color backgroundColorOnTap;
  Icon changeIcon;
  bool isClicked = false;
  int counter = 0;
  

  @override
  void initState() {
    super.initState();
    backgroundColorOnTap = Colors.transparent;
    changeIcon = Icon(Icons.check_circle, color: Colors.green, size: 35.0);
  }

  void increment() {
    setState(() {
      counter++;
    });
  }

  int get theValueOfCounter {
    return counter;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Card(
          //color: Colors.grey.withOpacity(0.1),
          margin: EdgeInsets.fromLTRB(20.0, 5, 20.0, 0),
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
                child: changeIcon,
              ),
              title: Text(widget.challenge.name),
              subtitle: Text(widget.challenge.category),
              onTap: () {
                // if it's to increment so add eles remove
                isClicked = !isClicked;
                backgroundColorOnTap = Color(isClicked ? 0xFF86E3CE : 0xFFFFFFFF);
                //backgroundColorOnTap = Color(0xFFFFDD94);
                changeIcon = Icon(
                    isClicked ? Icons.favorite : Icons.check_circle,
                    color: Colors.red,
                    size: 35.0);
                widget.onTileClicked(isClicked);
                // setState(() {
                //   backgroundColorOnTap = Color(isClicked?0xFF86E3CE:0xFFFFDD94);
                //   //backgroundColorOnTap = Color(0xFFFFDD94);
                //   changeIcon = Icon(isClicked?Icons.favorite:Icons.check_circle, color: Colors.red, size: 35.0);
                // });
              },
            ),
          ),
        ));
  }
}
