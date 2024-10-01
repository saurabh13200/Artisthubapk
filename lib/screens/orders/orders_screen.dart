import 'package:artisthub/screens/cart/cart_widget.dart';
import 'package:artisthub/screens/orders/orders_widget.dart';
import 'package:artisthub/widgets/back_widget.dart';
import 'package:artisthub/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../consts/firebase_consts.dart';
import '../../providers/orders_provider.dart';
import '../../services/utils.dart';
import '../../widgets/empty_screen.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = "/OrdersScreen";
  const OrdersScreen ({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
     final Color color = Utils(context).color;
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final ordersList = ordersProvider.getOrders;
    final User? user = authInstance.currentUser;
  return  FutureBuilder(
    future: ordersProvider.fetchOrders(),
    builder: (context, snapshot) {
        return  ordersList.isEmpty || user == null
        
    ?const EmptyScreen(
        title: 'You didnt place any order yet',
        subtitle: 'order something and make me happy :)',
        buttontext:'Shop now',
        imagePath:'assets/images/cart.png',
      )
      : Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
        centerTitle: false,
            title: TextWidget(
            text: 'Your orders (${ordersList.length})',
              color: color,
              textSize: 24.0,
              isTitle: true,
            ),
                  backgroundColor: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.9),
      ),
      body: ListView.separated(
                  itemCount: ordersList.length,
                  itemBuilder: (ctx, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 6),
                      child: ChangeNotifierProvider.value(
                        value: ordersList[index],
                        child: const OrderWidget(),
                  ),
        );
      },
      separatorBuilder: (BuildContext context, int index){
        return Divider(
          color: color,
          thickness: 1,
        );
      },
    ));
    },);
  }
}