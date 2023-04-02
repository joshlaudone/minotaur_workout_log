import 'package:flutter/material.dart';

import 'package:workout_log/database/database_manager.dart';
import 'package:workout_log/database/session.dart';
import 'package:workout_log/database/workout_set.dart';
import 'package:workout_log/pages/log_page/log_entry.dart';

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Expanded(
                child: Text(
                  "Set",
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  "Weight",
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  "Reps",
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  "RPE",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<WorkoutSet>>(
              future: DatabaseManager.instance.readSets(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<WorkoutSet>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: Text('Loading'));
                }
                return snapshot.data!.isEmpty
                    ? const Center(child: Text('No sets in this workout'))
                    // : Center(child: Text(snapshot.data!.length.toString()));
                    : ListView(
                        padding: const EdgeInsets.only(bottom: 200.0),
                        children: snapshot.data!.map((workoutSet) {
                          return LogEntry(workoutSet: workoutSet);
                        }).toList(),
                      );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Theme(
        data: Theme.of(context),
        child: FloatingActionButton(
          onPressed: () async {
            await DatabaseManager.instance.createSet(WorkoutSet(
              sessionId: 1,
              exerciseId: 1,
              setType: SetType.normal,
            ));
            setState(() {});
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
