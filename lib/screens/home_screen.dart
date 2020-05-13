import 'package:diabetes_app/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    
                      Column(
                        children: <Widget>[
                          Text(
                            "Hello,",
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ),
                          Text(
                            "Itay",
                            style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://p7.hiclipart.com/preview/14/65/239/ico-avatar-scalable-vector-graphics-icon-doctor-with-stethoscope.jpg"),
                    ),
                    MaterialButton(
                      onPressed: () => auth.logOut(),
                      splashColor: Theme.of(context).primaryColor,
                      child: Text(
                        'Sign Out',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
