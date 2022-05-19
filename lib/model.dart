class Toko {
  final int? id;
  final String name;

  Toko({this.id, required this.name});

  factory Toko.fromMap(Map<String, dynamic> json) => new Toko(
    id: json['id'],
    name: json['name'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,

    };
  }
}
