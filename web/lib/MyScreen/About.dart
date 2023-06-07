import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
//import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:t3_market_place/MyScreen/responsive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'map.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Container(
          decoration: Responsive.isDesktop(context)
              ? BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 156, 156, 156),
                      offset: Offset(0, 2), // Décalage vertical de l'ombre
                      blurRadius: 2, // Rayon de flou de l'ombre
                    ),
                  ],
                )
              : null,
          //height: Responsive.isDesktop(context)? 800 :Responsive.isTablet(context)?1200 :1700  ,
          //height: double.infinity,
          // width: 1200,
          margin: EdgeInsets.only(bottom: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.maxFinite,
                padding: Responsive.isDesktop(context)
                    ? EdgeInsets.all(10)
                    : EdgeInsets.all(3),
                height: 50,
                child: Center(
                    child: Text(
                  'Welcome to our marketplace!',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 19, 5, 5),
                  ),
                )),
              ),

              /*  Container(
    width: 500,
    height: 90,
      child: Image.network(
        'https://scontent-vie1-1.xx.fbcdn.net/v/t39.30808-6/308636356_515915863873663_4439212050108384043_n.png?_nc_cat=102&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=O1XgyY-U-9gAX_AUEm6&_nc_oc=AQnMC9M_RTRqxuxSolOgc7Wvy2lGIT-HKOWOeJ7oPmNjNGKtbYPM_jNtDWQIB-9noHo&_nc_ht=scontent-vie1-1.xx&oh=00_AfCabh01vhS7mnOfdptUeKprf7p2PgXcTVDX3NUdF1mw_A&oe=6471A490',
        width: 500,
      ),), */
              if (Responsive.isDesktop(context))
                Container(
                    // width: 1200,
                    height: 200,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            'Welcome to our dedicated marketplace for travel agencies, your ultimate platform to discover and book exceptional travel experiences. We understand the challenges that travel agencies face in a constantly evolving world, which is why we have created a comprehensive and intuitive solution to help you thrive.\n\n',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.normal, //fontFamily: 'Pacifico'
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  '../../android/app/src/assets/images/logo3t2.png',
                                  height: 100,
                                ),
                              ],
                            ))
                      ],
                    )),
              if (!Responsive.isDesktop(context))
                Column(
                  children: [
                    // width: double.maxFinite,

                    Image.asset('images/logo3t2.png'),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      height: 200,
                      margin: EdgeInsets.all(8),
                      child: Text(
                        'Welcome to our dedicated marketplace for travel agencies, your ultimate platform to discover and book exceptional travel experiences. We understand the challenges that travel agencies face in a constantly evolving world, which is why we have created a comprehensive and intuitive solution to help you thrive.\n\n'
                        /*  'Grâce à notre marketplace, vous avez accès à une vaste sélection de destinations, d\'hébergements, d\'activités et de services supplémentaires, soigneusement choisis pour répondre aux besoins de vos clients les plus exigeants. Nous travaillons en étroite collaboration avec des partenaires de confiance, des hôtels de renom aux guides touristiques expérimentés, pour vous offrir des options de haute qualité à chaque étape du voyage.\n\n'
  'Notre interface conviviale vous permet de rechercher, comparer et réserver facilement les meilleures offres pour vos clients. Que vous organisiez des voyages d\'affaires, des escapades romantiques, des voyages en famille ou des aventures exotiques, notre marketplace vous fournit toutes les informations nécessaires pour prendre des décisions éclairées. De plus, notre système de gestion des réservations rationalise le processus, vous permettant de gérer efficacement les itinéraires et de rester en contact avec vos clients.\n\n'
  'Nous croyons fermement que chaque voyage est une occasion de créer des souvenirs durables, et c\'est pourquoi nous mettons l\'accent sur l\'excellence du service à la clientèle. Notre équipe dévouée est prête à vous assister à chaque étape, vous offrant un support personnalisé et des conseils d\'experts pour garantir le succès de vos projets de voyage.\n\n'
  'Rejoignez notre marketplace dès aujourd\'hui et découvrez un monde d\'opportunités pour développer votre activité. Ensemble, nous pouvons créer des expériences de voyage exceptionnelles et inoubliables pour vos clients. Faites confiance à notre marketplace pour vous aider à atteindre de nouveaux sommets dans l\'industrie du voyage.', */
                        ,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight:
                              FontWeight.normal, //fontFamily: 'Pacifico',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.w,
                    ),
                  ],
                ),

              SizedBox(
                height: 10.h,
              ),
              if (Responsive.isDesktop(context) || Responsive.isTablet(context))
                Container(
                    color: Colors.white,
                    margin: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            'Our Services',
                            style: TextStyle(
                                color: Color.fromARGB(255, 3, 25, 60),
                                fontSize: 30.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(children: [
                          Expanded(
                              flex: Responsive.isDesktop(context) ? 3 : 6,
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromARGB(
                                              255, 156, 156, 156),
                                          offset: Offset(0,
                                              2), // Décalage vertical de l'ombre
                                          blurRadius:
                                              2, // Rayon de flou de l'ombre
                                        ),
                                      ],
                                    ),
                                    //color: Colors.white,
                                    height: 300,
                                    padding: EdgeInsets.all(10 / 2),
                                    width: 300,
                                    child: Column(
                                      children: [
                                        Text(
                                          'Hotels',
                                          style: TextStyle(
                                              color: Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 24.sp),
                                        ),

                                        Expanded(
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Image.asset(
                                                    'images/myhotel9.jpeg'))),

                                        //  Text('this is my data of hotels in session [Instance of ')
                                      ],
                                    )),
                              )),
                          SizedBox(
                            width: 5.w,
                          ),
                          Expanded(
                              flex: Responsive.isDesktop(context) ? 3 : 6,
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromARGB(
                                              255, 156, 156, 156),
                                          offset: Offset(0,
                                              2), // Décalage vertical de l'ombre
                                          blurRadius:
                                              2, // Rayon de flou de l'ombre
                                        ),
                                      ],
                                    ),
                                    height: 300,
                                    padding: EdgeInsets.all(10 / 2),
                                    width: 300,
                                    child: Column(
                                      children: [
                                        Text(
                                          'Tours',
                                          style: TextStyle(
                                              color: Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 24.sp),
                                        ),
                                        Expanded(
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Image.asset(
                                                    'images/circuit.jpeg'))),

                                        //  Text('ggggg')
                                      ],
                                    )),
                              )),
                          SizedBox(
                            width: 5.w,
                          ),
                          Expanded(
                              flex: Responsive.isDesktop(context) ? 3 : 6,
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(30.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromARGB(
                                              255, 156, 156, 156),
                                          offset: Offset(0,
                                              2), // Décalage vertical de l'ombre
                                          blurRadius:
                                              2, // Rayon de flou de l'ombre
                                        ),
                                      ],
                                    ),
                                    height: 300,
                                    padding: EdgeInsets.all(10 / 2),
                                    width: 300,
                                    child: Column(
                                      children: [
                                        Text(
                                          'Traveling',
                                          style: TextStyle(
                                              color: Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 24.sp),
                                        ),
                                        Expanded(
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Image.asset(
                                                    'images/fly.jpeg'))),

                                        // Text('ggggg')
                                      ],
                                    )),
                              )),
                        ]),
                        SizedBox(
                          height: 15.h,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Are you interested in our marketplace?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            Container(
                                height: 40,
                                width: 300,
                                margin: EdgeInsets.all(5),
                                child: ElevatedButton(
                                  onPressed: () async {
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
                                    elevation: 5,
                                    backgroundColor:
                                        Color.fromARGB(255, 212, 32, 32),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                    // padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                  ),
                                  child: Text(
                                    'Sign up',
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 254, 254, 254),
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ],
                    )),
              if (Responsive.isMobile(context))
                Container(
                  color: Colors.white,
                  margin: EdgeInsets.all(8),
                  child: Column(children: [
                    //Column(children: [

/* Expanded(
  flex:10,child:Material(
     elevation: 5,
      borderRadius: BorderRadius.circular(8.0),
     child: */

                    Center(
                      child: Text(
                        'Nos Services',
                        style: TextStyle(
                            color: Color.fromARGB(255, 3, 25, 60),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 156, 156, 156),
                              offset:
                                  Offset(0, 2), // Décalage vertical de l'ombre
                              blurRadius: 2, // Rayon de flou de l'ombre
                            ),
                          ],
                        ),
                        //color: Colors.white,
                        height: 300,
                        // padding: EdgeInsets.all(10 / 2),
                        width: double.infinity,
                        child: Column(
                          children: [
                            Text(
                              'Hotels',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 24.sp),
                            ),

                            Expanded(
                                child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                // '../../android/app/src/assets/images/myhotel9.jpeg',
                                'images/myhotel9.jpeg',
                                width: double.maxFinite,
                                height: 150,
                              ),
                            )),

                            //  Text('this is my data of hotels in session [Instance of ')
                          ],
                        )),
                    //)),
                    SizedBox(
                      height: 5.w,
                    ),
/* Expanded(
  flex:10,child:Material(
     elevation: 5,
      borderRadius: BorderRadius.circular(8.0),
     child: */
                    Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 156, 156, 156),
                              offset:
                                  Offset(0, 2), // Décalage vertical de l'ombre
                              blurRadius: 2, // Rayon de flou de l'ombre
                            ),
                          ],
                        ),
                        height: 300,
                        //padding: EdgeInsets.all(10 / 2),
                        width: double.infinity,
                        child: Column(
                          children: [
                            Text(
                              'Tours',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 24.sp),
                            ),
                            Expanded(
                                child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                'images/circuit.jpeg',
                                width: double.maxFinite,
                                height: 150,
                              ),
                            )),

                            //  Text('ggggg')
                          ],
                        )),
                    // )),
                    SizedBox(
                      height: 5.w,
                    ),
                    /*  Expanded(
  flex:10,child:Material(
     elevation: 5,
      borderRadius: BorderRadius.circular(30.0),
     child: */
                    Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 156, 156, 156),
                              offset:
                                  Offset(0, 2), // Décalage vertical de l'ombre
                              blurRadius: 2, // Rayon de flou de l'ombre
                            ),
                          ],
                        ),
                        height: 300,
                        //  padding: EdgeInsets.all(10 / 2),
                        width: double.infinity,
                        child: Column(
                          children: [
                            Text(
                              'Travelling',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 24.sp),
                            ),
                            Expanded(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.asset('images/fly.jpeg'))),

                            // Text('ggggg')
                          ],
                        )),
                    //)),
                    SizedBox(
                      height: 15.h,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Êtes-vous intéressé par notre marketplace ?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Container(
                            height: 40,
                            width: 300,
                            margin: EdgeInsets.all(5),
                            child: ElevatedButton(
                              onPressed: () async {
                                var url =
                                    "http://user3-market.3t.tn/admin/market/subscription/request/new";

                                // ignore: deprecated_member_use
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Impossible d\'ouvrir $url';
                                }

                                // Action à effectuer lors du clic sur le bouton "S'inscrire"
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 5,
                                backgroundColor:
                                    Color.fromARGB(255, 212, 32, 32),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                // padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              ),
                              child: Text(
                                'S\'inscrire',
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 254, 254, 254),
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ]),
                ),

              // SizedBox(height: 20),
            ],
          ),
        )));
  }
}
