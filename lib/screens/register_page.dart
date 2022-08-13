import 'package:e_commerce/constants.dart';
import 'package:e_commerce/widgets/custom_btn.dart';
import 'package:e_commerce/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool _registerFormLoading = false;

  String _registerEmail = "";
  String _registerPassword = "";

  late FocusNode _passwordFocusNode;

  @override
  void initState(){
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose(){
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _alertDialogBuilder( String error) async{
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

  Future<String?> _createAccount() async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registerEmail,
          password: _registerPassword);
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
      _registerFormLoading = true;
    });

    String? _createAccountFeedback = await _createAccount();
    if(_createAccountFeedback != null){
      _alertDialogBuilder(_createAccountFeedback);

      setState(() {
        _registerFormLoading = false;
      });
    } else{
      Navigator.pop(context);
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
                    "Welcome User\nSign Up for new Account",
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
                        _registerEmail = value;
                      },
                      onSubmitted: (value){
                        _passwordFocusNode.requestFocus();
                      },
                      textInputAction: TextInputAction.next,
                    ),

                    CustomInput(
                      hints: "Password...",
                      onChanged: (value){
                        _registerPassword = value;
                      },
                      onSubmitted: (value){
                        _submitForm();
                      },
                      focusNode: _passwordFocusNode,
                      isPasswordField: true,
                    ),

                    CustomBtn(
                        text: "Sign Up",
                        onPressed: () {
                          //_alertDialogBuilder();
                          _submitForm();
                        },

                        isLoading: _registerFormLoading,
                    )
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 16.0
                  ),
                  child: CustomBtn(
                    text: "Already have Account? Login Here!",
                    outlineBtn: true,

                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )

              ],
            ),
          ),
        ));
  }
}
