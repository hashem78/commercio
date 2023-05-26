import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercio/models/location/location.dart';
import 'package:commercio/router/router.dart';
import 'package:flutter/material.dart';

class DeliveryLocationsScreenTile extends StatelessWidget {
  const DeliveryLocationsScreenTile({
    super.key,
    required this.location,
    required this.userId,
  });

  final SLocation location;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(location.address),
      subtitle: Text('${location.lat}, ${location.lng}'),
      trailing: IconButton(
        icon: const Icon(
          Icons.close,
          color: Colors.red,
        ),
        onPressed: () async {
          final db = FirebaseFirestore.instance;
          await db
              .doc(
                '/users/$userId/deliveryLocations/${location.id}',
              )
              .delete();
        },
      ),
      onTap: () {
        LocationRoute($extra: location).push(context);
      },
    );
  }
}
