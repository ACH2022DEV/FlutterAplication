import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3_market_place/MyScreen/About.dart';
import 'package:t3_market_place/MyScreen/responsive.dart';
import 'package:t3_market_place/MyScreen/hotelsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import 'MyScreen/MesFavouris.dart';
import 'MyScreen/ResponsiveHotelView.dart';
import 'MyScreen/SellerList.dart';
import 'MyScreen/boutiques.dart';
import 'MyScreen/carousel.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:url_launcher/url_launcher.dart';

import 'MyScreen/MoteurRenMobile.dart';

import 'MyScreen/header.dart';
import 'MyScreen/headerContainer.dart';
import 'MyScreen/menu.dart';
import 'MyScreen/rechercheessai.dart';
import 'MyScreen/MoteurRenWeb.dart';
import 'models/ApiHotels&Sellers.dart';
//import 'package:mapbox_gl_dart/mapbox_gl_dart.dart';

// import 'MyScreen/test.dart';
/* import 'dart:js' as js;
import 'dart:html'; */
void main() async {
  runApp(const MyApp());
  //final response = await fetchPosts();

  // print( );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  /*  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
} */

  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          initialRoute: '/home',
          routes: {
            '/home': (context) => const Home(),
            '/Favoris': (context) => Favouris(
                  Mesproducts: Mesproducts,
                ),
            /*  '/search': (context) => SearchFiltrage(
                  //products:Mesproducts
                  ),// Route vers votre nouvelle page */
            '/Hotels': (context) => HotelsPage(),
            '/Boutiques': (context) =>
                MyBoutique(), // Route vers votre nouvelle page
          },
          debugShowCheckedModeBanner: false,
          title: '3t MarketPlace',
          // You can use the library anywhere in the app even in theme
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          home: child,
        );
      },
      child: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

List<Hotels> Mesproducts = [];

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    _loadProductsFromSharedPreferences();
  }

  bool showContainer = false;
  int counter = 0;
  ScrollController _scrollController = ScrollController();

  Future<void> _loadProductsFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> productsJsonList = prefs.getStringList('products') ?? [];
    if (productsJsonList.isNotEmpty) {
      setState(() {
        Mesproducts = productsJsonList
            .map((productJson) => Hotels.fromJson(json.decode(productJson)))
            .toList();
        print('this is my data of hotels in session $Mesproducts');
      });
    }
    /*    setState(() {
      loading2 = false;
    });
 */
  }

  /* @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('My App'),
          actions: [
         //   Header(),
             // Votre widget header() existant
          ],
        ),
        body: PaginationExample(),
      ),
    );
  }
} */

  /*  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('My App'),
        ),
        body: ListView(
          children: [
            Header(), // Votre widget header() existant
          
              PaginationExample(), // Le widget PaginationExample
           
          ],
        ),
      ),
    );
  }
} */
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: !Responsive.isDesktop(context)
          ? Color.fromARGB(255, 255, 255, 255)
          : null,
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 255, 255, 255),
              ],
            ),
          ),
          child: ListView(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              DrawerHeader(
                  decoration: BoxDecoration(
                    //color: Color.fromRGBO(199, 0, 0, 1),
                    /*  gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 255, 148, 148),
                Color.fromARGB(255, 255, 255, 255),
              ],
            ), */
                     image: DecorationImage(
      image: AssetImage('images/imagesrr.jpg',),
      fit: BoxFit.cover,
    ), 
                  ),
                  child: Container(
                    //color: Colors.black,
                    margin: EdgeInsets.only(top: 40),
                    width: double.infinity,

                    child: Center(
                        child: Center(
                            child: Row(children: [
                              Container(
  padding: EdgeInsets.all(3.0),
  decoration: BoxDecoration(
   
  ),
  child: Column(
    children: [
      Text(
        'Hello,To 3tMarketplace !',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),
      ),
      SizedBox(height: 16.sp),
      ElevatedButton(
        onPressed: () async {
          // Action du bouton
           var url =
                  "http://user3-market.3t.tn/admin/market/subscription/request/new";

              // ignore: deprecated_member_use
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Impossible d\'ouvrir $url';
              }
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.white,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
        child: Text(
          'Sign In or Create Account',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
    ],
  ),
)

                      //   if(Responsive.isMobile(context))

                     /*  Text(
                        "3T",
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 255, 255, 255),
                          shadows: [
                            Shadow(
                              color: Colors.grey,
                              offset: Offset(2, 2),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 2.sp, right: 2.sp),
                        height: 20.h.h, // Adjust the height as needed
                        width:
                            3, // Set the width to define the separator line thickness
                        color: Color.fromARGB(255, 0, 0,
                            0), // Set the color of the separator line
                      ),
                      Text(
                        'MarketPlace',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 0, 0, 0),
                          shadows: [
                            Shadow(
                              color: Colors.grey,
                              offset: Offset(2, 2),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ), */
                      //  if(Responsive.isMobile(context))
                      /* Image.asset(
                    '../../android/app/src/assets/images/3TLOGO.png',
                    width: 200,
                    height: 22,
                  ),  */
                    ]))),
                  )),
              MobMenu()
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              //header
              HeaderContainer(),
/* 
               const SizedBox(
                height: 3,
              ), */
              //body
              //   MyApp(),

              Container(
                // color: Colors.white,
                height: Responsive.isDesktop(context) ? 500.h : 420.h,
                width: double.infinity,
                child: Stack(

                    // width: 2000,
                    children: [
                      Container(
                        width: double.infinity,
                        //height: Responsive.isDesktop(context) ? 700 : 400,
                        height: 400.h,
                        child: //Container(width: 555,height: 500,)
                            Responsive.isDesktop(context) ? Carousel() : null,
                      ),
                      Positioned(
                        // top: 250,
                        top: Responsive.isDesktop(context) ? 300.h : 5.h,
                        bottom: 0.h,
                        left: !Responsive.isDesktop(context) ? 1.h : 5.h,
                        right: !Responsive.isDesktop(context) ? 1.h : 5.h,
                        //left: ,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 1200,
                            //  height: 1000,
                            height:
                                !Responsive.isDesktop(context) ? 550.h : 400,
                            // height: MediaQuery.of(context).size.height,
                            // margin: EdgeInsets.only(
                            //     left: Responsive.isDesktop(context) ? 40 : 20),
                            // Opacité de 50%// Couleur transparente avec une opacité de 50%

                            //ajouter responsive moteur Recherche
                            child: Responsive.isDesktop(context)
                                ? MoteurWeb(
                                    showContainer: showContainer,
                                    counter: counter,
                                  )
                                // ?  MyApp56()
                                // ?Modal()
                                : MoteurMobile(),
                            //child:search2(),
                          ),
                        ),
                      ),
                    ]),
              ),
              //  ProductsPage(Mesproducts:products),

              //footer
              SizedBox(
                height: 5.h,
              ),

              Container(
                height: Responsive.isDesktop(context)
                    ? 800
                    : Responsive.isTablet(context)
                        ? 1200
                        : 1500,
                //height: double.infinity,
                width: 1200,
                child: About(),
              )

              /*  if(Mesproducts.isNotEmpty)
              Container(
                height: double.maxFinite,
                width: double.maxFinite,
                child:PaginationExample(), /* ProductsPage(
                 Mesproducts: Mesproducts,
                ), */
                // height: 500,
              ),   */
              // Tabs
            ],
          ),
        ),
      ),
    );
  }
}
