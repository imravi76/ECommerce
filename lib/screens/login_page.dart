import 'package:e_commerce/constants.dart';
import 'package:e_commerce/screens/register_page.dart';
import 'package:e_commerce/widgets/custom_btn.dart';
import 'package:e_commerce/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _loginFormLoading = false;

  String _loginEmail = "";
  String _loginPassword = "";

  late FocusNode _emailFocusNode, _passwordFocusNode;

  @override
  void initState(){
    _passwordFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose(){
    _emailFocusNode = FocusNode();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _alertDialogBuilder(String error) async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: const Text("Error"),
            content: Text(error),
            actions: [
              TextButton(
                child: const Text("Close"),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Future<String?> _loginAccount() async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmail,
          password: _loginPassword);
      return null;
    } on FirebaseAuthException catch(e){
      if(e.code == 'weak-password'){
        return 'The Password is too weak.';
      } else if(e.code == 'email-already-in-use'){
        return 'The Account already exists for this email';
      }
      return e.message;
    } catch(e){
      return e.toString();
    }
  }

  void _submitForm() async{
    setState(() {
      _loginFormLoading = true;
    });

    String? _loginAccountFeedback = await _loginAccount();
    if(_loginAccountFeedback != null){
      _alertDialogBuilder(_loginAccountFeedback);

      setState(() {
        _loginFormLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Container(
              child: const Text(
                "Welcome User\nLogin to your Account",
                style: Constants.regularHeading,
                textAlign: TextAlign.center,
              ),
              padding: const EdgeInsets.only(top: 24.0),
            ),

            Column(
              children: [

                CustomInput(
                  hints: "Email...",
                  onChanged: (value){
                    _loginEmail = value;
                  },
                  onSubmitted: (value){
                    _passwordFocusNode.requestFocus();
                  },
                  textInputAction: TextInputAction.next,
                  isPasswordField: false,
                  focusNode: _emailFocusNode,
                ),

                CustomInput(
                  hints: "Password...",
                  onChanged: (value){
                    _loginPassword = value;
                  },
                  onSubmitted: (value){
                    _submitForm();
                  },
                  textInputAction: TextInputAction.done,
                  focusNode: _passwordFocusNode,
                  isPasswordField: true,
                ),

                CustomBtn(
                    text: "Login",
                    onPressed: () {
                      _submitForm();
                    },

                    isLoading: _loginFormLoading,
                )
              ],
            ),

            Padding(

              padding: const EdgeInsets.only(
                bottom: 16.0
              ),

              child: CustomBtn(
                text: "Create new Account",
                outlineBtn: true,

                onPressed: () {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()));
                },
              ),
            )

          ],
        ),
      ),
    )
    );
  }
}
