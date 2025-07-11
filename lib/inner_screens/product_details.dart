import 'package:artisthub/providers/products_provider.dart';
import 'package:artisthub/services/utils.dart';
import 'package:artisthub/widgets/heart_btn.dart';
import 'package:artisthub/widgets/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_consts.dart';
import '../models/products_model.dart';
import '../providers/cart_provider.dart';
import '../providers/viewed_prod_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/global_methods.dart';

class ProductDetails extends StatefulWidget {
  static const routeName = '/ProductDetails';

  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
 
  final _quantityTextController = TextEditingController(text: '1');
  @override
  void dispose() {
   
    //Clean up the controller when the widget is disposed.
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;

    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    // er
    final productId = ModalRoute.of(context)!.settings.arguments as String; 
    final productsProvider = Provider.of<ProductsProvider>(context);
    final getCurrProduct = productsProvider.findProdById(productId);
    

     
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.SalePrice
        : getCurrProduct.price;
     double totalPrice = usedPrice * int.parse(_quantityTextController.text);   
     bool? _isInCart = cartProvider.getCartItems.containsKey(getCurrProduct.id);
        
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);

    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
     
    return WillPopScope(
      onWillPop: () async {
       // viewedProdProvider.addProductsToHistory(productId: productId);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            leading: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () =>
                  Navigator.canPop(context) ? Navigator.pop(context) : null,
              child: Icon(
                IconlyLight.arrowLeft2,
                color: color,
                size: 24,
              ),
            ),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),
        body: Column(children: [
          Flexible(
            flex: 2,
            child: FancyShimmerImage(
              imageUrl: getCurrProduct.imageUrl,
              boxFit: BoxFit.scaleDown,
              width: size.width,
            ),
          ),
          Flexible(
            flex: 2, //this will increase the height
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextWidget(
                            text: getCurrProduct.title,
                            color: color,
                            textSize: 25,
                            isTitle: true,
                          ),
                        ),
                         HeartBTN(
                        productId: getCurrProduct.id,
                        isInWishlist: _isInWishlist,
                      ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextWidget(
                          text: '\₹${usedPrice.toStringAsFixed(2)}',
                          color: Colors.green,
                          textSize: 16,
                          isTitle: true,
                        ),
                        TextWidget(
                          text: getCurrProduct.isPiece? 'Piece':'/1-ITEM',
                          color: color,
                          textSize: 14,
                          isTitle: false,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Visibility(
                          visible: getCurrProduct.isOnSale ? true : false,
                          child: Text(
                           '\₹${getCurrProduct.price.toStringAsFixed(2)}', 
                            style: TextStyle(
                                fontSize: 13,
                                color: color,
                                decoration: TextDecoration.lineThrough),
                          ),
                        ),
                        const Spacer(),
                        // free delivery box
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(63, 200, 101, 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: TextWidget(
                            text: 'Free delivery',
                            color: Colors.white,
                            textSize: 16,
                            isTitle: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      quantityControl(
                        fct: () {
                                  if(_quantityTextController.text == '1'){
                                    return;
                                  }else{
                                     setState(() {
                                    _quantityTextController.text =
                                        (int.parse(_quantityTextController.text) -
                                                1)
                                            .toString();
                                  });
                                  }
                                  
                                },
                        icon: CupertinoIcons.minus,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        flex: 1,
                        child: TextField(
                          controller: _quantityTextController,
                          key: const ValueKey('quantity'),
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                          ),
                          textAlign: TextAlign.center,
                          cursorColor: Colors.green,
                          enabled: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          onChanged: (value){
                            setState(() {
                              if(value.isEmpty){
                                _quantityTextController.text='1';
                              }else{}
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      quantityControl(
                        fct:(){
                           setState(() {
                                    _quantityTextController.text =
                                        (int.parse(_quantityTextController.text) +
                                                1)
                                            .toString();
                                  });
                        },
                        icon: CupertinoIcons.plus_square,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  //for description
               //for description
               TextWidget(
                    text: getCurrProduct.description,
                    color: color,
                    textSize: 16,
                    isTitle: true,
                  ),
               //Above code for  description
             const SizedBox(height: 5,),
                  //bottom page total widget
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    padding: 
                    const EdgeInsets.symmetric(vertical: 20,horizontal: 30),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: 'Total',
                              color: color,
                              textSize: 20,
                              isTitle: true,
                            ),
                            const SizedBox(
                             height: 5,
                            ),
                            FittedBox(
                              child: Row(children: [
                                TextWidget(
                                  text: '\₹${totalPrice.toStringAsFixed(2)}/',
                                  color: color,
                                  textSize: 20,
                                  isTitle: true,
                                ),
                                TextWidget(
                                  text: '${_quantityTextController.text}-Item',
                                  color: color,
                                  textSize: 16,
                                  isTitle: false,
                                ),
                                ],
                              ),
                            ),
                          ],
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(child: Material(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap:  _isInCart
                                  ? null
                                  : () async {
                                 // if(_isInCart){
                                 //  return;
                                // }
                                  final User? user =
                                          authInstance.currentUser;
                                     
                                      if (user == null) {
                                        GlobalMethods.errorDialog(
                                            subtitle:
                                                'No user found, please login first',
                                            context: context);
                                        return;
                                      }
                                 await      GlobalMethods.addToCart(
                                        productId: getCurrProduct.id,
                                        quantity: int.parse(_quantityTextController.text),
                                        context: context,);
                                         await cartProvider.fetchCart();
                                      // cartProvider.addProductsToCart(
                                      //     productId: getCurrProduct.id,
                                      //     quantity: int.parse(
                                      //         _quantityTextController.text));
                  },
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextWidget(
                                    text: _isInCart ? 'In cart' : 'Add to cart',
                                color: Colors.white,
                                textSize: 18,)),
                          ),
                        ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget quantityControl({
    required Function fct,
    required IconData icon,
    required Color color,
  }) {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              fct();
            },
            child:  Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }


  
}
