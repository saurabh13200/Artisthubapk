import 'package:artisthub/consts/firebase_consts.dart';
import 'package:artisthub/providers/orders_provider.dart';
import 'package:artisthub/screens/cart/cart_widget.dart';
import 'package:artisthub/widgets/empty_screen.dart';
import 'package:artisthub/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';

class CartScreen extends StatelessWidget {
  const CartScreen ({super.key});

  @override
  Widget build(BuildContext context) {
     final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemsList =
        cartProvider.getCartItems.values.toList().reversed.toList();


    return cartItemsList.isEmpty
        ? const EmptyScreen(
            title: 'Your cart is empty',
            subtitle: 'Add something and make me happy :)',
            buttontext: 'Shop now',
            imagePath: 'assets/images/cart.png',
          )
     : Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: TextWidget(
              text: 'Cart (${cartItemsList.length})',
              color: color,
              isTitle: true,
              textSize: 22,
            ),

        actions: [
          IconButton(
              onPressed: () {
                 GlobalMethods.warningDialog(
                    title: 'Empty your cart?',
                    subtitle: 'Are you sure?',
                    fct: () async {
                   await   cartProvider.clearOnlineCart();
                      cartProvider.clearLocalCart();
                    },
                    context: context,
                  );
              },
              icon: Icon(
                IconlyBroken.delete,
                color: color,
              ),
              ),

      ]),
      
        body: Column(
          
        children: [
                TextWidget(
              text: 'Note:-Cash On Delivery (COD)', color: Colors.red, textSize: 18),
               Center(
                 child: TextWidget(
                             text: 'Note:-Product will be Delivery with in 7 Working days', color: Colors.red, textSize: 16),
               ),
          _checkout(ctx: context),
          Expanded(
            child: ListView.builder(
              itemCount: cartItemsList.length,
              itemBuilder: (ctx,index){
              return ChangeNotifierProvider.value(
                value: cartItemsList[index],
                child: CartWidget(
                  q: cartItemsList[index].quantity ,
                ));
            },),
          ),
        ],
        
      ),
      
    );
    
  }


  Widget _checkout ({required BuildContext ctx}){
    
     final Color color = Utils(ctx).color;
    Size size = Utils(ctx).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(ctx);
    final productsProvider = Provider.of<ProductsProvider>(ctx);
    final ordersProvider = Provider.of<OrdersProvider>(ctx);
    double total = 0.0;
    cartProvider.getCartItems.forEach((key, value){

      final getCurrProduct = productsProvider.findProdById(value.productId);
      total += (getCurrProduct.isOnSale
              ? getCurrProduct.SalePrice
              : getCurrProduct.price) *
          value.quantity;
    });
    return SizedBox(
            width: double.infinity,
      height: size.height * 0.1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(children: [
                Material(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () async {
                      User? user = authInstance.currentUser;
                      final orderId = const Uuid().v4();
                final productsProvider =
                    Provider.of<ProductsProvider>(ctx, listen: false);
               
               cartProvider.getCartItems.forEach((key, value) async {
                   final getCurrProduct = productsProvider.findProdById(
                    value.productId,);

                  try {
                    await FirebaseFirestore.instance
                        .collection('orders')
                        .doc(orderId)
                        .set({
                      'orderId': orderId,
                      'userId': user!.uid,
                      'productId': value.productId,
                      'price': (getCurrProduct.isOnSale
                          ? getCurrProduct.SalePrice
                          : getCurrProduct.price) * 
                          value.quantity,
                      'totalPrice': total,
                      'quantity': value.quantity,
                      'imageUrl': getCurrProduct.imageUrl,
                      'userName': user.displayName,
                     
                      'orderDate': Timestamp.now(),
                    });
                    await cartProvider.clearOnlineCart();
                    cartProvider.clearLocalCart();
                  ordersProvider.fetchOrders();
                    await Fluttertoast.showToast(
                      msg: 'Your order has been placed',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                    );
                  } catch (error) {
                  GlobalMethods.errorDialog(
                      subtitle: error.toString(), context: ctx);
                      }finally{}
                       });
                    },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextWidget(
                          text: 'Order Now',
                          textSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ),
                const Spacer(),
          FittedBox(
            child: TextWidget(
              text: 'Total: \₹${total.toStringAsFixed(2)}',
              color: color,
              textSize: 18,
              isTitle: true,
            ),
          ),
   
    
              ],
              
              ),
              
            ),

          );
          

  }
}