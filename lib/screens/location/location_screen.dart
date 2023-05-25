import 'package:commercio/models/location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({
    super.key,
    required this.location,
  });

  final SLocation location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        zoomGesturesEnabled: false,
        scrollGesturesEnabled: false,
        tiltGesturesEnabled: false,
        rotateGesturesEnabled: false,
        zoomControlsEnabled: false,
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: LatLng(location.lat, location.lng),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('initial-location'),
            position: LatLng(location.lat, location.lng),
          )
        },
      ),
    );
  }
}
