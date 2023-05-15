import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class BaseEntity {
  final String id;

  const BaseEntity(this.id);

  Map<String, dynamic> toJson();
}

abstract interface class DbContext<T extends BaseEntity> {
  Future<void> create(BaseEntity entity);
  Future<List<T>> get();
  Future<T?> getById(String id, T Function(Map<String, dynamic> map) fromJson);
  Future<void> update(BaseEntity entity);
  Future<void> delete(String id);
}

class FireStoreContext<T extends BaseEntity> extends DbContext<T> {
  final FirebaseFirestore firestore;
  final String collectionPath;
  FireStoreContext({
    FirebaseFirestore? firestore,
    required this.collectionPath,
  }) : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> delete(String id) async {
    await firestore.collection(collectionPath).doc(id).delete();
  }

  @override
  Future<List<T>> get() async {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<T?> getById(
    String id,
    T Function(Map<String, dynamic> map) fromJson,
  ) async {
    final snap = await firestore.collection(collectionPath).doc(id).get();
    if (snap.data() == null) {
      return null;
    }
    return fromJson(snap.data()!);
  }

  @override
  Future<void> update(BaseEntity entity) async {
    await firestore
        .collection(collectionPath)
        .doc(entity.id)
        .update(entity.toJson());
  }

  @override
  Future<void> create(BaseEntity entity) async {
    await firestore
        .collection(collectionPath)
        .doc(entity.id)
        .set(entity.toJson());
  }
}
