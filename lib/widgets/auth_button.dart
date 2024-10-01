import 'package:artisthub/consts/theme_data.dart';
import 'package:artisthub/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AuthButton extends StatelessWidget {
  const AuthButton(
      {super.key,
      required this.fct,
      required this.buttonText,
      this.primary = Colors.white38,
      });
  final Function fct;
  final String buttonText;
  final Color primary;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: primary,
      ),
        onPressed: (){
        fct();
        //_submitFormOnLogin();
      },
       child: TextWidget(
        text: buttonText,
        textSize: 18,
        color: Colors.white,
       )),
    );
  }
}