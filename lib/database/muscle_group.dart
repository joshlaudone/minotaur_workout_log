class MuscleGroup {
  final int? id;
  final String name;

  MuscleGroup({this.id, required this.name});

  factory MuscleGroup.fromMap(Map<String, dynamic> json) => MuscleGroup(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}
