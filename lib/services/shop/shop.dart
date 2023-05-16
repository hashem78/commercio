import 'package:commercio/repositories/generic_repository.dart';
import 'package:commercio/models/shop/shop.dart';

class ShopService {
  static Future<void> createShop(SShop shop) async {
    final shopContext = FireStoreContext<SShop>(
      collectionPath: 'users/${shop.ownerId}/shops',
    );
    await shopContext.create(shop);
  }
}
