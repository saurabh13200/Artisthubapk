import 'dart:ui';

import 'package:artisthub/inner_screens/product_details.dart';
import 'package:artisthub/models/viewed_model.dart';
import 'package:artisthub/services/global_methods.dart';
import 'package:artisthub/widgets/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';


import '../../consts/firebase_consts.dart';
import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../services/utils.dart';

class ViewedRecentlyWidget extends StatefulWidget {
  const ViewedRecentlyWidget({super.key});

  @override
  State<ViewedRecentlyWidget> createState() => _ViewedRecentlyWidgetState();
}

class _ViewedRecentlyWidgetState extends State<ViewedRecentlyWidget> {
  
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
     final viewedProdModel = Provider.of<ViewedProdModel>(context);
    
    final getCurrProduct =
        productsProvider.findProdById(viewedProdModel.productId);
        double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.SalePrice
        : getCurrProduct.price;
         final cartProvider = Provider.of<CartProvider>(context);
      bool? _isInCart = cartProvider.getCartItems.containsKey(getCurrProduct.id);


    Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
         // GlobalMethods.navigateTo(
          //    ctx: context, routeName: ProductDetails.routeName);
        },
        child: Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FancyShimmerImage(
                        imageUrl:getCurrProduct.imageUrl,
                        boxFit: BoxFit.fill,
                        height: size.width * 0.27,
                        width: size.width * 0.25,
                         ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  children: [
                    TextWidget(text: getCurrProduct.title, 
                    color: color,
                     textSize: 24,
                     isTitle: true,
                     maxLines: 1,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextWidget(
                      text: '\₹${usedPrice.toStringAsFixed(2)}',
                      color: color,
                      textSize: 20,
                      isTitle: false,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.green,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _isInCart
                                    ? null
                                    : () async {
                                        final User? user =
                                          authInstance.currentUser;
                                     
                                      if (user == null) {
                                        GlobalMethods.errorDialog(
                                            subtitle:
                                                'No user found, please login first',
                                            context: context);
                                        return;
                                      }
                                   await     GlobalMethods.addToCart(
                                          productId: getCurrProduct.id,
                                          quantity: 1,
                                          context: context);
                                          await cartProvider.fetchCart();
                                        // cartProvider.addProductsToCart(
                                        //   productId: getCurrProduct.id,
                                        //   quantity: 1,
                                        // );
                                      },
                    child:  Padding(
                      padding: const EdgeInsets.all(8.0),
                    child: Icon(
                         _isInCart ? Icons.check : IconlyBold.plus,
                      color: Colors.white,
                      size: 20,
                    ),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}