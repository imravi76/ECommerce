import 'package:e_commerce/constants.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class ProductQuantity extends StatefulWidget {

  int? selectedValue = 1;
  final Function(int?)? onSelected;

  ProductQuantity({Key? key, this.selectedValue, this.onSelected}) : super(key: key);

  @override
  _ProductQuantityState createState() => _ProductQuantityState();
}

class _ProductQuantityState extends State<ProductQuantity> {

  int _currentValue = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
          left: 20.0
        ),
      child: NumberPicker(
        value: _currentValue,
        minValue: 1,
        maxValue: 5,
        axis: Axis.horizontal,
        onChanged: (value) => setState(() {
          _currentValue = value;
          widget.selectedValue = value;
          widget.onSelected!(widget.selectedValue);
        }),
        textStyle: Constants.regularHeading,
        selectedTextStyle: const TextStyle(
          color: Colors.deepOrange,
          fontWeight: FontWeight.w900,
          fontSize: 24.0
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.black26)
        ),
      ),
    );
  }
}
