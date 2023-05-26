import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercio/models/product_category/product_category.dart';
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
                final categoryId = nameDigest.toString().toLowerCase();
                final db = FirebaseFirestore.instance;

                final docRef =
                    db.doc('/shops/${widget.shopId}/categories/$categoryId');
                final category = await docRef.get();

                if (category.exists) {
                  _formKey.currentState?.fields['name']?.invalidate(
                    'A category with this name already exists!',
                  );
                  return;
                }

                await docRef.set(
                  ProductCategory(id: categoryId, category: name).toJson(),
                );

                if (mounted) context.pop();
              },
            ),
          ),
        ),
      ],
    );
  }
}
