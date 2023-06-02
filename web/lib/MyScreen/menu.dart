import 'package:flutter/material.dart';
import 'package:t3_market_place/MyScreen/About.dart';
import 'package:t3_market_place/MyScreen/MoteurRenWeb.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:t3_market_place/MyScreen/SellerList.dart';

import 'MesFavouris.dart';
import 'constant.dart';

class HeaderWebMenu extends StatelessWidget {
  const HeaderWebMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HeaderMenu(
          press: ()  {
           Navigator.pushNamed(
                                              context, '/Favoris');
          },
          title: Column(
            children: [
             
              Row(
                children: const [
                  Icon(
                    Icons
                    .favorite_border,color: Color.fromARGB(255, 166, 166, 166),
                    //color: Color.fromARGB(255, 253, 253, 253),
                  ),
                  SizedBox(
                      width:
                          8), // Ajoute un espacement entre l'icône et le texte
                  Text('Favorites',
                      style: TextStyle(
  fontFamily: 'Open Sans',
  fontWeight: FontWeight.bold,
  color: Color.fromARGB(255, 11, 11, 11),shadows: [
      Shadow(
        color: Colors.grey,
        offset: Offset(0, 2),
        blurRadius: 2,
      ),
    ],
)),
                ],
            )  ,
            ],
          ),
        ),
        SizedBox(
          width: 20,
        ),
        HeaderMenu(
          press: () {
             Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>const About(),
              ),
            ); },
          title: Column(
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.info,color: Color.fromARGB(255, 166, 166, 166),
                    //color: Color.fromARGB(255, 255, 255, 255,),
                  ),
                  SizedBox(
                      width:
                          8), // Ajoute un espacement entre l'icône et le texte
                  Text(
                    "About",
                      style: TextStyle(
  fontFamily: 'Open Sans',
  fontWeight: FontWeight.bold,
  color: Color.fromARGB(255, 11, 11, 11),shadows: [
      Shadow(
        color: Colors.grey,
        offset: Offset(0, 2),
        blurRadius: 2,
      ),
    ],
)
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: kPadding,
        ),
        HeaderMenu(
          press: () {   Navigator.pushNamed(
                                              context, '/Boutiques');},
          title: Column(
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.store,color: Color.fromARGB(255, 166, 166, 166),
                    // color: Color.fromARGB(255, 255, 255, 255,)
                  ),
                  SizedBox(
                      width:
                          8), // Ajoute un espacement entre l'icône et le texte
                  Text('Agency',
                      style: TextStyle(
  fontFamily: 'Open Sans',
  fontWeight: FontWeight.bold,
  color: Color.fromARGB(255, 11, 11, 11),shadows: [
      Shadow(
        color: Colors.grey,
        offset: Offset(0, 2),
        blurRadius: 2,
      ),
    ],
)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          width: kPadding,
        ),
        HeaderMenu(
          press: () async {
            var url = "https://www.3t.tn/contact";

            // ignore: deprecated_member_use
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Impossible d\'ouvrir $url';
            }
          },
          title: Column(
            children: [
              Row(
                children: const [
                  Icon(Icons.phone,color: Color.fromARGB(255, 166, 166, 166),
                      //,color: Color.fromARGB(255, 255, 255, 255,)
                      ),
                  SizedBox(
                      width:
                          8), // Ajoute un espacement entre l'icône et le texte
                  Text('Contact',
                      style: TextStyle(
  fontFamily: 'Open Sans',
  fontWeight: FontWeight.bold,
  color: Color.fromARGB(255, 11, 11, 11),shadows: [
      Shadow(
        color: Colors.grey,
        offset: Offset(0, 2),
        blurRadius: 2,
      ),
    ],
)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          width: kPadding,
        ),
        HeaderMenu(
          press: () async {
            var url =
                "http://user3-market.3t.tn/admin/market/subscription/request/new";

            // ignore: deprecated_member_use
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Impossible d\'ouvrir $url';
            }
          },
          title: Column(
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.person_add,color: Color.fromARGB(255, 166, 166, 166),
                    //color: Color.fromARGB(255, 255, 255, 255,)
                  ),
                  SizedBox(
                      width:
                          8), // Ajoute un espacement entre l'icône et le texte
                  Text("Sign up",
                      style: TextStyle(
  fontFamily: 'Open Sans',
  fontWeight: FontWeight.bold,
  color: Color.fromARGB(255, 11, 11, 11),shadows: [
      Shadow(
        color: Colors.grey,
        offset: Offset(0, 2),
        blurRadius: 2,
      ),
    ],
)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MobFooterMenu extends StatelessWidget {
  const MobFooterMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        HeaderMenu(
          press: ()  {
              Navigator.pushNamed(
                                              context, '/Favoris');
          },
          title: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.favorite,color: Color.fromARGB(255, 166, 166, 166),
                      ), // Ajoute un espacement entre l'icône et le texte
                  Text('Favorites',
                      style: TextStyle(
  fontFamily: 'Open Sans',
  fontWeight: FontWeight.bold,
  color: Color.fromARGB(255, 11, 11, 11),shadows: [
      Shadow(
        color: Colors.grey,
        offset: Offset(0, 2),
        blurRadius: 2,
      ),
    ],
)),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: kPadding,
        ),
        HeaderMenu(
          press: () {},
          title: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.info,
                      color: Color.fromARGB(255, 166, 166, 166),),
                  SizedBox(
                      width:
                          8), // Ajoute un espacement entre l'icône et le texte
                  Text("About",
                      style: TextStyle(
  fontFamily: 'Open Sans',
  fontWeight: FontWeight.bold,
  color: Color.fromARGB(255, 11, 11, 11),shadows: [
      Shadow(
        color: Colors.grey,
        offset: Offset(0, 2),
        blurRadius: 2,
      ),
    ],
)),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: kPadding,
        ),
        HeaderMenu(
          press: () {
           
               Navigator.pushNamed(
                                              context, '/Boutiques');
            
          },
          title: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.store,color: Color.fromARGB(255, 166, 166, 166),),
                  SizedBox(
                      width:
                          8), // Ajoute un espacement entre l'icône et le texte
                  Text('Agency',
                      style: TextStyle(
  fontFamily: 'Open Sans',
  fontWeight: FontWeight.bold,
  color: Color.fromARGB(255, 11, 11, 11),shadows: [
      Shadow(
        color: Colors.grey,
        offset: Offset(0, 2),
        blurRadius: 2,
      ),
    ],
)),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: kPadding,
        ),
        HeaderMenu(
          press: () async {
            var url = "https://www.3t.tn/contact";

            // ignore: deprecated_member_use
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Impossible d\'ouvrir $url';
            }
          },
          title: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.phone,color: Color.fromARGB(255, 166, 166, 166),),
                  SizedBox(
                      width:
                          8), // Ajoute un espacement entre l'icône et le texte
                  Text('Contact',
                      style: TextStyle(
  fontFamily: 'Open Sans',
  fontWeight: FontWeight.bold,
  color: Color.fromARGB(255, 11, 11, 11),shadows: [
      Shadow(
        color: Colors.grey,
        offset: Offset(0, 2),
        blurRadius: 2,
      ),
    ],
)),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: kPadding,
        ),
        HeaderMenu(
          press: () async {
            var url =
                "http://user3-market.3t.tn/admin/market/subscription/request/new";

            // ignore: deprecated_member_use
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Impossible d\'ouvrir $url';
            }
          },
          title: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.person_add,color: Color.fromARGB(255, 166, 166, 166),),
                  SizedBox(
                      width:
                          8), // Ajoute un espacement entre l'icône et le texte
                  Text("Sign up",
                      style: TextStyle(
  fontFamily: 'Open Sans',
  fontWeight: FontWeight.bold,
  color: Color.fromARGB(255, 11, 11, 11),shadows: [
      Shadow(
        color: Colors.grey,
        offset: Offset(0, 2),
        blurRadius: 2,
      ),
    ],
)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HeaderMenu extends StatelessWidget {
  const HeaderMenu({
    Key? key,
    required this.title,
    required this.press,
  }) : super(key: key);

  final Widget title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        child: Column(
          children: [
            title,
          ],
        ),
      ),
    );
  }
}

class MobMenu extends StatefulWidget {
  const MobMenu({Key? key}) : super(key: key);

  @override
  _MobMenuState createState() => _MobMenuState();
}

class _MobMenuState extends State<MobMenu> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderMenu(
            press: ()  {
             Navigator.pushNamed(
                                              context, '/Favoris');
            },
            title: Column(
              children: [
                 Container(
                margin: EdgeInsets.all(8),
                child: 
                Row(
                  children: [
                    Icon(Icons.favorite_border,color: Color.fromARGB(255, 153, 153, 153),),
                    SizedBox(
                        width:
                            10.w), // Ajoute un espacement entre l'icône et le texte
                    Text('Favorites',
                      style: TextStyle(
  fontFamily: 'Open Sans',
  fontWeight: FontWeight.bold,
  fontSize: 18.sp,
  color: Color.fromARGB(255, 11, 11, 11),shadows: [
      Shadow(
        color: Colors.grey,
        offset: Offset(0, 2),
        blurRadius: 2,
      ),
    ],
)),
                  ],
                   )  ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
         
          HeaderMenu(
            press: () {},
            title: Column(
              children: [
                 Container(
                margin: EdgeInsets.all(8),
                child: 
                Row(
                  children: [
                    Icon(Icons.info,color: Color.fromARGB(255, 153, 153, 153),),
                    SizedBox(
                        width:
                            8), // Ajoute un espacement entre l'icône et le texte
                    Text("About",
                      style: TextStyle(
  fontFamily: 'Open Sans',
  fontWeight: FontWeight.bold,
  fontSize: 18.sp,
  color: Color.fromARGB(255, 11, 11, 11),shadows: [
      Shadow(
        color: Colors.grey,
        offset: Offset(0, 2),
        blurRadius: 2,
      ),
    ],
)),
                  ],
                  ) ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        
          HeaderMenu(
            press: () {     Navigator.pushNamed(
                                              context, '/Boutiques');},
            title: Column(
              children: [
                 Container(
                margin: EdgeInsets.all(8),
                child: 
                Row(
                  children: [
                    Icon(Icons.store,color: Color.fromARGB(255, 153, 153, 153),),
                    SizedBox(
                        width:
                            8), // Ajoute un espacement entre l'icône et le texte
                    Text('Agency',
                      style: TextStyle(
  fontFamily: 'Open Sans',
  fontWeight: FontWeight.bold,fontSize: 18.sp,
  color: Color.fromARGB(255, 11, 11, 11),shadows: [
      Shadow(
        color: Colors.grey,
        offset: Offset(0, 2),
        blurRadius: 2,
      ),
    ],
)),
                  ],
                  ) ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
         
          HeaderMenu(
            press: () async {
              var url = "https://www.3t.tn/contact";

              // ignore: deprecated_member_use
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Impossible d\'ouvrir $url';
              }
            },
            title: Column(
              children: [
                 Container(
                margin: EdgeInsets.all(8),
                child: 
                Row(
                  children: [
                    Icon(Icons.phone,color: Color.fromARGB(255, 153, 153, 153),),
                    SizedBox(
                        width:
                            8), // Ajoute un espacement entre l'icône et le texte
                    Text('Contact',
                      style: TextStyle(
  fontFamily: 'Open Sans',
  fontWeight: FontWeight.bold,fontSize: 18.sp,
  color: Color.fromARGB(255, 11, 11, 11),shadows: [
      Shadow(
        color: Colors.grey,
        offset: Offset(0, 2),
        blurRadius: 2,
      ),
    ],
)),
                  ],
                 )),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
         
          HeaderMenu(
            press: () async {
              var url =
                  "http://user3-market.3t.tn/admin/market/subscription/request/new";

              // ignore: deprecated_member_use
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Impossible d\'ouvrir $url';
              }
            },
            title: Column(
              children: [
                  Container(
                margin: EdgeInsets.all(8),
                child: 
                Row(
                  children: [
                    Icon(Icons.person_add,color: Color.fromARGB(255, 153, 153, 153),),
                    SizedBox(
                        width:
                            8), // Ajoute un espacement entre l'icône et le texte
                    Text("Sign up",
                      style: TextStyle(
  fontFamily: 'Open Sans',
  fontWeight: FontWeight.bold,fontSize: 18.sp,
  color: Color.fromARGB(255, 11, 11, 11),shadows: [
      Shadow(
        color: Colors.grey,
        offset: Offset(0, 2),
        blurRadius: 2,
      ),
    ],
)),
                   /*  Divider(
                      color: Colors.black,
                      thickness: 1.0,
                    ), */
                  ],
                    )  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
