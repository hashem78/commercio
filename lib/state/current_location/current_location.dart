import 'dart:convert';

import 'package:commercio/models/location/location.dart';
import 'package:commercio/state/locale.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

part 'current_location.g.dart';

const _mapsAPIKey = 'AIzaSyCtGSyelt2aTISAD0rBFOzuveCcpltVTw4';
const _host = 'https://maps.google.com/maps/api/geocode/json';

@riverpod
FutureOr<SLocation> currentLocationFuture(CurrentLocationFutureRef ref) async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.',
    );
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  final position = await Geolocator.getCurrentPosition();

  final locale = ref.watch(
    translationProvider.select((value) => value.locale),
  );
  try {
    final url =
        '$_host?key=$_mapsAPIKey&language=${locale.languageCode}&latlng=${position.latitude},${position.longitude}';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final formattedAddress =
          data["results"][0]["formatted_address"] as String;

      return SLocation(
        id: const Uuid().v4(),
        lat: position.latitude,
        lng: position.longitude,
        address: formattedAddress,
      );
    }
  } catch (_) {
    final placeMarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
      localeIdentifier: locale.languageCode,
    );
    final placeMark = placeMarks.first;

    return SLocation(
      id: const Uuid().v4(),
      lat: position.latitude,
      lng: position.longitude,
      address:
          '${placeMark.name}, ${placeMark.country}, ${placeMark.street}, ${placeMark.administrativeArea}',
    );
  }
  return SLocation(
    id: const Uuid().v4(),
    lat: 31.9539,
    lng: 35.9106,
    address: 'Amman, Jordan',
  );
}
