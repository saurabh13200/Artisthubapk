

import 'package:artisthub/services/utils.dart';
import 'package:flutter/material.dart';

class EmptyProdWidget extends StatelessWidget {
  const EmptyProdWidget({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    Color color = Utils(context).color;
    return Center( child: 
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Image.asset('assets/images/box.png',),
            ),
            Text(
                  text,
              textAlign: TextAlign.center,
            style: TextStyle(color: color,fontSize: 28,fontWeight: FontWeight.w800),),
          ],
        ),
      ),
    
      );
  }
}