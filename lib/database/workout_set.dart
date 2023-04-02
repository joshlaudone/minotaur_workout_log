enum SetType { warmup, normal, half, drop, amrap }

class WorkoutSet {
  int? id;
  int sessionId;
  int exerciseId;
  int? setNumber;
  SetType setType;
  double? weight;
  int? reps;
  int? distance;
  Duration? duration;
  Duration? restTime;
  double? rpe;
  String? comment;

  WorkoutSet({
    this.id,
    required this.sessionId,
    required this.exerciseId,
    this.setNumber,
    required this.setType,
    this.weight,
    this.reps,
    this.distance,
    this.duration,
    this.restTime,
    this.rpe,
    this.comment,
  });

  factory WorkoutSet.fromMap(Map<String, dynamic> json) => WorkoutSet(
        id: json['id'],
        sessionId: json['sessionId'],
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
      'sessionId': sessionId,
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
