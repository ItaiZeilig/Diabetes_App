

import './screens/profile_screen.dart';
import './providers/challenge_provider.dart';
import './providers/chat_provider.dart';
import './screens/all_challenges_screen.dart';
import './screens/all_chats_screen.dart';
import './screens/daily_challenges_screen.dart';
import './screens/single_chat_screen.dart';
import './providers/auth_provider.dart';
import './screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/add_new_article_screen.dart';

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
          value: AuthProvider(),
        ),
        ChangeNotifierProvider.value(
          value: ChatProvider(),
        ),
        ChangeNotifierProvider.value(
          value: ChallengesProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'DoctorApp',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // Define the default brightness and colors.
            brightness: Brightness.light,
            primaryColor: Color(0xFF7f70e7),
            accentColor: Color(0xFFbac2fe),
          ),
          home: auth.handleAuth(),
          routes: {
            LoginScreen.routeName: (ctx) => LoginScreen(),
            SingleChatScreen.routeName: (ctx) => SingleChatScreen(),
            AllChatsScreen.routeName: (ctx) => AllChatsScreen(),
            DailyChallengesScreen.routeName: (ctx) => DailyChallengesScreen(),
            AllChallengesScreen.routeName: (ctx) => AllChallengesScreen(),
            ProfileScreen.routeName: (ctx) => ProfileScreen(),
            AddNewArticle.routeName: (ctx) => AddNewArticle(),
            //AddNewArticleSecond.routeName: (ctx) => AddNewArticleSecond(),
          },
        ),
      ),
    );
  }
}
