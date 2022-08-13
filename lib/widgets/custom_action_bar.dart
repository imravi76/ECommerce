import 'package:e_commerce/constants.dart';
import 'package:e_commerce/screens/cart_page.dart';
import 'package:e_commerce/services/firebase_services.dart';
import 'package:flutter/material.dart';

class CustomActionBar extends StatelessWidget {

  final String? title;
  final bool? hasBackArrow, hasTitle, hasBackground;

  CustomActionBar({Key? key, this.title, this.hasBackArrow, this.hasTitle, this.hasBackground}) : super(key: key);

  final FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {

    bool _hasBackArrow = hasBackArrow ?? false;
    bool _hasTitle = hasTitle ?? false;
    bool _hasBackground = hasBackground ?? false;

    return Container(
      padding: const EdgeInsets.only(
        top: 56.0,
        left: 24.0,
        right: 24.0,
        bottom: 42.0
      ),

      decoration: BoxDecoration(
        gradient: _hasBackground ? LinearGradient(
          colors: [
            Colors.white,
            Colors.white.withOpacity(0)
          ],
          begin: const Alignment(0, 0),
          end: const Alignment(0, 1)
        ) : null
      ),

      child: Row(
        children: [

          if(_hasBackArrow)
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                child: const Image(
                  image: AssetImage(
                    "assets/images/back_arrow.png"
                  ),
                  width: 16.0,
                  height: 16.0,
                ),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0)
                ),
                width: 42.0,
                height: 42.0,
                alignment: Alignment.center,
              ),
            ),

          if(_hasTitle)
            Text(
              title ?? "Action Bar",
              style: Constants.boldHeading,
            ),

          GestureDetector(
            onTap: (){
              Navigator.push(
                  context, MaterialPageRoute(
                  builder: (context) => const CartPage()
              )
              );
            },
            child: Container(
              child: StreamBuilder(
                stream: _firebaseServices.usersRef.doc(_firebaseServices.getUserId()).collection("Cart").snapshots(),
                builder: (context, snapshot){
                  int _totalItems = 0;

                  if(snapshot.connectionState == ConnectionState.active){
                    List _documents = (snapshot.data as dynamic).docs;
                    _totalItems = _documents.length;
                  }
                  return Text(
                    "$_totalItems",
                    style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.white),
                  );
                },
              ),
              width: 42.0,
              height: 42.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _hasBackArrow ? Colors.deepOrange : Colors.black,
                borderRadius: BorderRadius.circular(8.0)
              ),
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}
