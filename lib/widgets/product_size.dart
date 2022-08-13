import 'package:flutter/material.dart';

class ProductSize extends StatefulWidget {

  final List? productSizes;
  final Function(String)? onSelected;

  const ProductSize({Key? key, this.productSizes, this.onSelected}) : super(key: key);

  @override
  _ProductSizeState createState() => _ProductSizeState();
}

class _ProductSizeState extends State<ProductSize> {

  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0
      ),
      child: Row(
        children: [
          for(var i = 0; i < widget.productSizes!.length; i++)

            GestureDetector(
              onTap: (){
                widget.onSelected!("${(widget.productSizes as dynamic)[i]}");
                setState(() {
                  _selected = i;
                });
              },
              child: Container(
                width: 42.0,
                height: 42.0,
                child: Text(
                  "${(widget.productSizes as dynamic)[i]}",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: _selected == i ? Colors.white : Colors.black,
                  ),
                ),
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(
                  horizontal: 4.0
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: _selected == i ? Colors.deepOrange : Colors.black12
                ),
              ),
            )
        ],
      ),
    );
  }
}
