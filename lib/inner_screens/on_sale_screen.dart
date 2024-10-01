import 'package:artisthub/widgets/back_widget.dart';
import 'package:artisthub/widgets/empty_products_widget.dart';
import 'package:artisthub/widgets/on_sale_widget.dart';
import 'package:artisthub/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../models/products_model.dart';
import '../providers/products_provider.dart';
import '../services/utils.dart';

class OnSaleScreen extends StatelessWidget {
  static const routeName = "/OnSaleScreen";
  const OnSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
     final ProductProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> productsOnSale = ProductProviders.getOnSaleProducts;
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: TextWidget(
      text: 'Product on sale',
      color: color,
          textSize: 24.0,
      isTitle: true,
      ),
      ),
      body: productsOnSale.isEmpty
      ? const EmptyProdWidget(
        text: 'No Products On Sale Yet!,\nStay Tuned ',
      )
      :GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              childAspectRatio: size.width / (size.height * 0.45),
              children: List.generate(productsOnSale.length, (index) {
                return ChangeNotifierProvider.value(
                  value: productsOnSale[index],
                  child:const OnSaleWidget());
              } ),
            ),
    );
  }
}
