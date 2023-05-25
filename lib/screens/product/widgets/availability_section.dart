import 'package:commercio/models/product/product.dart';
import 'package:commercio/screens/product/widgets/titled_section.dart';
import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AvailabilitySection extends ConsumerWidget {
  final String formItemName;
  const AvailabilitySection({
    super.key,
    required this.formItemName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationProvider).translations.product;

    return TitledSection(
      titleText: t.availabilitySectionTitle,
      child: FormBuilderRadioGroup<ProductAvailability>(
        name: formItemName,
        validator: FormBuilderValidators.required(),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        // initialValue: ProductAvailability.inStock,
        orientation: OptionsOrientation.vertical,
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide: BorderSide.none,
          ),
          filled: true,
          contentPadding: EdgeInsets.symmetric(
            vertical: 8,
          ),
        ),
        separator: const Divider(),
        options: [
          FormBuilderFieldOption(
            value: ProductAvailability.inStock,
            child: Text(
              t.inStockAvailabilityText,
              style: TextStyle(fontSize: 55.sp),
            ),
          ),
          FormBuilderFieldOption(
            value: ProductAvailability.outOfStock,
            child: Text(
              t.outOfStockAvailabilityText,
              style: TextStyle(fontSize: 55.sp),
            ),
          )
        ],
      ),
    );
  }
}
