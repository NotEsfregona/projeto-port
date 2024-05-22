import 'dart:async';
import 'package:appcmdes/screens/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class Map extends StatefulWidget {
  const Map({
    required this.controllerCompleter,
    Key? key,
  }) : super(key: key);

  final Completer<GoogleMapController> controllerCompleter;

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  final MapType _mapType = MapType.hybrid;

  static const CameraPosition _ipsCameraPosition = CameraPosition(
    target: LatLng(38.52225817080751, -8.838708916649127),
    zoom: 16,
  );

  final _markers = <Marker>{
    Marker(
      markerId: const MarkerId('Campo IPS'),
      position: const LatLng(38.51975816618508, -8.835906000285014),
      infoWindow: const InfoWindow(
        title: 'Campo IPS',
        snippet: 'Campo do Instituto Politécnico de Setúbal',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ),
    Marker(
      markerId: const MarkerId('Sala fitness IPS'),
      position: const LatLng(38.519624, -8.835656),
      infoWindow: const InfoWindow(
        title: 'Sala fitness IPS',
        snippet: 'Sala fitness do Instituto Politécnico de Setúbal',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ),
  };

  @override
  void initState() {
    _requestPermission();
    super.initState();
  }

  Future<void> _requestPermission() async {
    await Permission.location.request();
  }

  void _onCameraMove(CameraPosition position) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _ipsCameraPosition,
            mapType: _mapType,
            trafficEnabled: false,
            myLocationEnabled: true,
            markers: _markers,
            onCameraMove: _onCameraMove,
            onMapCreated: (GoogleMapController controller) {
              widget.controllerCompleter.complete(controller);
            },
          ),
          Positioned(
            top: 70, // Moved 30 pixels down from the original position
            left: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const MainPage(),
                  ),
                );
              },
              backgroundColor: Colors.white,
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
