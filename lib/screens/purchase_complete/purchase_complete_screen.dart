import 'package:cloud_functions/cloud_functions.dart';
import 'package:commercio/router/route_names.dart';
import 'package:commercio/state/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PurchaseCompleteScreen extends HookConsumerWidget {
  final String uid;
  const PurchaseCompleteScreen({
    super.key,
    required this.uid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMounted = useIsMounted();
    ref.listen(
      loadingFutureProvider(const Duration(seconds: 2)),
      (_, next) {
        next.whenData(
          (_) async {
            FirebaseFunctions.instance
                .httpsCallable('emptyCart')
                .call({"uid": uid});
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
