import 'package:flutter/material.dart';
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
