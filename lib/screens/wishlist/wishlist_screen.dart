
import 'package:artisthub/providers/wishlist_provider.dart';
import 'package:artisthub/screens/wishlist/wishlist_widget.dart';
import 'package:artisthub/widgets/back_widget.dart';
import 'package:artisthub/widgets/empty_screen.dart';
import 'package:artisthub/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';


import '../../services/global_methods.dart';
import '../../services/utils.dart';

class WishlistScreen  extends StatelessWidget {
  static const routeName = "/WishlistScreen";
  const WishlistScreen ({Key? key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
     final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
        final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistItemsList =
       wishlistProvider.getWishlistItems.values.toList().reversed.toList();


    return wishlistItemsList.isEmpty
     ?
    const EmptyScreen(
            imagePath: 'assets/images/wishlist.png',
            title: 'Your Wishlist Is Empty',
            subtitle: 'Explore more and shortlist some items',
            buttontext: 'Add a wish',
          )
    
    
    :Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackWidget(),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: TextWidget(
              text: 'Wishlist (${wishlistItemsList.length})',
              color: color,
              isTitle: true,
              textSize: 22,
            ),

        actions: [
          IconButton(
              onPressed: () {
                 GlobalMethods.warningDialog(
                    title: 'Empty your wishlist?',
                    subtitle: 'Are you sure?',
                    fct: () async {
                      await wishlistProvider.clearOnlineWishlist();
                      wishlistProvider.clearLocalWishlist();},
                    context: context,
                  );
              },
              icon: Icon(
                IconlyBroken.delete,
                color: color,
              ),),

      ]),
      body: MasonryGridView.count(
        itemCount: wishlistItemsList.length,
  crossAxisCount: 2,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                  value: wishlistItemsList[index],
                  child: const WishlistWidget());
              },
            )   
    );
  }
}
