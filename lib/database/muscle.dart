class Muscle {
  final int? id;
  final String name;

  Muscle({this.id, required this.name});

  factory Muscle.fromMap(Map<String, dynamic> json) => Muscle(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}
