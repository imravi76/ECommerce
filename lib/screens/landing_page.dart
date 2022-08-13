import 'package:e_commerce/constants.dart';
import 'package:e_commerce/screens/home_page.dart';
import 'package:e_commerce/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(

        future: _initialization,
        builder: (context, snapshot){

          if(snapshot.hasError){
            return Scaffold(
              body: Center(
                child: Text("Error: ${snapshot.error}"
                ),
              ),
            );
          }

          if(snapshot.connectionState == ConnectionState.done){
            return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, authsnapshot){

                if(authsnapshot.hasError){
                  return Scaffold(
                    body: Center(
                    child: Text(
                      "Error: ${authsnapshot.error}",
                      style: Constants.regularHeading,
                    ),
                    ),
                  );
                }

                if(authsnapshot.connectionState == ConnectionState.active){

                  User? _user = authsnapshot.data as User?;

                  if(_user == null){
                    return const LoginPage();
                  } else {
                    return const HomePage();
                  }
                }

                return const Scaffold(
                  body: Center(
                    child: Text(
                        "Checking Authentication.....",
                      style: Constants.regularHeading,
                    ),
                  ),
                );

              },
            );
          }

          return const Scaffold(
            body: Center(
              child: Text("Initialization App....."),
            ),
          );

        }

    );
  }
}