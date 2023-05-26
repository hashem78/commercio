import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercio/models/product_category/product_category.dart';
import 'package:flutter/material.dart';

class EditCategoryListTile extends StatelessWidget {
  const EditCategoryListTile({
    super.key,
    required this.category,
    required this.shopId,
    this.showBorder = true,
  });

  final ProductCategory category;
  final String shopId;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: showBorder
          ? Border(
              bottom: BorderSide(
                color: Theme.of(context).hintColor,
              ),
            )
          : null,
      title: Text(category.category),
      trailing: IconButton(
        icon: const Icon(
          Icons.close,
          color: Colors.red,
        ),
        onPressed: () async {
          final db = FirebaseFirestore.instance;
          await db.doc('/shops/$shopId/categories/${category.id}').delete();
        },
      ),
    );
  }
}
