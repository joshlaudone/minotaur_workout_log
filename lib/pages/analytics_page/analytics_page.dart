import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_log/database/database_manager.dart';
import 'package:workout_log/database/exercise.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            keyboardType: TextInputType.name,
            textAlign: TextAlign.center,
            controller: myController,
          ),
          ElevatedButton(
            onPressed: () async {
              await DatabaseManager.instance.createExercise(Exercise(
                  name: myController.text,
                  description: 'description',
                  units: Unit.pounds,
                  increment: 5));
            },
            child: Text("Add to db"),
          ),
          Center(
            child: FutureBuilder<List<Exercise>>(
              future: DatabaseManager.instance.readExercises(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Exercise>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: Text('Loading'));
                }
                return ListView(
                  children: snapshot.data!.map((exercise) {
                    return Center(
                      child: ListTile(
                        title: Text(exercise.name),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
