import 'package:flutter/material.dart';

class ViewedProdModel with ChangeNotifier{
 final String id, productId;


 ViewedProdModel({
    required this.id,
    required this.productId,
   
  });
}