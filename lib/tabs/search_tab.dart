import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/services/firebase_services.dart';
import 'package:e_commerce/widgets/custom_input.dart';
import 'package:e_commerce/widgets/product_card.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {

  final FirebaseServices _firebaseServices = FirebaseServices();
  String _searchString = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [

          if(_searchString.isEmpty)
            Center(
              child: Container(
                child: const Text(
                  "Search Results",
                  style: Constants.regularDarkText,
                ),
              ),
            )

          else
            FutureBuilder<QuerySnapshot>(
              future: _firebaseServices.productsRef.orderBy("search_string").startAt([_searchString]).endAt(["$_searchString\uf8ff"])
              .get(),
              builder: (context, snapshot){
                if(snapshot.hasError){
                  return Scaffold(
                    body: Center(
                      child: Text("Error: ${snapshot.error}"),
                    ),
                  );
                }

                if(snapshot.connectionState == ConnectionState.done){
                  return ListView(
                    children: snapshot.data!.docs.map((document){
                      return ProductCard(
                        title: (document.data() as dynamic)['name'],
                        imageUrl: (document.data() as dynamic)['images'][0],
                        price: "₹${(document.data() as dynamic)['price']}",
                        productId: document.id,
                      );
                    }).toList(),

                    padding: const EdgeInsets.only(
                      top: 128.0,
                      bottom: 12.0
                    ),
                  );
                }

                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          Padding(
              padding: const EdgeInsets.only(
                top: 45.0,
              ),

            child: CustomInput(
              hints: "Search here...",
              onSubmitted: (value){
                setState(() {
                  _searchString = value.toLowerCase();
                });
              },
            ),
          ),

        ],
      )
    );
  }
}
