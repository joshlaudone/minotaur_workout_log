class Session {
  final int? id;
  final String name;

  Session({this.id, required this.name});

  factory Session.fromMap(Map<String, dynamic> json) => Session(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}
