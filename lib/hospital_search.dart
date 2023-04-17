import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HospitalSearchPage extends StatefulWidget {
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
    // TODO: 현재 위치를 기반으로 병원 검색 수행
    // 검색 결과는 검색 결과 페이지로 전달
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