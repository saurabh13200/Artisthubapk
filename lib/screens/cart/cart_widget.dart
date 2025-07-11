import 'package:artisthub/models/cat-model.dart';
import 'package:artisthub/providers/cart_provider.dart';
import 'package:artisthub/providers/products_provider.dart';
import 'package:artisthub/widgets/heart_btn.dart';
import 'package:artisthub/widgets/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../inner_screens/product_details.dart';

import '../../providers/wishlist_provider.dart';
import '../../services/utils.dart';
//this page is widget for cart option
class CartWidget extends StatefulWidget {
  const CartWidget({super.key, required this.q});
  final int q;

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {

    _quantityTextController.text = widget.q.toString();
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
    final productsProvider = Provider.of<ProductsProvider>(context);
    final cartModel = Provider.of<CartModel>(context);
     final getCurrProduct = productsProvider.findProdById(cartModel.productId);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.SalePrice
        : getCurrProduct.price;
            final cartProvider = Provider.of<CartProvider>(context);
                final wishlistProvider = Provider.of<WishlistProvider>(context);
     bool? _isInWishlist = wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);
    return GestureDetector(
      onTap: () {
       Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: cartModel.productId);
      },
      child: Row(children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    height: size.width * 0.25,
                    width: size.width * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: FancyShimmerImage(
                      imageUrl: getCurrProduct.imageUrl,
                      height: size.width * 0.22,
                      width: size.width * 0.22,
                      boxFit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: getCurrProduct.title,
                          color: color,
                          textSize: 14,
                          isTitle: true,
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        SizedBox(
                          width: size.width * 0.3,
                          child: Row(
                            children: [
                              _quantityController(
                                fct: () {
                                  if(_quantityTextController.text == '1'){
                                    return;
                                  }else{
                                     cartProvider.reduceQuantityByOne(
                                      cartModel.productId);
                                     setState(() {
                                    _quantityTextController.text =
                                        (int.parse(_quantityTextController.text) -
                                                1)
                                            .toString();
                                  });
                                  }
                                  
                                },
                                color: Colors.red,
                                icon: CupertinoIcons.minus,
                              ),
                              Flexible(
                                flex: 1,
                                child: TextField(
                                  controller: _quantityTextController,
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                  decoration: const InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(),),),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp('[0-9]'),
                                        ),
                                      ],
                                      onChanged: (v){
                                        setState(() {
                                          if(v.isEmpty){
                                            _quantityTextController.text='1';
                                          }else {
                                            return;
                                          }
                                        });
                                      },
                                ),
                              ),
                              _quantityController(
                                fct: () {
                                  cartProvider.increaseQuantityByOne(
                                      cartModel.productId);
                                  setState(() {
                                   
                                    _quantityTextController.text =
                                        (int.parse(_quantityTextController.text) +
                                                1)
                                            .toString();
                                  });
                  
                                },
                                color: Colors.green,
                                icon: CupertinoIcons.plus,
                              )
                            ],
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Expanded(
                      child: Column(children: [
                          InkWell(
                            onTap: () async {
                        await      cartProvider.removeOneItem(cartId: cartModel.id,
                              productId: cartModel.productId,
                                quantity: cartModel.quantity,
                              );
                            },
                            child: const Icon(
                              CupertinoIcons.cart_badge_minus,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                      HeartBTN(
                      productId: getCurrProduct.id,
                      isInWishlist: _isInWishlist,
                       ),
                          TextWidget(
                            text: '\₹${(usedPrice * int.parse(_quantityTextController.text)).toStringAsFixed(2)}',
                            color: color,
                            textSize: 16,
                            maxLines: 1,
                          )
                      ],),
                    ),
                  ),
                  const SizedBox(width: 5,),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _quantityController({
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
