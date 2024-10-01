

import 'package:artisthub/providers/viewed_prod_provider.dart';
import 'package:artisthub/screens/viewed_recently/viewed_widget.dart';
import 'package:artisthub/services/global_methods.dart';
import 'package:artisthub/widgets/back_widget.dart';
import 'package:artisthub/widgets/empty_screen.dart';
import 'package:artisthub/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../../providers/wishlist_provider.dart';
import '../../services/utils.dart';

class ViewedRecentlyScreen extends StatefulWidget {
  static const routeName = "/ViewedRecentlyScreen";
  const ViewedRecentlyScreen({super.key});

  @override
  State<ViewedRecentlyScreen> createState() => _ViewedRecentlyScreenState();
}

class _ViewedRecentlyScreenState extends State<ViewedRecentlyScreen> {
  bool check = true;
  @override
  Widget build(BuildContext context) {
    
    final Color color = Utils(context).color;


    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    final viewedProdItemsList =
       viewedProdProvider.getViewedProdlistItems.values.toList().reversed.toList();
    
    
    if(viewedProdItemsList.isEmpty){
      return const EmptyScreen(
        title: 'Your history is Empty',
        subtitle: 'No product has been viewed yet!',
        buttontext:'Shop now',
        imagePath:'assets/images/history.png',
      );

    }else{
       return Scaffold(
      appBar: AppBar(
        actions: [
        IconButton(
          onPressed: (){
              GlobalMethods.warningDialog(
                  title: 'Empty your history?',
                  subtitle: 'Are you sure?',
                  fct: () {},
                  context: context);
        },
         icon: Icon(IconlyBroken.delete,
         color: color,
        ),
        )
      ],
      leading: const BackWidget(),
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: true,
      title: TextWidget(
        text: 'History',
        color: color,
        textSize: 24.0,
      ),
      backgroundColor: 
      Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
      ),
      body: ListView.builder(
        itemCount: viewedProdItemsList.length,
        itemBuilder: (ctx,index){
          return  Padding(padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 6),
          child: ChangeNotifierProvider.value(
            value: viewedProdItemsList[index],
            child: ViewedRecentlyWidget()),
          );
        }),
    );
    }
    
  }
}