import 'package:artisthub/inner_screens/product_details.dart';
import 'package:artisthub/models/wishlist_model.dart';
import 'package:artisthub/providers/wishlist_provider.dart';
import 'package:artisthub/services/global_methods.dart';

import 'package:artisthub/widgets/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

import 'package:flutter/material.dart';

import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../../providers/products_provider.dart';
import '../../services/utils.dart';
import '../../widgets/heart_btn.dart';

class WishlistWidget extends StatelessWidget {
  const WishlistWidget({super.key});

  @override
  Widget build(BuildContext context) {
     final productsProvider = Provider.of<ProductsProvider>(context);
   
    final wishlistModel = Provider.of<WishlistModel>(context);
     final wishlistProvider = Provider.of<WishlistProvider>(context);
    final getCurrProduct =
        productsProvider.findProdById(wishlistModel.productId);
        double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.SalePrice
        : getCurrProduct.price;
        bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;


    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: (){
          Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: wishlistModel.productId);
    
        },
        child: Container(
          height: size.height*0.20,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(0.8),
            border: Border.all(color: color,width: 1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  // width: size.width*0.2,
                  height: size.width*0.25,
                  child:  FancyShimmerImage(
                          imageUrl:getCurrProduct.imageUrl,
                          boxFit: BoxFit.fill,
                           ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  
                  children: [
                  Flexible(
                    child: Row(
                      children: [
                          IconButton(
                            onPressed: () {
                              // cart code for in chart
                            },
                            icon: Icon(
                              IconlyLight.bag2,
                              color: color,
                            ),
                          ),
                           HeartBTN(
                        productId: getCurrProduct.id,
                        isInWishlist: _isInWishlist,
                      )
                    ],
                    ),
                  ),
                    TextWidget(
                      text: getCurrProduct.title,
                      color: color,
                      textSize: 20,
                      maxLines: 1,
                      isTitle: true,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextWidget(
                      text: '\₹${usedPrice.toStringAsFixed(2)}',
                      color: color,
                      textSize: 16,
                      maxLines: 1,
                      isTitle: true,
                    ),
                  
                  ],
                ),
              ),
            ],
          ),
    
        ),
      ),
    );
  }
}