// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'constant.dart';
import 'header.dart';

class HeaderContainer extends StatelessWidget {
  const HeaderContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Container(
      width: MediaQuery.of(context).size.width,
 //   color: Color.fromARGB(255, 2, 111, 170),
  decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(1),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 164, 164, 164),
                    offset: Offset(0, 1), // Décalage vertical de l'ombre
                    blurRadius: 2, // Rayon de flou de l'ombre
                  ),
                ],
              ),
   
      padding: EdgeInsets.all(4.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            constraints: BoxConstraints(maxWidth: kMaxWidth),
            child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Header(),
                SizedBox(
                  height: 5,
                ),
                //   Responsive.isDesktop(context) ? BannerSection() : MobBanner(),
              ],
            ),
          ),
        ],
      ),
    ); 
  
  }
}
