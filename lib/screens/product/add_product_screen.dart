import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercio/models/product/product.dart';
import 'package:commercio/models/product_category/product_category.dart';
import 'package:commercio/models/profile_picture/picture.dart';
import 'package:commercio/screens/product/widgets/availability_section.dart';
import 'package:commercio/screens/product/widgets/categories_section.dart';
import 'package:commercio/screens/product/widgets/text_section.dart';
import 'package:commercio/screens/product/widgets/photos_section.dart';
import 'package:commercio/screens/product/widgets/price_section.dart';
import 'package:commercio/screens/shared/scaffold.dart';
import 'package:commercio/state/locale.dart';
import 'package:cross_file/cross_file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:intersperse/intersperse.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

class AddProductScreen extends StatefulHookConsumerWidget {
  final String shopId;
  const AddProductScreen({
    super.key,
    required this.shopId,
  });

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(translationProvider).translations.product;
    return FormBuilder(
      key: formKey,
      child: SScaffold.drawerLess(
        title: Text(t.addProductTitle),
        actions: [
          TextButton(
            onPressed: () async {
              final isValid = formKey.currentState?.validate() ?? false;

              if (!isValid) return;

              final fields = formKey.currentState!.fields;

              if (!fields.containsKey('categories')) return;

              final categories = List<ProductCategory>.from(
                fields['categories']?.value ?? [],
              );

              if (categories.isEmpty) {
                formKey.currentState!.fields['categories']?.invalidate(
                  'Pick at least one category',
                );
              }
              final name = fields['name']!.value as String;
              final description = fields['description']!.value as String;
              final price = double.parse(fields['price']!.value);
              final photos = List<XFile>.from(fields['photos']?.value ?? []);
              final availability =
                  fields['availability']!.value as ProductAvailability;

              final db = FirebaseFirestore.instance;
              final docRef = db.doc('/shops/${widget.shopId}/products');

              final productId = const Uuid().v4();
              final storage = FirebaseStorage.instance;

              final pictures = <SPicture>[];

              for (final photo in photos) {
                final storageRef = storage.ref(
                  '/shops/${widget.shopId}/product/$productId/photos/${photo.name}',
                );
                final bytes = await photo.readAsBytes();
                final size = ImageSizeGetter.getSize(MemoryInput(bytes));
                await storageRef.putData(bytes);
                final url = await storageRef.getDownloadURL();
                pictures.add(
                  SPicture(
                    link: url,
                    width: size.width,
                    height: size.height,
                  ),
                );
              }
              await docRef.set(
                SProduct(
                  id: productId,
                  shopId: widget.shopId,
                  name: name,
                  description: description,
                  price: price,
                  availability: availability,
                  pictures: pictures,
                  categories: categories,
                  likeCount: 0,
                ).toJson(),
              );
              if (mounted) context.pop();
            },
            child: Text(t.createButtonText),
          ),
        ],
        children: <Widget>[
          CategoriesSection(
            shopId: widget.shopId,
            formItemName: 'categories',
          ),
          TextSection(
            formItemName: 'name',
            titleText: t.nameSectionTitle,
            hintText: t.nameHintText,
          ),
          TextSection(
            formItemName: 'description',
            titleText: t.descriptionSectionTtile,
            hintText: t.descriptionSectionTtile,
          ),
          const PriceSection(formItemName: 'price'),
          const PhotosSection(formItemName: 'photos'),
          const AvailabilitySection(formItemName: 'availability'),
        ].intersperse(const Divider()).toList(),
      ),
    );
  }
}
