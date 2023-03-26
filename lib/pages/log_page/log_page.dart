import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  suffixText: "lbs",
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  suffixText: "reps",
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
