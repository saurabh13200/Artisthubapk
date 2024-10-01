import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TextWidget extends StatelessWidget {
   TextWidget({ Key? key, required this.text, required this.color, required this.textSize, this.isTitle =false,this.maxLines = 10, });
final String text;
final Color color;
final double textSize;
bool isTitle;
int maxLines = 10;

  @override
  Widget build(BuildContext context) {
    return Text(
                text,
                maxLines: maxLines,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color:color,
                  fontSize: textSize,
                  fontWeight:isTitle? FontWeight.bold:FontWeight.normal),
              );
    
  }
}