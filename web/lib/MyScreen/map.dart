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
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_maps/google_maps.dart';
import 'dart:ui' as ui;

class GoogleMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String htmlId = "7";

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      final myLatlng = LatLng(1.3521, 103.8198);

      // another location
      final myLatlng2 = LatLng(1.4521, 103.9198);

      final mapOptions = MapOptions()
        ..zoom = 10
        ..center = LatLng(1.3521, 103.8198);

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
    '</div>';
