import 'package:commercio/screens/product/widgets/titled_section.dart';
import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class PriceSection extends ConsumerWidget {
  final String formItemName;
  const PriceSection({
    super.key,
    required this.formItemName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationProvider).translations.product;
    return TitledSection(
      titleText: t.priceSectionTitle,
      child: FormBuilderTextField(
        name: formItemName,
        validator: FormBuilderValidators.required(),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ],
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide: BorderSide.none,
          ),
          filled: true,
          hintText: '\$0.00',
        ),
      ),
    );
  }
}
