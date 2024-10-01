import 'package:flutter/cupertino.dart';

class ProductModel with ChangeNotifier{

  final String id, title, imageUrl, productCategoryName, description;
  final double price, SalePrice;
  final bool isOnSale, isPiece;
  

  ProductModel(
      {required this.id,
      required this.title,
      required this.imageUrl,
      required this.productCategoryName,
      required this.description,
      required this.price,
      required this.SalePrice,
      required this.isOnSale,
      required this.isPiece});
}