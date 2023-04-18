import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HospitalSearchPage extends StatefulWidget {
  final String recommendedSpecialistName;

  const HospitalSearchPage({Key? key, required this.recommendedSpecialistName})
      : super(key: key);

  @override
  _HospitalSearchPageState createState() => _HospitalSearchPageState();
}

class _HospitalSearchPageState extends State<HospitalSearchPage> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition? _currentPosition;
  LocationData? _locationData;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionStatus;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {
      _currentPosition = CameraPosition(
        target: LatLng(_locationData!.latitude!, _locationData!.longitude!),
        zoom: 15.0,
      );
    });
  }

  Future<void> _searchHospital() async {
    String apiUrl = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    String location = '${_locationData!.latitude},${_locationData!.longitude}';
    String type = 'hospital';
    String keyword = widget.recommendedSpecialistName;
    String apiKey = 'YOUR_API_KEY_HERE'; // TODO: Google Places API 키 입력
    Uri uri = Uri.parse(
        '$apiUrl?location=$location&type=$type&keyword=$keyword&radius=5000&key=$apiKey');

    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      dynamic jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'OK') {
        List<dynamic> hospitals = jsonResponse['results'];

        // 검색 결과를 지도에 나타내기
        GoogleMapController controller = await _controller.future;
        Set<Marker> markers = Set<Marker>();
        for (dynamic hospital in hospitals) {
          double lat = hospital['geometry']['location']['lat'];
          double lng = hospital['geometry']['location']['lng'];
          String name = hospital['name'];
          Marker marker = Marker(
            markerId: MarkerId(name),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: name),
          );
          markers.add(marker);
        }
        controller.clearMarkers();
        controller.addMarkers(markers.toList());
      } else {
        print('API Error: ${jsonResponse['status']}');
      }
    } else {
      print('HTTP Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('병원 찾기'),
      ),
      body: _currentPosition == null
          ? Center(
        child: CircularProgressIndicator(),
      )
          : GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _currentPosition!,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _searchHospital,
            backgroundColor: Colors.blue,
            child: Icon(Icons.search),
          ),
          SizedBox(height: 16.0),
          FloatingActionButton(
            onPressed: () {
              Navigator.pop(context); // 현재 페이지를 스택에서 제거하고 이전 페이지로 이동
            },
            child: Icon(Icons.arrow_back),
          ),
        ],
      ),
    );
  }
}