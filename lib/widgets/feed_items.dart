import 'package:artisthub/inner_screens/product_details.dart';
import 'package:artisthub/models/products_model.dart';
import 'package:artisthub/providers/cart_provider.dart';


import 'package:artisthub/widgets/heart_btn.dart';
import 'package:artisthub/widgets/price_widget.dart';
import 'package:artisthub/widgets/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


import '../consts/firebase_consts.dart';
import '../providers/viewed_prod_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';

class FeedsWidget extends StatefulWidget {
  const FeedsWidget({super.key,});


  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text='1';
    super.initState();
  }
  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
     final productModel = Provider.of<ProductModel>(context);
     final cartProvider = Provider.of<CartProvider>(context);
     bool? _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
     final wishlistProvider = Provider.of<WishlistProvider>(context);
     bool? _isInWishlist = wishlistProvider.getWishlistItems.containsKey(productModel.id);

final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: (){
            viewedProdProvider.addProductsToHistory(productId: productModel.id);
            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: productModel.id);
           // GlobalMethods.navigateTo(
             // ctx: context, routeName: ProductDetails.routeName);
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
            FancyShimmerImage(
                      imageUrl:productModel.imageUrl,
                      height: size.width * 0.21,
                      width: size.width * 0.2,
                      boxFit: BoxFit.fill,
                       ),
          Padding(
             padding: const EdgeInsets.symmetric(horizontal: 10),
                        
               child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: TextWidget(
                      text: productModel.title,
                      color: color,
                      maxLines: 1,
                      textSize: 12,
                      isTitle: true,
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: HeartBTN(
                      productId: productModel.id,
                      isInWishlist: _isInWishlist,
                    )),
                ],
              ),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                
                children: [
                  Flexible(
                    flex: 2,
                    child: PriceWidget(
                      salePrice: productModel.SalePrice,
                      price: productModel.price,
                      textPrice: _quantityTextController.text,
                      isOnSale: productModel.isOnSale,
                    ),
                  ),
                  const SizedBox(width: 8,),
                  Flexible(
                    flex: 1,
                    child: Row(
                      children: [
                        FittedBox(
                          child: TextWidget(
                            text: productModel.isPiece?'Piece': 'ITEM',
                            color: color,
                            textSize: 12,
                            isTitle: true,
                          ),
                        ),
                        const SizedBox(width: 5,),
                    
                    //for enter number in Item in product option
                       Flexible(
                        flex: 2,
                          child: TextFormField(
                          controller: _quantityTextController,
                          key: const ValueKey('10'),
                          style: TextStyle(color: color,fontSize: 10),
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          enabled: true,
                          onChanged: (valueee){
                            setState(() {
                              
                            });
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9.]'),),
                          ],
                        )),
                        //above code for  number in Item in product option
                    ],
                   ),
                  )
                ],
              ),
             ),
             //below code for add to cart optin in product widgets
             const Spacer(),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: _isInCart
                    ? null
                    : () async {
                 // if(_isInCart){
                  //  return;
                 // }
                   final User? user = authInstance.currentUser;

                        if (user == null) {
                          GlobalMethods.errorDialog(
                              subtitle: 'No user found, please login first',
                              context: context);
                          return;
                        }
                        await     GlobalMethods.addToCart(
                                          productId: productModel.id,
                                          quantity: int.parse(_quantityTextController.text),
                                          context: context);
                                          await cartProvider.fetchCart();
                  // cartProvider.addProductsToCart(
                  //     productId: productModel.id,
                  //     quantity: );
                },
                child: TextWidget(
                text: _isInCart ? 'In cart' :'Add to cart',
                maxLines: 1,
                color: color,
                textSize: 20,
                ),
                style: ButtonStyle(
                  backgroundColor:
                   MaterialStateProperty.all(Theme.of(context).cardColor),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                    ),
                    ),
                )),
                ),
            )
          ]),
        ),
      ),
    );
  }
}