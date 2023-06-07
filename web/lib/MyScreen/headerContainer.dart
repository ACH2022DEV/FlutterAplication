// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:t3_market_place/MyScreen/responsive.dart';

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
        //  color:Responsive.isDesktop(context)? Color.fromARGB(255, 195, 35, 35):Responsive.isTablet(context)?Color.fromARGB(255, 195, 35, 35):Colors.white,
       // color: Color.fromARGB(255, 219, 219, 219),
         color:  Color.fromARGB(255, 204, 35, 35),
        borderRadius: BorderRadius.circular(1),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 179, 179, 179),
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
