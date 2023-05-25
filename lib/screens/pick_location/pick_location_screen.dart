import 'package:commercio/models/location/location.dart';
import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:map_location_picker/map_location_picker.dart';

class PickLocationScreen extends ConsumerWidget {
  final SLocation? initialLocation;
  const PickLocationScreen({
    super.key,
    this.initialLocation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationProvider);
    return Scaffold(
      body: MapLocationPicker(
        apiKey: "AIzaSyCtGSyelt2aTISAD0rBFOzuveCcpltVTw4",
        currentLatLng: switch (initialLocation) {
          null => null,
          _ => LatLng(initialLocation!.lng, initialLocation!.lat),
        },
        showBackButton: false,
        showMoreOptions: false,
        padding: EdgeInsets.zero,
        language: t.locale.languageCode,
        topCardMargin: EdgeInsets.zero,
        topCardShape: const RoundedRectangleBorder(),
        borderRadius: BorderRadius.zero,
        bottomCardMargin: EdgeInsets.zero,
        bottomCardShape: const RoundedRectangleBorder(),
        searchHintText: t.translations.general.startTypingToSearch,
        
        bottomCardTooltip: t.translations.general.tapOnMapToGetAddress,
        onNext: (GeocodingResult? result) {
          if (result == null) return;

          context.pop(
            SLocation(
              lat: result.geometry.location.lat,
              lng: result.geometry.location.lng,
              address: result.formattedAddress!,
            ),
          );
        },
      ),
    );
  }
}
