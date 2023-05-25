import 'dart:convert';

import 'package:commercio/models/shop/shop.dart';
import 'package:commercio/repositories/generic_repository.dart';
import 'package:commercio/screens/shared/scaffold.dart';
import 'package:commercio/state/auth.dart';
import 'package:commercio/state/locale.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

class CreateShopModalDialog extends ConsumerStatefulWidget {
  const CreateShopModalDialog({super.key});

  @override
  ConsumerState<CreateShopModalDialog> createState() =>
      _CreateShopModalDialogState();
}

class _CreateShopModalDialogState extends ConsumerState<CreateShopModalDialog> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStreamProvider).value!;
    final t = ref.watch(translationProvider).translations.createShop;

    return SScaffold.drawerLess(
      title: Text(t.title),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(t.shopNameFieldTitle),
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
                  FormBuilderValidators.minLength(5),
                ],
              ),
              onSubmitted: (newLink) async {
                final isFormValid = _formKey.currentState?.isValid ?? false;
                if (!isFormValid) return;

                final db = FireStoreContext<SShop>(collectionPath: 'shops');
                final name =
                    _formKey.currentState!.fields['name']!.value as String;

                final encodedName = utf8.encode(name.toLowerCase());
                final nameDigest = sha1.convert(encodedName);

                final created = await db.create(
                  SShop(
                    nameDigest.toString().toLowerCase(),
                    user.uid,
                    name,
                  ),
                );
                if (created) {
                  if (mounted) context.pop();
                } else {
                  _formKey.currentState?.fields['name']?.invalidate(
                    'A shop with this name already exists!',
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
