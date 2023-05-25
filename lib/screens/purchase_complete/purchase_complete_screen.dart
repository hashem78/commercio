import 'package:cloud_functions/cloud_functions.dart';
import 'package:commercio/models/location/location.dart';
import 'package:commercio/router/route_names.dart';
import 'package:commercio/state/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PurchaseCompleteScreen extends HookConsumerWidget {
  final ({String uid, SLocation location}) data;
  const PurchaseCompleteScreen({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMounted = useIsMounted();
    ref.listen(
      loadingFutureProvider(const Duration(seconds: 2)),
      (_, next) {
        next.whenData(
          (_) async {
            await FirebaseFunctions.instance.httpsCallable('emptyCart').call({
              "uid": data.uid,
              "location": data.location.toJson(),
            });
            // ignore: use_build_context_synchronously
            if (isMounted()) context.replaceNamed(kHomeRouteName);
          },
        );
      },
    );

    return Scaffold(
      body: Center(
        child: Icon(
          Icons.check,
          size: 100.sp,
          color: Colors.green,
        ),
      ),
    );
  }
}
