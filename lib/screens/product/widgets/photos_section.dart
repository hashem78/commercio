import 'package:commercio/screens/product/widgets/titled_section.dart';
import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PhotosSection extends HookConsumerWidget {
  const PhotosSection({
    super.key,
    required this.formItemName,
  });

  final String formItemName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationProvider).translations.product;

    final showCameraIcon = useState(true);
    return TitledSection(
      titleText: t.productPhotosSectionTitle,
      child: FormBuilderImagePicker(
        name: formItemName,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.minLength(1),
        ]),
        previewHeight: 0.3.sh,
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide: BorderSide.none,
          ),
          filled: true,
        ),
        placeholderWidget: showCameraIcon.value
            ? const Center(
                child: FaIcon(
                  FontAwesomeIcons.camera,
                  color: Colors.blue,
                ),
              )
            : null,
        onChanged: (value) {
          showCameraIcon.value = value?.isEmpty ?? true;
        },
        previewMargin: const EdgeInsetsDirectional.only(end: 5),
      ),
    );
  }
}
