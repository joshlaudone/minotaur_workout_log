import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
  Future<List<WorkoutSet>> currentSets = DatabaseManager.instance.readSets();

  void refreshSets() {
    currentSets = DatabaseManager.instance.readSets();
  }

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
          Expanded(child: scrollableLog(context)),
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
            setState(() {
              refreshSets();
            });
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget scrollableLog(BuildContext context) {
    return FutureBuilder<List<WorkoutSet>>(
      future: currentSets,
      builder:
          (BuildContext context, AsyncSnapshot<List<WorkoutSet>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: Text('Loading'));
        }
        return snapshot.data!.isEmpty
            ? const Center(child: Text('No sets in this workout'))
            // : Center(child: Text(snapshot.data!.length.toString()));
            : ListView.builder(
                itemCount: snapshot.data!.length,
                padding: const EdgeInsets.only(bottom: 200.0),
                itemBuilder: (context, index) {
                  WorkoutSet workoutSet = snapshot.data!.elementAt(index);
                  return Slidable(
                    key: Key(index.toString()),
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
                          onPressed: (context) {
                            DatabaseManager.instance.deleteSet(workoutSet.id!);
                            setState(() {
                              refreshSets();
                            });
                          },
                          icon: Icons.delete_rounded,
                          label: 'Delete',
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ],
                    ),
                    child: LogEntry(workoutSet: workoutSet),
                  );
                },
              );
      },
    );
  }
}
