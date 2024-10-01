import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import '../models/products_model.dart';

class ProductsProvider with ChangeNotifier{
   static List<ProductModel> _productsList = [];
  List<ProductModel> get getProducts  {
    return _productsList;
  }

List<ProductModel> get getOnSaleProducts{
  return _productsList.where((element) => element.isOnSale).toList();
}

Future<void> fetchProducts( ) async {
 
   await FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot productSnapshot) {
          _productsList = [];
        //  _productsList.clear();
    productSnapshot.docs.forEach((element) {
        _productsList.insert(
            0,
            ProductModel(
                id: element.get('id'),
                title: element.get('title'),
                imageUrl: element.get('imageUrl'),
                productCategoryName: element.get('productCategoryName'),
                description: element.get('Description'),
              price: double.parse(
                element.get('price'),
              ), 
              SalePrice: element.get('salePrice'),
              
                isOnSale: element.get('isOnSale'),
                isPiece: element.get('isPiece'),
                ));
      });  
    });
    notifyListeners();
}
  
  ProductModel findProdById( String productsId){
    return _productsList.firstWhere((element) => element.id == productsId);

  }

List<ProductModel> findByCategory(String categoryName){
    List<ProductModel> _categoryList = _productsList
        .where((element) => element.productCategoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();

        return _categoryList;
}  
//for search
List<ProductModel> searchQuery(String searchText){
    List<ProductModel> _searchList = _productsList
        .where((element) => element.title
            .toLowerCase()
            .contains(
                searchText.toLowerCase(),
              ),
        )
        .toList();

        return _searchList;
}  

  //   static final List<ProductModel> _productsList = [
  //   ProductModel(
  //       id: '1',
  //       title: 'Lady canvas-painting',
  //       imageUrl: 'https://i.ibb.co/GVGxdvF/IMG-20230305-WA0014.jpg',
  //       productCategoryName: 'Canvas-Art',
  //       description: 'this is canvas paiting with 22 height,22 width and 10 kg weight',
  //       price: 12000,
  //       SalePrice: 10000,
  //       isOnSale: false,
  //       isPiece: false),
  //   ProductModel(
  //       id: '2',
  //       title: 'River-Landscape',
  //       imageUrl: 'https://i.ibb.co/Pj10vq5/River-Landscape.jpg',
  //       productCategoryName: 'Landscape-Art',
  //       description: 'this is Landscape-Art paiting with 30 height,30 width and 10 kg weight',
  //       price: 8000,
  //       SalePrice: 7000,
  //       isOnSale: false,
  //       isPiece: false),
  //   ProductModel(
  //       id: '3',
  //       title: 'Step-by-Step-canvas-painting',
  //       imageUrl: 'https://i.ibb.co/Hxj3WkQ/Step-by-Step.jpg',
  //       productCategoryName: 'Canvas-Art',
  //       description: 'this is canvas paiting with 27 height,23 width and 10 kg weight',
  //       price: 5000,
  //       SalePrice: 8000,
  //       isOnSale: false,
  //       isPiece: false),   
  //   ProductModel(
  //       id: '4',
  //       title: 'Kachchhi-Traditional-Mud-Painting',
  //       imageUrl: 'https://i.ibb.co/kgFRTjb/Kachchhi-Traditional-Mud-Painting.jpg',
  //       productCategoryName: 'Mud-Art',
  //       description: 'this is Mud-Art with 25 height,15 width and 5 kg weight',
  //       price: 5000,
  //       SalePrice: 5000,
  //       isOnSale: false,
  //       isPiece: false), 
  //   ProductModel(
  //       id: '5',
  //       title: 'Fluorite-Oil-Painting',
  //       imageUrl: 'https://i.ibb.co/GtfGg7X/Fluorite.jpg',
  //       productCategoryName: 'Oil-Painting',
  //       description: 'this is Mud-Art with 50 height,50 width and 7 kg weight',
  //       price: 15000,
  //       SalePrice: 12000,
  //       isOnSale: false,
  //       isPiece: false), 
  //      ProductModel(
  //       id: '6',
  //       title: 'Anime-Sculpture-Art',
  //       imageUrl: 'https://i.ibb.co/LSy0F9n/Anime-Sculptor.jpg',
  //       productCategoryName: 'Sculpture-Art',
  //       description: 'this is Sculpture-Art with 50 height,50 width and 10 kg weight',
  //       price: 8000,
  //       SalePrice: 7000,
  //       isOnSale: true,
  //       isPiece: true),   

  // ];
}