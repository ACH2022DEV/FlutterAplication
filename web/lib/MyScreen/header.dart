import 'package:flutter/material.dart';
import 'package:t3_market_place/MyScreen/responsive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'constant.dart';
import 'menu.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Row(
      children: [
        // it  display only on mobile and tab
        //not working

        if (!Responsive.isDesktop(context))
          Builder(
              builder: (context) =>Container(
                margin: EdgeInsets.only(bottom: 7),
                child: IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(Icons.menu,weight: 50,))),),
       //  if (Responsive.isDesktop(context))
    //Icon(Icons.dashboard,weight: 25,), 
        SizedBox(width: 20.sp,),
        if(Responsive.isMobile(context))
        Row(children: [
          
         Text(
          "3T",
          style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 255, 0, 0),shadows: [
      Shadow(
        color: Colors.grey,
        offset: Offset(2, 2),
        blurRadius: 3,
      ),
    ],),
        ),Container(
          margin: EdgeInsets.only(left: 2.sp,right: 2.sp),
                                                              height: 20.h
                                                                  .h, // Adjust the height as needed
                                                              width:
                                                                  3, // Set the width to define the separator line thickness
                                                              color: Color.fromARGB(255, 0, 0, 0), // Set the color of the separator line
                                                            ),
        Text('MarketPlace',
          style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 0, 0, 0),shadows: [
      Shadow(
        color: Colors.grey,
        offset: Offset(2, 2),
        blurRadius: 3,
      ),
    ],),),
    
    
    
    ],),
    if(!Responsive.isMobile(context))
         Image.asset(
                '../../android/app/src/assets/images/3TLOGO.png',
               width: 200,
               height: 22,
               
              ),  
        Spacer(),
        //menu
        if (Responsive.isDesktop(context)) HeaderWebMenu(),

      ],
    );
  }
}
