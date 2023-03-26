import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:math';

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
              Expanded(
                flex: 1,
                child: Text(
                  "Comment",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(itemBuilder: (_, index) {
              return LogEntry(entryId: index);
            }),
          ),
        ],
      ),
      floatingActionButton: Theme(
        data: Theme.of(context),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class LogEntry extends StatefulWidget {
  final int entryId;
  const LogEntry({super.key, required this.entryId});

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Text(
              "${widget.entryId + 1}",
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              "${Random().nextInt(100) + 50} lbs",
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              "${Random().nextInt(15) + 5} reps",
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              "${(Random().nextInt(11) + 10) / 2.0}",
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () {},
              child: const Icon(Icons.message_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
