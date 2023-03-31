import 'package:flutter/material.dart';
import 'package:workout_log/database/database_manager.dart';
import 'package:workout_log/database/exercise.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Exercise>>(
            future: DatabaseManager.instance.readExercises(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Exercise>> snapshot) {
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
            }),
      ),
    );
  }
}
