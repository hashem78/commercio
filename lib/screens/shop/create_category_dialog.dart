import 'dart:convert';

import 'package:commercio/models/product_category/product_category.dart';
import 'package:commercio/repositories/generic_repository.dart';
import 'package:commercio/screens/shared/scaffold.dart';
import 'package:commercio/state/locale.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

class CreateCategoryDialog extends ConsumerStatefulWidget {
  final String shopId;
  const CreateCategoryDialog({
    super.key,
    required this.shopId,
  });

  @override
  ConsumerState<CreateCategoryDialog> createState() =>
      _AddCategoryDialogState();
}

class _AddCategoryDialogState extends ConsumerState<CreateCategoryDialog> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    final t = ref.watch(translationProvider).translations.editCategories;
    return SScaffold.drawerLess(
      title: Text(t.title),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(t.categoryNameFieldNameText),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FormBuilder(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: FormBuilderTextField(
              autofocus: true,
              autovalidateMode: AutovalidateMode.always,
              name: 'name',
              keyboardType: TextInputType.name,
              inputFormatters: [
                FilteringTextInputFormatter.singleLineFormatter,
                FilteringTextInputFormatter.allow(
                  RegExp(r"[\u0621-\u064Aa-zA-Z\s\']"),
                ),
              ],
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(3),
                ],
              ),
              onSubmitted: (newLink) async {
                final isFormValid = _formKey.currentState?.isValid ?? false;
                if (!isFormValid) return;

                final name =
                    _formKey.currentState!.fields['name']!.value as String;

                final encodedName = utf8.encode(name.toLowerCase());
                final nameDigest = sha1.convert(encodedName);
                final db = FireStoreContext<ProductCategory>(
                  collectionPath: '/shops/${widget.shopId}/categories',
                );

                final created = await db.create(
                  ProductCategory(
                    id: nameDigest.toString().toLowerCase(),
                    category: name,
                  ),
                );
                if (created) {
                  if (mounted) context.pop();
                } else {
                  _formKey.currentState?.fields['name']?.invalidate(
                    'A category with this name already exists!',
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
