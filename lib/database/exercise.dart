enum Unit { pounds, kilos }

class Exercise {
  final int? id;
  final String name;
  final String description;
  final Unit units;
  final double increment;

  Exercise({
    this.id,
    required this.name,
    required this.description,
    required this.units,
    required this.increment,
  });

  factory Exercise.fromMap(Map<String, dynamic> json) => Exercise(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        units: json['units'] == 'lbs' ? Unit.pounds : Unit.kilos,
        increment: json['increment'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'units': units == Unit.pounds ? 'lbs' : 'kilos',
      'increment': increment,
    };
  }
}
