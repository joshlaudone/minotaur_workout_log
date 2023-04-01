enum SetType { warmup, normal, half, drop, amrap }

class Set {
  final int? id;
  final int workoutId;
  final int exerciseId;
  final int setNumber;
  final SetType setType;
  final double? weight;
  final int? reps;
  final int? distance;
  final Duration? duration;
  final Duration? restTime;
  final int? rpe;
  final String? comment;

  Set({
    this.id,
    required this.workoutId,
    required this.exerciseId,
    required this.setNumber,
    required this.setType,
    this.weight,
    this.reps,
    this.distance,
    this.duration,
    this.restTime,
    this.rpe,
    this.comment,
  });

  factory Set.fromMap(Map<String, dynamic> json) => Set(
        id: json['id'],
        workoutId: json['workoutId'],
        exerciseId: json['exerciseId'],
        setNumber: json['setNumber'],
        setType: SetType.values[json['setType']],
        weight: json['weight'],
        reps: json['reps'],
        distance: json['distance'],
        duration: json['duration'],
        restTime: json['restTime'],
        rpe: json['rpe'],
        comment: json['comment'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'workoutId': workoutId,
      'exerciseId': exerciseId,
      'setNumber': setNumber,
      'setType': setType.index,
      'weight': weight,
      'reps': reps,
      'distance': distance,
      'duration': duration,
      'restTime': restTime,
      'rpe': rpe,
      'comment': comment,
    };
  }
}
