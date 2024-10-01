
import 'package:artisthub/models/viewed_model.dart';
import 'package:artisthub/models/wishlist_model.dart';
import 'package:flutter/material.dart';

class ViewedProdProvider with ChangeNotifier{
  Map<String, ViewedProdModel> _viewedProdlistItems = {};

  Map<String, ViewedProdModel> get getViewedProdlistItems{
    return _viewedProdlistItems ;
  }

 void addProductsToHistory({required String productId}){
 
       _viewedProdlistItems.putIfAbsent(
          productId,
          () => ViewedProdModel(
              id: DateTime.now().toString(), productId: productId));
  
     notifyListeners();
 }


void clearHistory (){
  _viewedProdlistItems.clear();
  notifyListeners();

}

  
  
}