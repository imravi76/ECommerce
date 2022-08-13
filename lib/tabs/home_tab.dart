import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/widgets/custom_action_bar.dart';
import 'package:e_commerce/widgets/product_card.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {

  HomeTab({Key? key}) : super(key: key);

  final CollectionReference _productsRef = FirebaseFirestore.instance.collection("Products");

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [

          FutureBuilder<QuerySnapshot>(
            future: _productsRef.get(),
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
                  padding: const EdgeInsets.only(
                      top: 108.0,
                      bottom: 12.0
                  ),

                  children: snapshot.data!.docs.map((document){

                    return ProductCard(
                      productId: document.id,
                      title: (document.data() as dynamic)['name'],
                      price: "₹${(document.data() as dynamic)['price']}",
                      imageUrl: (document.data() as dynamic)['images'][0],
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
            hasBackground: true,
            title: "Home",
          )

        ],
      ),
    );
  }
}
