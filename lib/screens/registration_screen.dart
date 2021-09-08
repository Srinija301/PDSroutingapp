import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pds_route/constants.dart';
import 'package:pds_route/custom_widgets/customSignInButton.dart';
import 'package:pds_route/custom_widgets/main_title.dart';
import 'package:pds_route/screens/maps_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String email;

  String password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              SizedBox(
                height: 40.0,
              ),
              MainTitle(
                mainTitle: 'Driver Registration',
                fontSize: 35,
              ),
              SizedBox(
                height: 40.0,
              ),
              TextField(
                decoration: kTextFieldDecoration.copyWith(hintText: 'Email'),
                onChanged: (value) {
                  email = value;
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                decoration: kTextFieldDecoration.copyWith(hintText: 'Password'),
                // obscureText: true,
                onChanged: (value) {
                  password = value;
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Vehicle Number'),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Driver Name'),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Driver Liscense'),
              ),
              SizedBox(
                height: 20.0,
              ),
              CustomSignInButton(
                buttonText: 'Submit',
                buttonColor: Color(0xff51adcf),
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final newUser = await auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser != null) {
                      Navigator.pushNamed(context, MapsScreen.id);
                    }

                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
