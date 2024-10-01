

import 'package:artisthub/consts/firebase_consts.dart';
import 'package:artisthub/screens/loading_manager.dart';
import 'package:artisthub/services/global_methods.dart';
import 'package:artisthub/services/utils.dart';
import 'package:artisthub/widgets/auth_button.dart';
import 'package:artisthub/widgets/back_widget.dart';
import 'package:artisthub/widgets/text_widget.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../consts/contss.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const routeName = '/ForgetPasswordScreen';
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _emailTextController = TextEditingController();
  @override
  void dispose() {
    _emailTextController.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  void _forgetPassFCT() async {
    if (_emailTextController.text.isEmpty ||
        !_emailTextController.text.contains("@")) {
      GlobalMethods.errorDialog(
          subtitle: 'Please enter a correct email adress', context: context);
    }else{
      setState(() {
        _isLoading = true;
      });
        try{
              await   authInstance.sendPasswordResetEmail(
          email: _emailTextController.text.toLowerCase());
          Fluttertoast.showToast(
        msg: "An email has been sent to your email address",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey.shade500,
        textColor: Colors.white,
        fontSize: 16.0
    );
        } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subtitle: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
    });
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
        setState(() {
          _isLoading = false;
    });
      } finally {
        setState(() {
          _isLoading = false;
    });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Stack(
          children: [
            Swiper(
              itemBuilder:(BuildContext context, int index){
                return Image.asset(
                  Constss.authImagePaths[index],
                  fit: BoxFit.cover,
      
                );
              },
              autoplay: true,
              itemCount: Constss.authImagePaths.length,
            ),
            Container(
              color: Colors.black.withOpacity(0.6),
            ),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               SizedBox(
                  height: size.height * 0.1,
                ),
               const BackWidget(),
                const SizedBox(height: 20,),
                  TextWidget(
                      text: 'Forget password',
                       color: Colors.white, 
                       textSize: 30
                       ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _emailTextController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                              hintText: 'Email address',
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AuthButton(fct: (){
                    _forgetPassFCT();
                  }, buttonText: 'Reset now'),
      
              ],
            ),
            )
          ],
        ),
      ),
    );
  }
}