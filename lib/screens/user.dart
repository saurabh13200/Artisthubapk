import 'package:artisthub/consts/firebase_consts.dart';
import 'package:artisthub/screens/auth/forget_pass.dart';
import 'package:artisthub/screens/auth/login.dart';
import 'package:artisthub/screens/loading_manager.dart';
import 'package:artisthub/screens/orders/orders_screen.dart';
import 'package:artisthub/screens/viewed_recently/viewed_recently.dart';
import 'package:artisthub/screens/wishlist/wishlist_screen.dart';
import 'package:artisthub/services/global_methods.dart';
import 'package:artisthub/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';


import '../providers/dark_theme_provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  // for controller
  final TextEditingController _addressTextController = TextEditingController();
  @override
  void dispose() {
    _addressTextController.dispose();
    super.dispose();
  }
String? _email;
String? _name;
String? address;
bool _isLoading = false;
final User? user = authInstance.currentUser;
@override
  void initState() {
    getUserData();
    super.initState();
  }

  
  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    if(user == null){
        setState(() {
      _isLoading = false;
    });
      return;
    }
    try {
      String _uid = user!.uid;

      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
          if(userDoc == null){
            return;
          }else{
            _email = userDoc.get('email');
            _name = userDoc.get('name');
            address = userDoc.get('shipping-address');
            _addressTextController.text = userDoc.get('shipping-address');
          }

    } catch (error) {
        setState(() {
      _isLoading = false;
    });
     GlobalMethods.errorDialog(
            subtitle: '$error', context: context);
    } finally {
        setState(() {
      _isLoading = false;
    });
    }


  }


  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return Scaffold(
        body: LoadingManager(
          isLoading: _isLoading,
          child: Center(
              child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 15,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Hi,',
                    style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: _name == null? 'user' : _name!,
                          style: TextStyle(
                            color: color,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('My name is pressed');
                            }),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextWidget(
                  text: _email == null? 'Email' : _email!,
                  color: color,
                  textSize: 18,
                  isTitle: true,
                ),
        
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  thickness: 2,
                ),
                const SizedBox(
                  height: 20,
                ),
                // below code for user button options
                _listTiles(
                  title: 'Address 2',
                  subtitle: address,
                  icon: IconlyLight.profile,
                  onPressed: () async {
                    await _showAddressDialog();
                  },
                  color: color,
                ),
              
              
                _listTiles(
                  title: 'Orders',
                  icon: IconlyLight.bag,
                  onPressed: () {
                    GlobalMethods.navigateTo(ctx: context, routeName: OrdersScreen.routeName);
                  },
                  color: color,
                ),
                _listTiles(
                  title: 'Wishlist',
                  icon: IconlyLight.heart,
                  onPressed: () {
                    GlobalMethods.navigateTo(ctx: context, routeName: WishlistScreen.routeName);
                  },
                  color: color,
                ),
                _listTiles(
                  title: 'Viewed',
                  icon: IconlyLight.show,
                  onPressed: () {
                    GlobalMethods.navigateTo(ctx: context, routeName: ViewedRecentlyScreen.routeName);
                  },
                  color: color,
                ),
                _listTiles(
                  title: 'Forget password',
                  icon: IconlyLight.unlock,
                  onPressed: () {
        
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ForgetPasswordScreen(),
                          ),
                        );
                  },
                  color: color,
                ),
                SwitchListTile(
                  title: TextWidget(
                    text: themeState.getDarkTheme ? 'Dark mode' : 'Light mode',
                    color: color,
                    textSize: 18,
                    isTitle: true, // this ic commented
                  ),
                  secondary: Icon(themeState.getDarkTheme
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined),
                  onChanged: (bool value) {
                    setState(() {
                      themeState.setDarkTheme = value;
                    });
                  },
                  value: themeState.getDarkTheme,
                ),
                _listTiles(
                  title: user == null? 'Login' : 'Logout',
                  icon: user == null? IconlyLight.login :IconlyLight.logout,
                  onPressed: () {
                    if(user == null){
                          Navigator.of(context).push(
                            MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          );
                          return;
                        }
                    GlobalMethods.warningDialog(
                      title: 'Sign out',
                      subtitle: 'Do you wanna sign out?',
                      fct: () async {
                        
                       await authInstance.signOut();
                       Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      context: context,
                    );
                  },
                  color: color,
                ),
            TextWidget(
              text: 'Note:- For selling your art \n contact on - xyz@gmail.com', color: Colors.red, textSize: 18),
              ],
              
            ),
            //
            
          ),
              ),
            ),
        ));
  }


  // this function for address buttion in button options
Future<void > _showAddressDialog()async{
  await showDialog(
        context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Update'),
                          content: TextField(
                           // onChanged: (value) {
                             // print('_addressTextController.text;${_addressTextController.text}');
                            //},
                            controller: _addressTextController,
                            maxLines: 5,
                            decoration:
                                const InputDecoration(hintText: 'Your address'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                String _uid = user!.uid;
                                try{
                                  await FirebaseFirestore.instance.collection('users').doc(_uid).update({
                                    'shipping-address': _addressTextController.text,
                                  });
                                  Navigator.pop(context);
                                  setState(() {
                                    address = _addressTextController.text;
                                  });
                                }catch (err){
                    GlobalMethods.errorDialog(
                      subtitle: err.toString(),
                      context: context,
                    );
                                }

                              },
                              child: const Text('Update'),
                            ),
                          ],
                        );
                      });
}
  Widget _listTiles({
    required String title,
    String? subtitle,
    required IconData icon,
    required Function onPressed,
    required Color color,
  }) {
    return ListTile(
      title: TextWidget(
        text: title,
        color: color,
        textSize: 22,
        isTitle: true,
      ),
      subtitle: TextWidget(
        text: subtitle == null ? "" : subtitle,
        color: color,
        textSize: 18,
      ),
      leading: Icon(icon),
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: () {
        onPressed();
      },
    );
  }
}
