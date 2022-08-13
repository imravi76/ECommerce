import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/services/firebase_services.dart';
import 'package:e_commerce/widgets/custom_action_bar.dart';
import 'package:e_commerce/widgets/image_swipe.dart';
import 'package:e_commerce/widgets/product_quantity.dart';
import 'package:e_commerce/widgets/product_size.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {

  final String? productId;

  ProductPage({Key? key, this.productId}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  String _selectedProductSize = "0";
  int? _quantity = 0;
  num? _price = 0;

  final FirebaseServices _firebaseServices = FirebaseServices();

  Future _addToCart(){
    return _firebaseServices.usersRef.doc(_firebaseServices.getUserId()).collection("Cart").doc(widget.productId).
    set({"size": _selectedProductSize, "quantity": _quantity.toString(), "price": _price});
  }

  Future _addToSaved(){
    return _firebaseServices.usersRef.doc(_firebaseServices.getUserId()).collection("Saved").doc(widget.productId).
        set({"size": _selectedProductSize});
  }

  final SnackBar _cartSnackBar = const SnackBar(content: Text("Product added to the Cart"));
  final SnackBar _saveSnackBar = const SnackBar(content: Text("Product Saved!"));
  final SnackBar _alreadySnackBar = const SnackBar(content: Text("Product already added"));

  bool savedAlready = false;
  bool cartAlready = false;

  @override
  Widget build(BuildContext context) {

    _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Saved")
        .doc(widget.productId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        savedAlready = true;

      }
    });

    _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Cart")
        .doc(widget.productId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        cartAlready = true;

      }
    });

    return Scaffold(
      body: Stack(
        children: [

          FutureBuilder(

              future: _firebaseServices.productsRef.doc(widget.productId).get(),
              builder: (context, snapshot) {

                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text("Error: ${snapshot.error}"),
                    ),
                  );
                }

                if(snapshot.connectionState == ConnectionState.done){
                  Map<String, dynamic> documentData = (snapshot.data as dynamic).data();

                  List imageList = documentData['images'];
                  List productSizes = documentData['size'];

                  _selectedProductSize = productSizes[0];
                  _quantity = 1;

                  return ListView(
                    padding: const EdgeInsets.all(0),
                    children: [
                      
                      ImageSwipe(imageList: imageList),
                      
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 24.0,
                          left: 24.0,
                          right: 24.0,
                          bottom: 4.0
                        ),
                        child: Text(
                            "${documentData['name']}",
                        style: Constants.boldHeading,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 24.0,
                        ),
                        child: Text(
                            "₹${documentData['price']}",
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 24.0,
                        ),
                        child: Text(
                            "${documentData['desc']}",
                          style: const TextStyle(
                            fontSize: 16.0
                          ),
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 24.0,
                          horizontal: 24.0,
                        ),
                        child: Text(
                            "Select Size:",
                          style: Constants.regularDarkText,
                        ),
                      ),

                      ProductSize(
                        productSizes: productSizes,
                        onSelected: (size){
                          _selectedProductSize = size;
                        },
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 24.0,
                        ),
                        child: Text(
                          "Quantity:",
                          style: Constants.regularDarkText,
                        ),
                      ),

                      Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 24.0
                          ),
                        child: ProductQuantity(
                          onSelected: (quan){
                            _quantity = quan;
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: savedAlready ? (){Scaffold.of(context).showSnackBar(_alreadySnackBar);} : () async{
                                await _addToSaved();

                                setState(() {
                                  Scaffold.of(context).showSnackBar(_saveSnackBar);
                                });
                                },
                              child: Container(
                                  width: 65.0,
                                  height: 65.0,
                                  decoration: BoxDecoration(
                                    color: savedAlready ? Colors.black : const Color(0xFFDCDCDC),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  alignment: Alignment.center,
                                  child: Image(
                                    image: const AssetImage(
                                      "assets/images/tab_saved.png",
                                    ),
                                    color: savedAlready ? Colors.white : null,
                                    height: 22.0,

                                ),
                              ),
                            ),
                            Expanded(

                                child: GestureDetector(
                                  onTap: cartAlready ? (){Scaffold.of(context).showSnackBar(_alreadySnackBar);} : () async{
                                    _price = (_quantity! * documentData['price']);

                                    await _addToCart();

                                    setState(() {
                                      Scaffold.of(context).showSnackBar(_cartSnackBar);
                                    });
                                  },
                                  child: Container(
                                    height: 65.0,
                                    margin: const EdgeInsets.only(
                                      left: 16.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      cartAlready ? "Already added to Cart" : "Add to Cart",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),

                          ],
                        ),
                      )
                    ],
                  );
                }

                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
          ),

          CustomActionBar(
            hasBackArrow: true,
          ),
        ],
      ),
    );
  }
}
