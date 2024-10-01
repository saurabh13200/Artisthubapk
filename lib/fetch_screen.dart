import 'package:artisthub/consts/firebase_consts.dart';
import 'package:artisthub/providers/cart_provider.dart';
import 'package:artisthub/providers/orders_provider.dart';
import 'package:artisthub/providers/products_provider.dart';
import 'package:artisthub/providers/wishlist_provider.dart';
import 'package:artisthub/screens/btm_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'consts/contss.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({super.key});

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  List<String> images = Constss.loadingImage;
   @override
  void initState()   {   
    images.shuffle();
    Future.delayed(const Duration(microseconds: 5),() async {
    final productsProvider =
     Provider.of<ProductsProvider>(context, listen: false);
     final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final wishlistProvider =
          Provider.of<WishlistProvider>(context, listen: false);

          
        final orderProvider =
          Provider.of<OrdersProvider>(context, listen: false);

          
     final User? user = authInstance.currentUser;
     if(user == null){
      await productsProvider.fetchProducts();
      cartProvider.clearLocalCart();
      wishlistProvider.clearLocalWishlist();
      orderProvider.clearLocalOrders();
     
     } else{
        await productsProvider.fetchProducts();
        await cartProvider.fetchCart();
        await wishlistProvider.fetchWishlist();
     }
 
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => const BottomBarScreen(),
      ));
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            images[0],
            fit: BoxFit.cover,
            height: double.infinity,
          ),
          Container(color: Colors.black.withOpacity(0.7),),
          const Center(
            child: SpinKitFadingFour(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}