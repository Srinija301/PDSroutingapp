import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pds_route/dataHandler/appData.dart';
import 'package:pds_route/screens/search_screen.dart';
import 'package:pds_route/screens/stepper_demo.dart';
import 'package:pds_route/screens/welcome_screen.dart';
import 'package:pds_route/screens/login_screen.dart';
import 'package:pds_route/screens/registration_screen.dart';
import 'package:pds_route/screens/maps_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          MapsScreen.id: (context) => MapsScreen(),
          SearchScreen.id: (context) => SearchScreen(),
          StepperDemo.id: (context) => StepperDemo(),
        },
      ),
    );
  }
}
