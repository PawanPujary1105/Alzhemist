import 'package:alzaware/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AlzAware());
}

class AlzAware extends StatelessWidget {

  final int appBarSwatchPrimary = 0xFF77ADDC;

  const AlzAware({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialColor appBarSwatch = MaterialColor( appBarSwatchPrimary, <int,Color>{
      50: Color(0xFF77ADDC),
      100: Color(0xFF77ADDC),
      200: Color(0xFF77ADDC),
      300: Color(0xFF77ADDC),
      400: Color(0xFF77ADDC),
      500: Color(appBarSwatchPrimary),
      600: Color(0xFF77ADDC),
      700: Color(0xFF77ADDC),
      800: Color(0xFF77ADDC),
      900: Color(0xFF77ADDC),
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: appBarSwatch,
        scaffoldBackgroundColor: Colors.white,
        cardColor: appBarSwatch,
        textTheme: const TextTheme(
          labelLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return const SignInAlzAware();
  }
}

