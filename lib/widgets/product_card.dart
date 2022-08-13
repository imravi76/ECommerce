import 'package:e_commerce/screens/product_page.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ProductCard extends StatelessWidget {

  final String? productId, imageUrl, title, price;
  final Function? onPressed;

  const ProductCard({Key? key, this.productId, this.imageUrl, this.title, this.price, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ProductPage(productId: productId,)
        )
        );
      },
      child: Container(

        child: Stack(
          children: [

            Container(
              height: 350.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title!,
                      style: Constants.regularHeading,
                    ),
                    Text(
                      price!,
                      style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepOrange
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),

        height: 350.0,
        margin: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 24.0
        ),

        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0)
        ),

      ),
    );
  }
}
