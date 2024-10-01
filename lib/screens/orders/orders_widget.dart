

import 'package:artisthub/inner_screens/product_details.dart';
import 'package:artisthub/models/orders_model.dart';
import 'package:artisthub/services/global_methods.dart';
import 'package:artisthub/services/utils.dart';
import 'package:artisthub/widgets/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/products_provider.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({super.key});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  late String orderDateToShow;

  @override
  void didChangeDependencies() {
     final ordersModel = Provider.of<OrderModel>(context);
     var orderDate = ordersModel.orderDate.toDate();
     orderDateToShow = '${orderDate.day}/${orderDate.month}/${orderDate.year}';
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final ordersModel = Provider.of<OrderModel>(context);
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
     final productsProvider = Provider.of<ProductsProvider>(context);
    final getCurrProduct = productsProvider.findProdById(ordersModel.productId);
    return ListTile(
      subtitle:
          Text('Paid: \₹${double.parse(ordersModel.price).toStringAsFixed(2)}'),
      onTap: (){
        // GlobalMethods.navigateTo(
        //   ctx: context, routeName: ProductDetails.routeName);

      },
     
        leading: FancyShimmerImage(
                     width: size.width * 0.2,
                      imageUrl: getCurrProduct.imageUrl,
                      boxFit: BoxFit.fill,
     ),
      
      title: TextWidget(
          text: '${getCurrProduct.title}  x${ordersModel.quantity}',
          color: color,
          textSize: 18),
      trailing: TextWidget(text: orderDateToShow, color: color, textSize: 18),
    );
  }
}