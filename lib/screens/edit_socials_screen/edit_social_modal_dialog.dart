import 'package:commercio/models/social_entry/social_entry.dart';
import 'package:commercio/models/user/user_model.dart';
import 'package:commercio/repositories/generic_repository.dart';
import 'package:commercio/screens/shared/scaffold.dart';
import 'package:commercio/state/auth.dart';
import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EditSocialModalDialog extends ConsumerStatefulWidget {
  final String userId;
  final String link;
  final SocialEntryType entryType;
  const EditSocialModalDialog({
    super.key,
    required this.userId,
    required this.entryType,
    required this.link,
  });

  @override
  ConsumerState<EditSocialModalDialog> createState() =>
      _EditSocialModalDialogState();
}

class _EditSocialModalDialogState extends ConsumerState<EditSocialModalDialog> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userStreamProvider(widget.userId)).value!;
    final entryName = toBeginningOfSentenceCase(widget.entryType.name);
    final t = ref.watch(translationProvider).translations.editSocials;

    final enabled = user.socialEntriesMap.containsKey(widget.entryType);

    final subTitle = switch (enabled) {
      true => Text(widget.link, style: const TextStyle(color: Colors.grey)),
      false => Text('$entryName ${t.isNotBeingUsed}'),
    };

    return SScaffold.drawerLess(
      title: Text('${t.title} - $entryName'),
      children: [
        ListTile(
          title: Text(t.oldLink),
          enabled: enabled,
          onTap: () async {
            await launchUrl(Uri.parse(widget.link));
          },
          subtitle: subTitle,
          trailing: switch (enabled) {
            true => IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () async {
                  final dbContext = FireStoreContext<SUser>(
                    collectionPath: 'users',
                  );

                  await dbContext.update(
                    user.copyWith(
                      socialEntriesMap: {
                        ...user.socialEntriesMap,
                      }..remove(widget.entryType),
                    ),
                  );
                },
              ),
            false => const IconButton(
                icon: Icon(Icons.close),
                onPressed: null,
              ),
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FormBuilder(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: FormBuilderTextField(
              autofocus: true,
              name: 'link',
              validator: FormBuilderValidators.url(
                requireProtocol: true,
              ),
              onSubmitted: (newLink) async {
                final isFormValid = _formKey.currentState?.isValid ?? false;
                if (!isFormValid) return;
                final dbContext = FireStoreContext<SUser>(
                  collectionPath: 'users',
                );

                await dbContext.update(
                  user.copyWith(
                    socialEntriesMap: {
                      ...user.socialEntriesMap,
                      widget.entryType: SocialEntry(
                        Uri.parse(newLink!),
                        widget.entryType,
                      ),
                    },
                  ),
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
