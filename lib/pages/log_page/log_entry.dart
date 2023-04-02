import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:workout_log/database/database_manager.dart';
import 'package:workout_log/database/workout_set.dart';

class LogEntry extends StatefulWidget {
  final WorkoutSet workoutSet;
  const LogEntry({super.key, required this.workoutSet});

  @override
  State<LogEntry> createState() => _LogEntryState();
}

class _LogEntryState extends State<LogEntry> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {},
            icon: Icons.message_rounded,
            label: 'Comment',
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          SlidableAction(
            onPressed: (context) {},
            icon: Icons.add,
            label: 'Add',
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {},
            icon: Icons.delete_rounded,
            label: 'Delete',
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ],
      ),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Text(
                "${widget.workoutSet.id!}",
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: widget.workoutSet.weight == null
                      ? ""
                      : widget.workoutSet.weight.toString(),
                  decoration: const InputDecoration(
                    suffixText: "lbs",
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                  ],
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    widget.workoutSet.weight = double.tryParse(value);
                    DatabaseManager.instance.updateSet(widget.workoutSet);
                    setState(() {});
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: widget.workoutSet.reps == null
                      ? ""
                      : widget.workoutSet.reps.toString(),
                  decoration: const InputDecoration(
                    suffixText: "reps",
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    widget.workoutSet.reps = int.tryParse(value);
                    DatabaseManager.instance.updateSet(widget.workoutSet);
                    setState(() {});
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: widget.workoutSet.rpe == null
                      ? ""
                      : widget.workoutSet.rpe.toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                  ],
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    widget.workoutSet.rpe = double.tryParse(value);
                    DatabaseManager.instance.updateSet(widget.workoutSet);
                    setState(() {});
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
