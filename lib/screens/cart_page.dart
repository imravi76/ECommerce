import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/screens/product_page.dart';
import 'package:e_commerce/services/firebase_services.dart';
import 'package:e_commerce/widgets/custom_action_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  final FirebaseServices _firebaseServices = FirebaseServices();
  double _sum = 0;
  double _total = 0;

  final SnackBar _cartSnackBar = const SnackBar(content: Text("Product removed from the Cart"));

  @override
  void initState() {
    // TODO: implement initState
    _firebaseServices.usersRef.doc(_firebaseServices.getUserId()).collection("Cart").get().then(
        (querySnapshot){
          for (var result in querySnapshot.docs) {
            _sum = _sum + (result.data() as dynamic)['price'];
          }
          setState(() {
            _total = _sum;
          });
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          FutureBuilder<QuerySnapshot>(
            future: _firebaseServices.usersRef.doc(_firebaseServices.getUserId()).collection("Cart").get(),
            builder: (context, snapshot){
              if(snapshot.hasError){
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                // Display the data inside a list view
                return ListView(
                  padding: const EdgeInsets.only(
                    top: 108.0,
                    bottom: 12.0,
                  ),
                  children: snapshot.data!.docs.map((document) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ProductPage(productId: document.id,),
                        ));
                      },
                      child: FutureBuilder(
                        future: _firebaseServices.productsRef.doc(document.id).get(),
                        builder: (context, productSnap) {
                          if(productSnap.hasError) {
                            return Container(
                              child: Center(
                                child: Text("${productSnap.error}"),
                              ),
                            );
                          }

                          if(productSnap.connectionState == ConnectionState.done) {
                            Map _productMap = (productSnap.data as dynamic).data();

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 24.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 90,
                                    height: 90,
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(8.0),
                                      child: Image.network(
                                        "${_productMap['images'][0]}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      left: 16.0,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${_productMap['name']}",
                                          style: const TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                              fontWeight:
                                              FontWeight.w600),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets
                                              .symmetric(
                                            vertical: 4.0,
                                          ),
                                          child: Text(
                                            "₹${(document.data() as dynamic)['price']}",
                                            style: const TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.deepOrange,
                                                fontWeight:
                                                FontWeight.w600),
                                          ),
                                        ),
                                        Text(
                                          "Size - ${(document.data() as dynamic)['size']}",
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black,
                                              fontWeight:
                                              FontWeight.w600),
                                        ),
                                        Text(
                                          "Quantity - ${(document.data() as dynamic)['quantity']}",
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black,
                                              fontWeight:
                                              FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          //_firebaseServices.usersRef.doc(_firebaseServices.getUserId()).collection("Cart").doc(document.id).delete();
                                          await FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async{
                                            await myTransaction.delete(_firebaseServices.usersRef.doc(_firebaseServices.getUserId()).collection("Cart").doc(document.id));
                                          });

                                          setState(() {
                                            _productMap.remove(_firebaseServices.usersRef.doc(_firebaseServices.getUserId()).collection("Cart").doc(document.id));
                                            Scaffold.of(context).showSnackBar(_cartSnackBar);
                                            _sum = 0.0;
                                            initState();

                                          });
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          size: 40.0,
                                          color: Colors.red,
                                        ),
                                      ),

                                  ),
                                ],
                              ),
                            );

                          }

                          return Container(
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                );
              }

              return Container(
                child: const Center(
                  child: CircularProgressIndicator(),
                )
              );
            },

          ),

          CustomActionBar(
            hasBackArrow: true,
            title: "Cart",
            hasTitle: true,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 24.0
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Wrap(
                runSpacing: 20.0,
                children: [
                  Text(
                      "Grand Total: ₹$_total",
                    style: Constants.regularHeading,
                  ),
                  GestureDetector(
                    onTap: (){
                      null;
                    },
                    child: Container(
                      height: 65.0,
                      margin: const EdgeInsets.only(
                        left: 0.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Checkout",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
