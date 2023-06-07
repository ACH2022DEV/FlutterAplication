import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:t3_market_place/MyScreen/responsive.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:t3_market_place/models/sellersModels.dart';
//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_advanced_networkimage_2/provider.dart';
import 'package:flutter_advanced_networkimage_2/transition.dart';
import 'package:flutter_advanced_networkimage_2/zoomable.dart';
import 'package:image_network/image_network.dart';

//import 'package:flutter_image/flutter_image.dart';
//import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';

class MyBoutique extends StatefulWidget {
  const MyBoutique({Key? key}) : super(key: key);

  @override
  _MyBoutiqueState createState() => _MyBoutiqueState();
}

class _MyBoutiqueState extends State<MyBoutique> {
  bool _loading = true;
  List<Seller> sellers = [];

  @override
  void initState() {
    super.initState();
    getAllSellers();
  }

  int sellerLenght = 0;
//getAllSellers
  Future<void> getAllSellers() async {
    final url = Uri.parse('http://user3-market.3t.tn/getAllSeller');

    // Envoyer la requête GET
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Conversion de la réponse en JSON
      final jsonData = jsonDecode(response.body);
      //  print(jsonData);

      sellers = jsonData.map<Seller>((json) => Seller.fromJson(json)).toList();
      sellerLenght = sellers.length;

      setState(() {
        _loading = false;
      });
    } else {
      // Gérer les erreurs de requête
      print('Erreur de requête: ${response.statusCode}');
    }
  }
//end Of getAllSellers

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 255, 255, 255),
            // Set the desired color for the back button
          ),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back to the previous page
          },
        ),
        title: Align(
          child: Text(
            'Agency($sellerLenght)',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 200, 3, 3),
      ),
      body: Column(
          // margin: EdgeInsets.only(top: 20),
          //padding: MediaQuery.of(context).size.width >= 1000
          /*    ? EdgeInsets.all(50)
            : null, */
          children: [
            Expanded(
                child: GridView.builder(
              padding: Responsive.isDesktop(context)
                  ? EdgeInsets.all(10)
                  : EdgeInsets.all(3),
              primary: false,
              shrinkWrap: true,
              itemCount: sellers.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width >= 1250
                    ? 5
                    : MediaQuery.of(context).size.width >= 400 &&
                            MediaQuery.of(context).size.width < 550
                        ? 2
                        : MediaQuery.of(context).size.width < 400
                            ? 1
                            : MediaQuery.of(context).size.width >= 780 &&
                                    MediaQuery.of(context).size.width < 1250
                                ? 4
                                : 3,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final seller = sellers[index];

                return Container(
                  height: Responsive.isDesktop(context)
                      ? 120.h
                      : Responsive.isTablet(context)
                          ? 80.h
                          : 30.h,
                  width: double.infinity,
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromARGB(255, 0, 0, 0), width: 3),
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Color.fromARGB(255, 183, 183, 183).withOpacity(0.3),
                        blurRadius: 2,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      /*  Expanded(
                        flex: 8,
                        child: Container(
                            height: 60,
                            width: 200,
                            child: Image.network(
                              'http://user3-market.3t.tn/getImages?filename=${seller.brochureFilename}',
                              fit: BoxFit.cover,
                              height: 80.h,
                            )),
                      ), */
                      Expanded(
                        flex: 8,
                        child: Container(
                          height: 45,
                          width: 200,
                          child: Image.network(
                            'http://user3-market.3t.tn/getImages?filename=${seller.brochureFilename}',
                            fit: BoxFit.cover,
                            height: 80.h,
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        '${seller.name}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontFamily: AutofillHints.name,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 182, 0, 0)),
                      ),
                      SizedBox(height: 0.5.h),
                      Container(
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Color.fromARGB(255, 110, 131, 142),
                                size: Responsive.isDesktop(context)
                                    ? 30.sp
                                    : Responsive.isTablet(context)
                                        ? 23.sp
                                        : 23.sp,
                              ),
                              Text(
                                '${seller.address}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: Responsive.isDesktop(context)
                                      ? 15.sp
                                      : Responsive.isTablet(context)
                                          ? 15.sp
                                          : 15.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          var url = seller.website;

                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Impossible d\'ouvrir $url';
                          }
                        },
                        icon: Icon(
                          Icons.store,
                          color: Color.fromARGB(255, 112, 112, 112),
                        ),
                        label: Text(
                          'Visit Now',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(5),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 168, 0, 0)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )),
            if (!Responsive.isDesktop(context))
              Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            // Action à effectuer lorsqu'on appuie sur l'icône
                            Navigator.pushNamed(context, '/home');
                          },
                          color: Color.fromARGB(255, 0, 0, 0),
                          iconSize: 30,
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.favorite_border,
                            color: Color.fromARGB(255, 1, 1, 1),
                            //color: Color.fromARGB(255, 253, 253, 253),
                          ),
                          onPressed: () {
                            // Action à effectuer lorsqu'on appuie sur l'icône
                            Navigator.pushNamed(context, '/Favoris');
                          },
                        ),
                      ),
                      Expanded(
                          child: IconButton(
                        icon: Icon(Icons.store),
                        onPressed: () {
                          // Action à effectuer lorsqu'on appuie sur l'icône
                          Navigator.pushNamed(context, '/Boutiques');
                        },
                      )),
                      Expanded(
                          child: IconButton(
                        icon: Icon(Icons.person_add),
                        onPressed: () async {
                          // Action à effectuer lorsqu'on appuie sur l'icône
                          var url =
                              "http://user3-market.3t.tn/admin/market/subscription/request/new";

                          // ignore: deprecated_member_use
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Impossible d\'ouvrir $url';
                          }
                        },
                      )),
                    ],
                  )),
          ]),
    );

    /*
    );
  } */
  }
}
