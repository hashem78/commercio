import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class BaseEntity {
  final String id;
  final DateTime? createdOn;

  const BaseEntity(this.id, {this.createdOn});

  Map<String, dynamic> toJson();
}

abstract interface class DbContext<T extends BaseEntity> {
  Future<bool> create(BaseEntity entity);
  Future<List<T>> get();
  Future<List<T>> getLimited({
    required String orderBy,
    BaseEntity? startAfter,
    int limit = 10,
    required T Function(Map<String, dynamic> map) fromJson,
  });
  Future<List<T>> getAfter({
    required String orderBy,
    required BaseEntity startAfter,
    int limit = 10,
    required T Function(Map<String, dynamic> map) fromJson,
  });
  Future<T?> getById(String id, T Function(Map<String, dynamic> map) fromJson);
  Future<void> update(BaseEntity entity);
  Future<void> delete(String id);
}

abstract interface class StreamableDbContext<T extends BaseEntity>
    implements DbContext<T> {
  Stream<T?> trackDocumentById(
    String id,
    T Function(Map<String, dynamic> map) fromJson,
  );
  Stream<EntityChange<T>> trackCollection(
    T Function(Map<String, dynamic> map) fromJson,
  );
}

class FireStoreContext<T extends BaseEntity> extends StreamableDbContext<T> {
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
  Future<bool> create(BaseEntity entity) async {
    final json = entity.toJson();
    json["createdOn"] = FieldValue.serverTimestamp();
    final doc = firestore.collection(collectionPath).doc(entity.id);
    return firestore.runTransaction(
      (transaction) async {
        final snapshot = await transaction.get(doc);
        if (!snapshot.exists) {
          transaction.set(doc, json);
          return true;
        }
        return false;
      },
    );
  }

  @override
  Stream<T?> trackDocumentById(
      String id, T Function(Map<String, dynamic> map) fromJson) async* {
    final changes = firestore.collection(collectionPath).doc(id).snapshots();
    await for (final change in changes) {
      final data = change.data();
      yield data == null ? null : fromJson(data);
    }
  }

  @override
  Stream<EntityChange<T>> trackCollection(
    T Function(Map<String, dynamic> map) fromJson,
  ) async* {
    final changes = firestore.collection(collectionPath).snapshots();
    await for (final change in changes) {
      for (final docSnap in change.docChanges) {
        final data = docSnap.doc.data();
        final entity = data == null ? null : fromJson(data);
        yield EntityChange(entity, _mapChangeType(docSnap.type));
      }
    }
  }

  EntityChangeType _mapChangeType(DocumentChangeType changeType) {
    return switch (changeType) {
      DocumentChangeType.added => EntityChangeType.added,
      DocumentChangeType.removed => EntityChangeType.removed,
      DocumentChangeType.modified => EntityChangeType.modified,
    };
  }

  @override
  Future<List<T>> getLimited({
    required String orderBy,
    BaseEntity? startAfter,
    int limit = 10,
    required T Function(Map<String, dynamic> map) fromJson,
  }) async {
    final snap = await firestore
        .collection(collectionPath)
        .orderBy(orderBy)
        .limit(limit)
        .get();
    final list = <T>[];
    for (final doc in snap.docs) {
      list.add(fromJson(doc.data()));
    }
    return list;
  }

  @override
  Future<List<T>> getAfter({
    required String orderBy,
    required BaseEntity startAfter,
    int limit = 10,
    required T Function(Map<String, dynamic> map) fromJson,
  }) async {
    final snap = await firestore
        .collection(collectionPath)
        .startAfter([Timestamp.fromDate(startAfter.createdOn!)])
        .orderBy(orderBy)
        .limit(limit)
        .get();
    final list = <T>[];
    for (final doc in snap.docs) {
      list.add(fromJson(doc.data()));
    }
    return list;
  }
}

enum EntityChangeType { modified, added, removed }

class EntityChange<T extends BaseEntity> {
  final T? entity;
  final EntityChangeType changeType;

  const EntityChange(this.entity, this.changeType);
}
