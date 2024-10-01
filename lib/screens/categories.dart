import 'package:artisthub/services/utils.dart';
import 'package:artisthub/widgets/categories_widget.dart';
import 'package:artisthub/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
   CategoriesScreen ({super.key});
   List <Color> gridColor =[
     Color.fromARGB(255, 5, 247, 94),
     const Color.fromARGB(255, 229, 69, 29),
     Color.fromARGB(255, 79, 222, 238),
     Color.fromARGB(255, 221, 21, 117),
     Color.fromARGB(255, 241, 187, 60),
     Color.fromARGB(255, 44, 241, 199),
     Color.fromARGB(255, 52, 135, 236),
     Color.fromARGB(255, 184, 68, 210),
     Color.fromARGB(255, 245, 11, 109),
     Color.fromARGB(255, 32, 7, 224),
     Color.fromARGB(255, 185, 209, 8),
     
    ];
   // below Is for list for path of images 
  List<Map<String, dynamic>> catInfo =[
    {
      'imgPath':'assets/images/categories/abstract-art.png',
      'catText':'Abstract-Art',
    },
    {
      'imgPath':'assets/images/categories/canvas.png',
      'catText':'Canvas-Art',
    },
    {
      'imgPath':'assets/images/categories/landscape_painting.png',
      'catText':'Landscape-Art',
    },
    {
      'imgPath':'assets/images/categories/modern_art.png',
      'catText':'Modern-Art',
    },
    {
      'imgPath':'assets/images/categories/mud_art.png',
      'catText':'Mud-Art',
    },
    {
      'imgPath':'assets/images/categories/oil_paint.png',
      'catText':'Oil-Painting',
    },
    {
      'imgPath':'assets/images/categories/portrait_painting.png',
      'catText':'Portrait-Painting',
    },
    {
      'imgPath':'assets/images/categories/sculpture.png',
      'catText':'Sculpture-Art',
    },
    {
      'imgPath':'assets/images/categories/spray_painting.png',
      'catText':'Spray-Painting',
    },
    {
      'imgPath':'assets/images/categories/watercolors.png',
      'catText':'Watercolor-Art',
    },
    {
      'imgPath':'assets/images/categories/other_art.png',
      'catText':'Other-Art',
    },

  ];

  @override
  Widget build(BuildContext context) {
    final utils = Utils(context);
    Color color = utils.color;
    return  Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: TextWidget(
            text: 'Categories',
            color: color,
            textSize: 24,
      isTitle: true,
      ),
      ),
      // below code for categories 
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 240/250,
        crossAxisSpacing: 10,//Vertical spacing
        mainAxisSpacing: 10,// horizontal spacing
        children: List.generate(11, (index) {
          return CategoriesWidget(
            catText: catInfo[index]['catText'],
            imgPath: catInfo[index]['imgPath'],
            passedColor: gridColor[index],
          );
        }),
        ),
      )
    );
  }
}