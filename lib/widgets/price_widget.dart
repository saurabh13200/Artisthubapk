import 'package:artisthub/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import '../services/utils.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({
    Key?key, 
    required this.salePrice,
    required this.price,
    required this.textPrice,
    required this.isOnSale,
  }) : super(key: key);
final double salePrice, price;
final String textPrice;
final bool isOnSale;
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    double userPrice = isOnSale? salePrice : price;
    return FittedBox(
      child: Row(
       children: [
        TextWidget(
          text:'\₹${(userPrice * double.parse(textPrice)).toStringAsFixed(2)} ',//'\₹${(userPrice* int.parse(textPrice)).toStringAsFixed(2)}',
          color: Colors.green, 
          textSize: 12,
        ),
        const SizedBox(
          width: 5,
        ),
        Visibility(
          visible: isOnSale?true : false,
          child: Text(
            '\₹${(price* double.parse(textPrice)).toStringAsFixed(2)}',//
            style: TextStyle(
              fontSize: 9,
              color: color,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ),
       ], 

    ));
  }
}