// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:commercio/models/product_category/product_category.dart';
import 'package:commercio/router/router.dart';
import 'package:commercio/screens/product/widgets/titled_section.dart';
import 'package:commercio/screens/shared/utility_widgets.dart';
import 'package:commercio/state/product_category/product_category.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CategoriesSection extends ConsumerWidget {
  final String shopId;
  final String formItemName;
  const CategoriesSection({
    Key? key,
    required this.shopId,
    required this.formItemName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationProvider).translations;

    return TitledSection(
      title: Row(
        children: [
          Text(
            t.product.catergoriesSectionTitle,
            style: TextStyle(fontSize: 70.sp),
          ),
          IconButton(
            onPressed: () {
              EditCategoriesRoute(shopId).push(context);
            },
            tooltip: t.general.editButtonToolTipText,
            icon: const Icon(
              Icons.edit,
              color: Colors.green,
            ),
          )
        ],
      ),
      child: _EditProductCategories(
        shopId: shopId,
        formItemName: formItemName,
      ),
    );
  }
}

class _EditProductCategories extends ConsumerWidget {
  const _EditProductCategories({
    // ignore: unused_element
    super.key,
    required this.shopId,
    required this.formItemName,
  });

  final String shopId;
  final String formItemName;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsyncValue = ref.watch(
      productCategoryStreamProvider(shopId),
    );
    final t = ref.watch(translationProvider).translations.editCategories;
    return categoriesAsyncValue.when(
      data: (categories) {
        return switch (categories.isEmpty) {
          true => Center(child: Text(t.editCatergoriesNoCategoriesText)),
          false => FormBuilderFilterChip<ProductCategory>(
              name: formItemName,
              validator: FormBuilderValidators.required(),
              shape: const StadiumBorder(),
              options: categories
                  .map(
                    (e) => FormBuilderChipOption<ProductCategory>(
                      value: e,
                      child: Text(e.category),
                    ),
                  )
                  .toList(),
              selectedColor: Colors.blueGrey,
              spacing: 6.0,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
            ),
        };
      },
      loading: () => loadingWidget(
        const Size(double.infinity, 300),
      ),
      error: errorWidget,
    );
  }
}
