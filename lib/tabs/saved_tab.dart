import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/screens/product_page.dart';
import 'package:e_commerce/services/firebase_services.dart';
import 'package:e_commerce/widgets/custom_action_bar.dart';
import 'package:flutter/material.dart';

class SavedTab extends StatefulWidget {


  SavedTab({Key? key}) : super(key: key);

  @override
  State<SavedTab> createState() => _SavedTabState();
}

class _SavedTabState extends State<SavedTab> {
  final FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
            children: [

        FutureBuilder<QuerySnapshot>(
          future: _firebaseServices.usersRef
            .doc(_firebaseServices.getUserId())
          .collection("Saved")
          .get(),
          builder: (context, snapshot) {

            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text("Error: ${snapshot.error}"),
                ),
              );
            }

    // Collection Data ready to display
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
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                   builder: (context) => ProductPage(
                      productId: document.id,
                    ),
                    ));
                  },

                  child: FutureBuilder(
                    future: _firebaseServices.productsRef
                    .doc(document.id)
                    .get(),
                    builder: (context, productSnap) {

                    if (productSnap.hasError) {
                      return Container(
                          child: Center(
                            child: Text("${productSnap.error}"),
                          ),
                      );
                    }

                    if (productSnap.connectionState == ConnectionState.done) {
                      Map _productMap = (productSnap.data as dynamic).data();

                     return Padding(
                        padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 24.0,
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
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
                                fontWeight: FontWeight.w600),
                                ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                                ),
                                child: Text(
                                "\$${_productMap['price']}",
                                style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.w600),
                                ),
                               ),
                              Text(
                                "Size - ${(document.data() as dynamic)['size']}",
                                style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),

                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  //_firebaseServices.usersRef.doc(_firebaseServices.getUserId()).collection("Cart").doc(document.id).delete();
                                  await FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async{
                                    await myTransaction.delete(_firebaseServices.usersRef.doc(_firebaseServices.getUserId()).collection("Saved").doc(document.id));
                                  });

                                  setState(() {
                                    _productMap.remove(_firebaseServices.usersRef.doc(_firebaseServices.getUserId()).collection("Saved").doc(document.id));
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

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
         );
        },
        ),


          CustomActionBar(
            hasBackArrow: false,
            hasTitle: true,
            title: "Saved Products",
          ),

        ],
      ),
    );
}}
