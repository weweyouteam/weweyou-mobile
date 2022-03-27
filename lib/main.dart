// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:weweyou/provider/UserDataProvider.dart';
import 'package:weweyou/screens/splash.dart';
import 'package:weweyou/utils/constants.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserDataProvider>(
          create: (_) => UserDataProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weweyou',
        theme: ThemeData(
            primarySwatch: Colors.red,
            primaryColor: Colors.red
        ),
        home: SplashScreen(),
      )
    );
  }
}

