import 'package:artisthub/inner_screens/cat_screen.dart';
import 'package:artisthub/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/dark_theme_provider.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget(
      {super.key,
      required this.catText,
      required this.imgPath,
      required this.passedColor});
final String catText, imgPath;
final Color passedColor;
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    double _screenWidth = MediaQuery.of(context).size.width;
    final Color color = themeState.getDarkTheme? Colors.white :Colors.black;
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, CategoryScreen.routeName,
        arguments: catText);
      },
      child: Container(
        decoration: BoxDecoration(
          color: passedColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: passedColor.withOpacity(0.7),
            width: 2 ),     
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: _screenWidth * 0.3,
              width: _screenWidth * 0.3,
              decoration:  BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    imgPath,
                  ),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          TextWidget(
          text: catText,
           color: color, 
           textSize: 20,
           isTitle: true,
           ),
        ]),
      ),
    );
  }
}