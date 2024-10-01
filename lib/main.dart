import 'package:artisthub/consts/theme_data.dart';
import 'package:artisthub/inner_screens/cat_screen.dart';
import 'package:artisthub/inner_screens/feeds_screen.dart';
import 'package:artisthub/inner_screens/on_sale_screen.dart';
import 'package:artisthub/inner_screens/product_details.dart';
import 'package:artisthub/providers/dark_theme_provider.dart';
import 'package:artisthub/providers/cart_provider.dart';
import 'package:artisthub/providers/orders_provider.dart';
import 'package:artisthub/providers/products_provider.dart';
import 'package:artisthub/providers/viewed_prod_provider.dart';
import 'package:artisthub/providers/wishlist_provider.dart';
import 'package:artisthub/screens/auth/forget_pass.dart';
import 'package:artisthub/screens/auth/login.dart';
import 'package:artisthub/screens/auth/register.dart';
import 'package:artisthub/screens/orders/orders_screen.dart';
import 'package:artisthub/screens/viewed_recently/viewed_recently.dart';
import 'package:artisthub/screens/wishlist/wishlist_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'fetch_screen.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  
   const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
     await themeChangeProvider.darkThemePrefs.getTheme();

  }
@override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
      future: _firebaseInitialization,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
            return const MaterialApp(
              home: Scaffold(
                  body: Center(
                child: CircularProgressIndicator(),
              )),
            );
        }else if(snapshot.hasError){
          return const MaterialApp(debugShowCheckedModeBanner: false,
              home: Scaffold(
                  body: Center(
                child: Text('An error occured'),
              )),
            );
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_){
              return themeChangeProvider;
            }),
            ChangeNotifierProvider(
              create: (_) => ProductsProvider(),
  ),

        ChangeNotifierProvider(
              create: (_) => CartProvider(),
        ),

          ChangeNotifierProvider(
              create: (_) => WishlistProvider(),
        ),

        ChangeNotifierProvider(
              create: (_) => ViewedProdProvider(),
        ),
        ChangeNotifierProvider(
              create: (_) => OrdersProvider(),
        ),
        
          ],
          child: Consumer<DarkThemeProvider>( builder: (context , themeProvider, child) {
              
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: Styles.themeData(themeProvider.getDarkTheme, context),
                home: const FetchScreen(),//BottomBarScreen() ,
                routes: {
                  OnSaleScreen.routeName : (ctx) => const OnSaleScreen(),
                  FeedsScreen.routeName : (ctx) => const FeedsScreen(),
                  ProductDetails.routeName: (ctx) => const ProductDetails(),
                  WishlistScreen.routeName: (ctx) => const WishlistScreen(),
                  OrdersScreen.routeName: (ctx) => const OrdersScreen(),
                  ViewedRecentlyScreen.routeName:(ctx)=> const ViewedRecentlyScreen(),
                  RegisterScreen.routeName:(ctx) => const RegisterScreen(),
                  LoginScreen.routeName:(ctx)=> const LoginScreen(),
                  ForgetPasswordScreen.routeName:(ctx)=> const ForgetPasswordScreen(),
                  CategoryScreen.routeName:(ctx)=> const CategoryScreen(),
                } ,
                );

            }
          ),
        );
      }
    );
  }
}
