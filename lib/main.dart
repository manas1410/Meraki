import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'voice.dart';
import 'helper/authentication.dart';
import 'helper/helperfunction.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? userIsLoggedIn;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TRANSLATA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff145C9E),
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: Authenticate(),
    );
  }
}

class IamBlank extends StatefulWidget {
  const IamBlank({Key? key}) : super(key: key);

  @override
  _IamBlankState createState() => _IamBlankState();
}

class _IamBlankState extends State<IamBlank> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
