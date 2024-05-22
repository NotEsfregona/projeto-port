import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map.dart';


class MapPage extends StatelessWidget {
  MapPage({super.key});

  final Completer<GoogleMapController> _controllerCompleter =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Map(controllerCompleter: _controllerCompleter),
    );
  }
}
