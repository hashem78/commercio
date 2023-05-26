import 'package:commercio/models/location/location.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PickDeliveryLocationTile extends StatelessWidget {
  const PickDeliveryLocationTile({
    super.key,
    required this.location,
  });

  final SLocation location;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(location.address),
      subtitle: Text('${location.lat}, ${location.lng}'),
      onTap: () {
        context.pop<SLocation?>(location);
      },
    );
  }
}
