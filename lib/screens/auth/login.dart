import 'package:artisthub/consts/contss.dart';
import 'package:artisthub/screens/auth/forget_pass.dart';
import 'package:artisthub/screens/auth/register.dart';
import 'package:artisthub/screens/btm_bar.dart';
import 'package:artisthub/screens/loading_manager.dart';
import 'package:artisthub/services/global_methods.dart';
import 'package:artisthub/widgets/auth_button.dart';
import 'package:artisthub/widgets/google_button.dart';
import 'package:artisthub/widgets/text_widget.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../consts/firebase_consts.dart';
import '../../fetch_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _obscureText = true;
  @override
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }


  bool _isLoading = false;

  void _submitFormOnLogin() async {
    final _isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });
    if (_isValid) {
      _formKey.currentState!.save();
 
         
      try{
         await    authInstance.signInWithEmailAndPassword(
          email: _emailTextController.text.toLowerCase().trim(),
            password: _passTextController.text.trim());
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const FetchScreen(),//BottomBarScreen(),
        ),);

             print('Succefully logged in');
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
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Stack(children: [
          Swiper(
            duration: 800,
            autoplayDelay: 8000,
            itemBuilder: (BuildContext context, int index) {
              return Image.asset(
                Constss.authImagePaths[index],
                fit: BoxFit.cover,
              );
            },
            autoplay: true,
            itemCount: Constss.authImagePaths.length,
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 120,
                  ),
                  TextWidget(
                    text: 'Welcome Back',
                    color: Colors.white,
                    textSize: 30,
                    isTitle: true,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextWidget(
                    text: 'Sign in to continue',
                    color: Colors.white,
                    textSize: 18,
                    isTitle: false,
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_passFocusNode),
                            controller: _emailTextController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'Please enter a valid email address';
                              } else {
                                return null;
                              }
                            },
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Email',
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
                            height: 12,
                          ),
                          //for password Box
                          TextFormField(
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              _submitFormOnLogin();
                            },
                            controller: _passTextController,
                            focusNode: _passFocusNode,
                            obscureText: _obscureText,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 7) {
                                return 'Please enter a valid password';
                              } else {
                                return null;
                              }
                            },
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                  )),
                              hintText: 'password',
                              hintStyle: const TextStyle(color: Colors.white),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                        onPressed: () {
                          GlobalMethods.navigateTo(ctx: context, routeName: ForgetPasswordScreen.routeName);
                        },
                        child: const Text(
                          'Forget password',
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.lightBlue,
                              fontSize: 18,
                              decoration: TextDecoration.underline,
                              fontStyle: FontStyle.italic),
                        )),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  AuthButton(fct: (){
                    _submitFormOnLogin();
                  }, buttonText: 'Login',),
                  const SizedBox(
                    height: 20,
                  ),
                  GoogleButton(),
                  const SizedBox(height: 20,),
                  // for OR written on screen
                  Row(children: [
                    const Expanded(child: Divider(
                      color: Colors.white,
                      thickness: 2,
                        ),
                      ),
                      const SizedBox(width: 5,),
                      TextWidget(text: 'OR', color: Colors.white, textSize: 18,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Expanded(child: Divider(
                      color: Colors.white,
                      thickness: 2,
                        ),
                      ),
      
                    ],
                  ),
                  const SizedBox(
                        height: 10,
                      ),
                  AuthButton(
                    fct: () {
                   Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const FetchScreen(),
                          ),
                        );
                },
                 buttonText: 'Continue as a guest',
                 primary: Colors.blueGrey,
                 ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(text:  TextSpan(text: 'don\'t have an account?',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    children: [
                      TextSpan(text: '  Sign up',
                      style:  const TextStyle(color: Colors.lightBlue, fontSize: 18,fontWeight: FontWeight.w600),
                      recognizer: TapGestureRecognizer()
                      ..onTap = (){
      
                          // for givining path
                          GlobalMethods.navigateTo(ctx: context, routeName: RegisterScreen.routeName);
                      }
                        )
                    ]
                  ))
      
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
