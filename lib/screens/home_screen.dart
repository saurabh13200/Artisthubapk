import 'package:artisthub/consts/contss.dart';
import 'package:artisthub/inner_screens/feeds_screen.dart';
import 'package:artisthub/inner_screens/on_sale_screen.dart';
import 'package:artisthub/providers/dark_theme_provider.dart';
import 'package:artisthub/services/global_methods.dart';
import 'package:artisthub/services/utils.dart';
import 'package:artisthub/widgets/text_widget.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';


import '../models/products_model.dart';
import '../providers/products_provider.dart';
import '../widgets/feed_items.dart';
import '../widgets/on_sale_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final themeState = utils.getTheme;
    final Color color = Utils(context).color;
    Size size = utils.getScreenSize;
    final ProductProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = ProductProviders.getProducts;
    List<ProductModel>productsOnSale = ProductProviders.getOnSaleProducts;
    return Scaffold(
      // appbar add custom
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(
          text: 'ArtistHub',
          color: color,
          textSize: 24,
          isTitle: true,
        ),
      ),
      // below code for banner
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.33,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    Constss.BannerImage[index],
                    fit: BoxFit.fill,
                  );
                },
                autoplay: true,
                itemCount: Constss.BannerImage.length, // for length of banner
                pagination: const SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: DotSwiperPaginationBuilder(
                        color: Colors.white,
                        activeColor: Color.fromARGB(255, 243, 23, 8))),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            // below code for view button
            TextButton(
              onPressed: () {
                GlobalMethods.navigateTo(
                  ctx: context, routeName: OnSaleScreen.routeName);
              },
              child: TextWidget(
                text: 'View all',
                maxLines: 1,
                color: Colors.blue,
                textSize: 20,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            // below code for call sale widget
            Row(
              children: [
                RotatedBox( //this for to rotate OnSale widget
                  quarterTurns: -1,
                  child: Row(
                    children: [
                      TextWidget(
                        text: 'On Sale'.toUpperCase(),
                        color: Colors.red,
                        textSize: 20,
                        isTitle: true,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        IconlyLight.discount,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8,),
                Flexible(
                  child: SizedBox(
                    height: size.height * 0.24,
                    child: ListView.builder(
                        itemCount: productsOnSale.length < 10
                            ? productsOnSale.length
                            : 10,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) {
                          return ChangeNotifierProvider.value(
                              value: productsOnSale[index],
                              child: const OnSaleWidget());
                        }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: 'Our products',
                    color: color,
                    textSize: 22,
                    isTitle: true,
                  ),
                  
                  TextButton(
                onPressed: () {
                  GlobalMethods.navigateTo(
                  ctx: context, routeName: FeedsScreen.routeName);
                },
                child: TextWidget(
                  text: 'Browse all',
                  maxLines: 1,
                  color: Colors.blue,
                  textSize: 20,
                ),
              ),
                ],
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              childAspectRatio: size.width / (size.height * 0.61),
              children: List.generate(
                allProducts.length < 4
                ?  allProducts.length 
                : 4, (index) {
                return   ChangeNotifierProvider.value(
                  value: allProducts[index],
                  child: const FeedsWidget(),
                  );
              } ),
            )
          ],
        ),
      ),
    );
  }
}
