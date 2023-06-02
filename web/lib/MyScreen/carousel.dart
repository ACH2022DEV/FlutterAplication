import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:t3_market_place/MyScreen/responsive.dart';

class Carousel extends StatefulWidget {
  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  // int currentIndex = 0;

  List<String> imagesList = [
    '../../android/app/src/assets/images/hotels1.jpg',
       '../../android/app/src/assets/images/muhotel2.jpeg',
    '../../android/app/src/assets/images/muhotel3.jpeg',
    '../../android/app/src/assets/images/muhotel4.jpeg',
    '../../android/app/src/assets/images/myhotel.jpeg', 
    '../../android/app/src/assets/images/myhotel5.jpeg',
     '../../android/app/src/assets/images/myhotel6.jpeg',
     '../../android/app/src/assets/images/myhotel7.jpeg',
     '../../android/app/src/assets/images/myhotel9.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        //  height: double.infinity,
        child: CarouselSlider(
          options: CarouselOptions(
            height: double.infinity,
             viewportFraction: 1.0,
           /* enlargeCenterPage: true,
            autoPlay: true, */
          ),
          items: imagesList.map((item) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(item),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );

    /*  return Scaffold(
  body: Stack(
    children: [
      CarouselSlider(
        options: CarouselOptions(
          height: double.infinity,
          viewportFraction: 1.0,
          enlargeCenterPage: false,
          autoPlay: false,
          initialPage: currentIndex,
          onPageChanged: (index, reason) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
        items: imagesList.map((item) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(item),
                fit: BoxFit.cover,
              ),
            ),
          );
        }).toList(),
      ),
      Positioned(
        bottom: 20.0,
        left: 20.0,
        right: 20.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  if (currentIndex > 0) {
                    currentIndex--;
                  }
                });
              },
              child: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.5),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  if (currentIndex < imagesList.length - 1) {
                    currentIndex++;
                  }
                });
              },
              child: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.5),
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
); */
  }
}
