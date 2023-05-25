import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitledSection extends StatelessWidget {
  const TitledSection({
    super.key,
    this.titleText,
    required this.child,
    this.title,
  }) : assert(
          (titleText == null && title != null) ||
              (titleText != null && title == null),
          "title and titleText are mutually exclusive",
        );

  final Widget? title;
  final String? titleText;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title ??
              Text(
                titleText!,
                style: TextStyle(
                  fontSize: 70.sp,
                ),
              ),
          5.verticalSpace,
          child,
        ],
      ),
    );
  }
}
