/*  import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HotelMapScreen extends StatefulWidget {
  @override
  _HotelMapScreenState createState() => _HotelMapScreenState();
}

class _HotelMapScreenState extends State<HotelMapScreen> {
  List<Map<String, dynamic>> hotels = [
    {
      "hotelId": "35",
      "hotelName": "Sohoto Marhaba Belvedere hotel bellvue park",
      "category": "5",
      "location": "Sousse",
      "Picture":
          "https://btob.3t.tn/public/images/image/hotel_0.81559900-1674551734.jpg",
      "Latitude": 35.8997,
      "Longitude": 10.6396,
      "PromoText": " \n \n",
      "lowPrice": "189",
      "currency": "TND",
      "detailsLink":
          "https://btob.3t.tn/hotels-en-tunisie/Sousse/Sohoto-Marhaba-Belvedere-hotel-bellvue-park/detail?&params=129_35_4",
      "Agency": "Flexis"
    }
  ];

  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _markers = _createMarkers();
  }

  Set<Marker> _createMarkers() {
    return hotels.map((hotel) {
      return Marker(
        markerId: MarkerId(hotel['hotelId']),
        position: LatLng(hotel['Latitude'], hotel['Longitude']),
        infoWindow: InfoWindow(
          title: hotel['hotelName'],
          snippet: hotel['location'],
          onTap: () {
            // Handle marker tap event, such as opening a hotel details page
            // You can use the hotel['detailsLink'] to navigate to the details page
            print('Tapped on marker: ${hotel['hotelName']}');
          },
        ),
      );
    }).toSet();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel Map'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(35.8997, 10.6396), // Set initial map center
          zoom: 12, // Adjust the initial zoom level as needed
        ),
        markers: _markers,
      ),
    );
  }
}



 */

/* 
import 'package:flutter/material.dart';
import 'package:google_maps/google_maps.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HotelMapScreen extends StatelessWidget {
  final List<Map<String, dynamic>> hotels = [
    {
      "hotelId": "35",
      "hotelName": "Sohoto Marhaba Belvedere hotel bellvue park",
      "category": "5",
      "location": "Sousse",
      "Picture":
          "https://btob.3t.tn/public/images/image/hotel_0.81559900-1674551734.jpg",
      "Latitude": 35.8997,
      "Longitude": 10.6396,
      "PromoText": " \n \n",
      "lowPrice": "189",
      "currency": "TND",
      "detailsLink":
          "https://btob.3t.tn/hotels-en-tunisie/Sousse/Sohoto-Marhaba-Belvedere-hotel-bellvue-park/detail?&params=129_35_4",
      "Agency": "Flexis"
    }
  ];

  final String apiKey = 'YOUR_API_KEY';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel Map'),
      ),
      body: GoogleMap(
        initialOptions: GoogleMapOptions(
          center: LatLng(35.8997, 10.6396),
          zoom: 12,
        ),
        onMapCreated: (GoogleMapController controller) {
          for (var hotel in hotels) {
            final marker = Marker(
              MarkerOptions(
                position: LatLng(hotel['Latitude'], hotel['Longitude']),
                infoWindowText: InfoWindowText(
                  hotel['hotelName'],
                  hotel['location'],
                ),
              ),
            );
            controller.addMarker(marker);
          }
        },
        apiKey: apiKey, initialCameraPosition: null,
      ),
    );
  }
}
 */

/* import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; */

/* class HotelMap extends StatefulWidget {
  @override
  _HotelMapState createState() => _HotelMapState();
}

class _HotelMapState extends State<HotelMap> {
  final LatLng hotelLocation = LatLng(35.8997, 10.6396); // Replace with the hotel's latitude and longitude

  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel Map'),
      ),
      body: GoogleMap(
        onMapCreated: onMapCreated,
        initialCameraPosition: CameraPosition(
          target: hotelLocation,
          zoom: 14.0,
        ),
        markers: Set<Marker>.of([
          Marker(
            markerId: MarkerId('hotelMarker'),
            position: hotelLocation,
          ),
        ]),
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
} */

/* void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapbox GL Hotel',
      home: HotelMap(),
    );
  }
}

class HotelMap extends StatefulWidget {
  @override
  _HotelMapState createState() => _HotelMapState();
}

class _HotelMapState extends State<HotelMap> {
  final String mapboxAccessToken = 'pk.eyJ1IjoiYWJkZWxheml6Y2hhcmZpIiwiYSI6ImNsaWVwdnpyZTBicmQzZHA2Z2d3YWo3enMifQ.KPZ7B1rpAlcaS1Zb1hAhkQ'; // Replace with your Mapbox access token
  final LatLng hotelLocation = LatLng(35.8997, 10.6396); // Replace with the hotel's latitude and longitude

  MapboxMapController? mapController;
  List<Symbol> symbols = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel Map'),
      ),
      body: MapboxMap(
        accessToken: mapboxAccessToken,
        onMapCreated: onMapCreated,
        initialCameraPosition: CameraPosition(
          target: hotelLocation,
          zoom: 14.0,
        ),
      ),
    );
  }

  void onMapCreated(MapboxMapController controller) {
    mapController = controller;

    addMarker();
  }

  void addMarker() async {
    SymbolOptions symbolOptions = SymbolOptions(
      geometry: hotelLocation,
      iconImage: 'marker-15',
      iconSize: 3.0,
    );

    await mapController?.addSymbol(symbolOptions);
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(hotelLocation, 14.0),
    );
  }
}
  */
/* import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapbox GL Hotel',
      home: HotelMap(),
    );
  }
}

class HotelMap extends StatefulWidget {
  @override
  _HotelMapState createState() => _HotelMapState();
}

class _HotelMapState extends State<HotelMap> {
  final String mapboxAccessToken = 'pk.eyJ1IjoiYWJkZWxheml6Y2hhcmZpIiwiYSI6ImNsaWVwdnpyZTBicmQzZHA2Z2d3YWo3enMifQ.KPZ7B1rpAlcaS1Zb1hAhkQ'; // Replace with your Mapbox access token
  final LatLng hotelLocation = LatLng(35.8997, 10.6396); // Replace with the hotel's latitude and longitude

  MapboxMapController? mapController;
  List<Symbol> symbols = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel Map'),
      ),
      body: MapboxMap(
        accessToken: mapboxAccessToken,
        onMapCreated: onMapCreated,
        initialCameraPosition: CameraPosition(
          target: hotelLocation,
          zoom: 14.0,
        ),
      ),
    );
  }

  void onMapCreated(MapboxMapController controller) {
    mapController = controller;

    addMarker();
  }

  void addMarker() async {
    SymbolOptions symbolOptions = SymbolOptions(
      geometry: hotelLocation,
      iconImage: 'marker-15',
      iconSize: 3.0,
    );

    await mapController?.addSymbol(symbolOptions);
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(hotelLocation, 14.0),
    );
  }
}
 */
/* import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

//import 'main.dart';
import 'map2.dart';
//import 'page.dart';

class FullMapPage extends ExamplePage {
  FullMapPage() : super(const Icon(Icons.map), 'Full screen map');

  @override
  Widget build(BuildContext context) {
    return const FullMap();
  }
}

class FullMap extends StatefulWidget {
  const FullMap();

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<FullMap> {
  MapboxMapController? mapController;
  var isLight = true;

  _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  _onStyleLoadedCallback() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Style loaded :)"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(32.0),
          child: FloatingActionButton(
            child: Icon(Icons.swap_horiz),
            onPressed: () => setState(
              () => isLight = !isLight,
            ),
          ),
        ),
        body: MapboxMap(
          styleString: isLight ? MapboxStyles.LIGHT : MapboxStyles.DARK,
          accessToken: 'pk.eyJ1IjoiYWJkZWxheml6Y2hhcmZpIiwiYSI6ImNsaWVwdnpyZTBicmQzZHA2Z2d3YWo3enMifQ.KPZ7B1rpAlcaS1Zb1hAhkQ',
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(target: LatLng(0.0, 0.0)),
          onStyleLoadedCallback: _onStyleLoadedCallback,
        ));
  }
} */
//gooogle

 /* import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_maps/google_maps.dart';
import 'dart:ui' as ui;

class GoogleMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String htmlId = "7";

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      final myLatlng = LatLng(35.865646000000000, 10.606364000000000);

      // another location
      final myLatlng2 = LatLng(1.4521, 103.9198);

      final mapOptions = MapOptions()
        ..zoom = 10
        ..center = LatLng(35.865646000000000, 10.606364000000000);

      final elem = DivElement()
        ..id = htmlId
        ..style.width = "100%"
        ..style.height = "100%"
        ..style.border = 'none';

      final map = GMap(elem, mapOptions);

      final marker = Marker(MarkerOptions()
        ..position = myLatlng
        ..map = map
        ..title = 'Hello World!'
        ..label = 'h'
        ..icon =
            'https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png');

      // Another marker
      Marker(
        MarkerOptions()
          ..position = myLatlng2
          ..map = map,
      );

      final infoWindow =
          InfoWindow(InfoWindowOptions()..content = contentString);
      marker.onClick.listen((event) => infoWindow.open(map, marker));
      return elem;
    });

    return HtmlElementView(viewType: htmlId);
  }
}

var contentString = '<div id="content">' +
    '<div id="siteNotice">' +
    '</div>' +
    '<h1 id="firstHeading" class="firstHeading">Uluru</h1>' +
    '<div id="bodyContent">' +
    '<p><b>Uluru</b>, also referred to as <b>Ayers Rock</b>, is a large ' +
    'sandstone rock formation in the southern part of the ' +
    'Northern Territory, central Australia. It lies 335&#160;km (208&#160;mi) ' +
    'south west of the nearest large town, Alice Springs; 450&#160;km ' +
    '(280&#160;mi) by road. Kata Tjuta and Uluru are the two major ' +
    'features of the Uluru - Kata Tjuta National Park. Uluru is ' +
    'sacred to the Pitjantjatjara and Yankunytjatjara, the ' +
    'Aboriginal people of the area. It has many springs, waterholes, ' +
    'rock caves and ancient paintings. Uluru is listed as a World ' +
    'Heritage Site.</p>' +
    '<p>Attribution: Uluru, <a href="https://en.wikipedia.org/w/index.php?title=Uluru&oldid=297882194">' +
    'https://en.wikipedia.org/w/index.php?title=Uluru</a> ' +
    '(last visited June 22, 2009).</p>' +
    '</div>' +
    '</div>';   */
//mapbox

/* import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Map with Mapbox',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Map with Mapbox'),
        ),
        body: FlutterMap(
          options: MapOptions(
            center: LatLng(51.5, -0.09), // Coordonnées de la carte
            zoom: 13.0, // Niveau de zoom initial
          ),
          layers: [
            TileLayerOptions(
              urlTemplate:
                  'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
              additionalOptions: {
                'accessToken': 'YOUR_MAPBOX_ACCESS_TOKEN',
                'id': 'mapbox/streets-v11', // Style de carte Mapbox
              },
            ),
          ],
        ),
      ),
    );
  }
}
 */
/* import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapbox Map in Flutter Web',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Mapbox Map in Flutter Web'),
        ),
        body: MapboxMap(
          accessToken: 'pk.eyJ1IjoiYWJkZWxheml6Y2hhcmZpIiwiYSI6ImNsaWVwdnpyZTBicmQzZHA2Z2d3YWo3enMifQ.KPZ7B1rpAlcaS1Zb1hAhkQ',
          onMapCreated: (controller) {
            // Use the controller to interact with the map
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(51.5, -0.09), // Map center coordinates
            zoom: 13.0, // Initial zoom level
          ),
        ),
      ),
    );
  }
}
 */
/* import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Map on Web',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Map on Web'),
        ),
        body: FlutterMap(
          options: MapOptions(
            center: LatLng(51.5, -0.09), // Map center coordinates
            zoom: 13.0, // Initial zoom level
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'], // Subdomains for better performance
            ),
          ],
        ),
      ),
    );
  }
}
 *///previoooooooooooooooous
/*  import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MapboxMapController mapController;
  void _onMapCreated(MapboxMapController Controller) {
    mapController = Controller;
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MapboxMap(
        accessToken:
            'pk.eyJ1IjoiYWJkZWxheml6Y2hhcmZpIiwiYSI6ImNsaWVwdnpyZTBicmQzZHA2Z2d3YWo3enMifQ.KPZ7B1rpAlcaS1Zb1hAhkQ',
        onMapCreated: _onMapCreated,
        onStyleLoadedCallback: () => addCircle(mapController),
        initialCameraPosition: CameraPosition(
          target: LatLng(35.865646000000000, 10.606364000000000),
          zoom: 14,
        ),
      ),
    );
  }

  void addCircle(MapboxMapController mapController) {
    mapController.addCircle(CircleOptions(
        geometry: LatLng(35.865646000000000, 10.606364000000000),
        circleColor: '#25555',
        circleRadius: 15));
  }
}
  */
/*  import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:leaflet_flutter/leaflet_flutter.dart';
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 32, 32),
        title: const Text('Flutter MapBox'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              minZoom: 5,
              maxZoom: 18,
              zoom: 13,
              center: AppConstants.myLocation,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/dhruv25/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}",
                additionalOptions: {
                  'mapStyleId': AppConstants.mapBoxStyleId,
                  'accessToken': AppConstants.mapBoxAccessToken,
                },
              ),
            ],
          ),
        ],
      ),
    );
  } */
/*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leaflet Map',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Leaflet Map'),
        ),
        body: LeafletMap(
          center: LatLng(51.5, -0.09),
          zoom: 13.0,
          onMapCreated: (mapController) {
            // Vous pouvez effectuer des actions supplémentaires ici après la création de la carte
          },
          layers: [
            TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
          ],
        ),
      ),
    );
  }
}
 */

/* class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FlutterMap(
          options: MapOptions(
            center: LatLng(51.509364, -0.128928),
            zoom: 9.2,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
          ],
          nonRotatedChildren: [
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} */

// lib/main.dart
// lib/main.dart

/* 
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_maps/google_maps.dart';
import 'dart:ui' as ui;

class GoogleMapWithHotelList extends StatelessWidget {
  final List<Hotel> hotels = [
    Hotel('Hotel A', LatLng(35.865646, 10.606364)),
     Hotel('Hotel B', LatLng(35.855912, 10.591635)),
    Hotel('Hotel C', LatLng(35.875843, 10.620288)),
    Hotel('Hotel D', LatLng(35.862219, 10.596166)),
    Hotel('Hotel E', LatLng(35.868876, 10.613471)), 
  ];

  @override
  Widget build(BuildContext context) {
    String htmlId = "7";

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      final mapOptions = MapOptions()
        ..zoom = 14
        ..center = LatLng(35.865646, 10.606364);

      final elem = DivElement()
        ..id = htmlId
        ..style.width = "100%"
        ..style.height = "100%"
        ..style.border = 'none';

      final map = GMap(elem, mapOptions);

      hotels.forEach((hotel) {
        Marker(
          MarkerOptions()
            ..position = hotel.latLng
            ..map = map
            ..title = hotel.name
            ..label = hotel.name.substring(0, 1)
            ..icon = 'https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png',
        );
      });

      return elem;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel List with Map'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: hotels.length,
              itemBuilder: (context, index) {
                final hotel = hotels[index];
                return ListTile(
                  title: Text(hotel.name),
                  subtitle: Text(
                    'Latitude: ${hotel.latLng.lat}, Longitude: ${hotel.latLng.lng}',
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: HtmlElementView(viewType: htmlId),
          ),
        ],
      ),
    );
  }
}

class Hotel {
  final String name;
  final LatLng latLng;

  Hotel(this.name, this.latLng);
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GoogleMapWithHotelList(),
    );
  }
} */

/* import 'package:flutter/material.dart';
import 'dart:html';
import 'dart:ui' as ui;
import 'package:google_maps/google_maps.dart';

Widget getMap() {
  //A unique id to name the div element
  String htmlId = "6";
  //creates a webview in dart
  //ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
    final latLang = LatLng(12.9007616, 77.6568832);
    //class to create a div element

    final mapOptions = MapOptions()
      ..zoom = 11
      ..tilt = 90
      ..center = latLang;
    final elem = DivElement()
      ..id = htmlId
      ..style.width = "100%"
      ..style.height = "100%"
      ..style.border = "none";

    final map = GMap(elem, mapOptions);
    Marker(MarkerOptions()
      ..position = latLang
      ..map = map
      ..title = 'My position');
    Marker(MarkerOptions()
      ..position = LatLng(12.9557616, 77.7568832)
      ..map = map
      ..title = 'My position');
    return elem;
  });
  //creates a platform view for Flutter Web
  return HtmlElementView(
    viewType: htmlId,
  );
} */

/* import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MapboxMap(
          accessToken:
              'pk.eyJ1IjoiYWJkZWxheml6Y2hhcmZpIiwiYSI6ImNsaWVwbXBzcjA3dHozcHQ0dThja250cWMifQ.ubSfIyvI0EhEqwg9cQJRPw',
          initialCameraPosition: CameraPosition(
            target: LatLng(48.8566, 2.3522),
            zoom: 11.0,
          ),
        ),
      ),
    );
  }
} */

/* import 'package:flutter/material.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps Flutter for Web',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Google Maps Flutter for Web'),
        ),
        body: Center(
          child: Container(
            width: 500,
            height: 500,
            child: GoogleMap(
              initialZoom: 12,
              initialPosition: GeoCoord(45.521563, -122.677433),
              mapType: MapType.roadmap,
              interactive: true,
            ),
          ),
        ),
      ),
    );
  }
}
 */
/* import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'page.dart';

class FullMapPage extends ExamplePage {
  FullMapPage() : super(const Icon(Icons.map), 'Full screen map');

  @override
  Widget build(BuildContext context) {
    return const FullMap();
  }
}

class FullMap extends StatefulWidget {
  const FullMap();

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<FullMap> {
  MapboxMapController? mapController;
  var isLight = true;

  _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  _onStyleLoadedCallback() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Style loaded :)"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(32.0),
          child: FloatingActionButton(
            child: Icon(Icons.swap_horiz),
            onPressed: () => setState(
              () => isLight = !isLight,
            ),
          ),
        ),
        body: MapboxMap(
          styleString: isLight ? MapboxStyles.LIGHT : MapboxStyles.DARK,
          accessToken: 'pk.eyJ1IjoiYWJkZWxheml6Y2hhcmZpIiwiYSI6ImNsaWVwdnpyZTBicmQzZHA2Z2d3YWo3enMifQ.KPZ7B1rpAlcaS1Zb1hAhkQ',
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(target: LatLng(0.0, 0.0)),
          onStyleLoadedCallback: _onStyleLoadedCallback,
        ));
  }
} *//* import 'dart:html';

import 'package:mapbox_gl_dart/mapbox_gl_dart.dart';

late Marker marker;
late HtmlElement coordinates;

void main() {
  Mapbox.accessToken =
      'pk.eyJ1IjoiYW5kcmVhNjg5IiwiYSI6ImNrNGlsYjhyZDBuYXoza213aWphOGNjZmoifQ.maw_5NsXejG1DoOeOi6hlQ';

  coordinates = querySelector('#coordinates') as HtmlElement;
  var map = MapboxMap(
    MapOptions(
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v11',
      center: LngLat(0, 0),
      zoom: 2,
    ),
  );

  marker = Marker(
    MarkerOptions(
      draggable: true,
    ),
  ).setLngLat(LngLat(0, 0)).addTo(map);

  marker.on('dragend', onDragEnd);
}

void onDragEnd(_) {
  var lngLat = marker.getLngLat();
  coordinates.style.display = 'block';
  coordinates.innerHtml =
      'Longitude: ${lngLat.lng}<br />Latitude: ${lngLat.lat}';
} */
/* import 'package:mapbox_gl_dart/mapbox_gl_dart.dart';

void main() {
  Mapbox.accessToken =
      'pk.eyJ1IjoiYW5kcmVhNjg5IiwiYSI6ImNrNGlsYjhyZDBuYXoza213aWphOGNjZmoifQ.maw_5NsXejG1DoOeOi6hlQ';

  MapboxMap(
    MapOptions(
      container: 'map',
      style: 'mapbox://styles/mapbox/dark-v10',
      center: LngLat(7.68227, 45.06755),
      zoom: 12,
    ),
  );
} */