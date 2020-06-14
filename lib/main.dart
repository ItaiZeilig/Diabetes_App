
import 'package:diabetes_app/providers/user_service.dart';
import 'package:diabetes_app/screens/challenge_screen.dart';
import 'package:diabetes_app/screens/hcp_challenge_screen.dart';
import 'package:diabetes_app/chat/hcp_chat_home.dart';
import 'package:diabetes_app/screens/home_screen.dart';
import 'package:diabetes_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: UserService(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'DoctorApp',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // Define the default brightness and colors.
            brightness: Brightness.light,
            primaryColor: Color(0xFF7f70e7),
            accentColor: Color(0xFF7f70e7),
          ),
          home: auth.handleAuth(),
          routes: {
            LoginScreen.routeName: (ctx) => LoginScreen(),
            NewChallengeScreen.routeName: (ctx) => NewChallengeScreen(),
            HCPChallengeScreen.routeName: (ctx) => HCPChallengeScreen(),
            //HCPChatHomePage.routeName: (ctx) => HCPChatHomePage(currentUserId: auth.getUser.toString()),
            HCPChatHomePage.routeName: (ctx) => HCPChatHomePage(currentUserId: null),
          },
        ),
      ),
    );
  }
}