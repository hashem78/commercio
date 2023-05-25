import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercio/models/product/product.dart';
import 'package:commercio/models/product_category/product_category.dart';
import 'package:commercio/screens/product/widgets/availability_section.dart';
import 'package:commercio/screens/product/widgets/categories_section.dart';
import 'package:commercio/screens/product/widgets/price_section.dart';
import 'package:commercio/screens/product/widgets/text_section.dart';
import 'package:commercio/screens/shared/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intersperse/intersperse.dart';
import 'package:uuid/uuid.dart';

class EditProductScreen extends StatefulHookConsumerWidget {
  final SProduct product;
  const EditProductScreen({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends ConsumerState<EditProductScreen> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(const Duration(milliseconds: 500));
      formKey.currentState?.patchValue({
        'categories': widget.product.categories,
        'name': widget.product.name,
        'description': widget.product.description,
        'price': widget.product.price.toString(),
        'availability': widget.product.availability,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: SScaffold.drawerLess(
        title: const Text('Add Product'),
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
              final availability =
                  fields['availability']!.value as ProductAvailability;

              final productId = const Uuid().v4();

              final dbDoc = FirebaseFirestore.instance.doc(
                '/shops/${widget.product.shopId}/products/${widget.product.id}',
              );
              await dbDoc.update(
                SProduct(
                  id: productId,
                  shopId: widget.product.shopId,
                  name: name,
                  description: description,
                  price: price,
                  availability: availability,
                  likeCount: widget.product.likeCount,
                  categories: categories,
                  pictures: [...widget.product.pictures],
                ).toJson(),
              );
              if (mounted) context.pop();
            },
            child: const Text('Continue'),
          ),
        ],
        children: <Widget>[
          CategoriesSection(
            shopId: widget.product.shopId,
            formItemName: 'categories',
          ),
          const TextSection(
            formItemName: 'name',
            titleText: 'Name',
            hintText: 'A fancy product name',
          ),
          const TextSection(
            formItemName: 'description',
            titleText: 'Description',
            hintText: 'This product is going to change the world!',
          ),
          const PriceSection(formItemName: 'price'),
          const AvailabilitySection(formItemName: 'availability'),
        ].intersperse(const Divider()).toList(),
      ),
    );
  }
}
