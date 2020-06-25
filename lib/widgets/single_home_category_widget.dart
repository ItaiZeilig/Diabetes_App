import 'package:flutter/material.dart';

class SingleHomeCategory extends StatelessWidget {
  
  SingleHomeCategory({this.name, this.icon, this.routeName});

  String routeName;
  String name;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.of(context).pushNamed(routeName)
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Theme.of(context).accentColor),
        child: Column(
          children: <Widget>[
            Icon(icon),
            Text(name),
          ],
        ),
      ),
    );
  }
}
