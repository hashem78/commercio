import 'package:commercio/screens/product/widgets/titled_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class TextSection extends StatelessWidget {
  final String formItemName;
  final String titleText;
  final String? hintText;

  const TextSection({
    super.key,
    required this.formItemName,
    required this.titleText,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TitledSection(
      titleText: titleText,
      child: FormBuilderTextField(
        validator: FormBuilderValidators.required(),
        name: formItemName,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide: BorderSide.none,
          ),
          filled: true,
          hintText: hintText,
        ),
      ),
    );
  }
}
