abstract interface class BaseEntity {
  final String id;
  final DateTime? createdOn;

  const BaseEntity(this.id, {this.createdOn});

  Map<String, dynamic> toJson();
}
