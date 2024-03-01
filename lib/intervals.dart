import 'package:flutter/material.dart';
import 'package:scalene/interval_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class IntervalsPage extends StatefulWidget {
  const IntervalsPage({super.key});

  @override
  IntervalsPageState createState() => IntervalsPageState();
}

class IntervalsPageState extends State<IntervalsPage> {
  List<Map<String, String>> intervals = [];
  bool removeMode = false;
  Future<SharedPreferences> getPrefs() async {
    return await SharedPreferences.getInstance();
  }
  updateIntervals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var stringedIntervals = prefs.getString("intervals");
    if (stringedIntervals != null) {
      // JSON decoding won't work because the string is not in JSON format
      // Use the split() method to convert the string to a List<String>
      intervals = List<Map<String, String>>.from(jsonDecode(stringedIntervals).map((item) => Map<String, String>.from(item)));
      setState(() {});
      
  }
}
  @protected
  @mustCallSuper
  @override
  void initState() {
    super.initState();
    updateIntervals();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intervals'),
      ),
      body: ListView.builder(
        itemCount: intervals.length + 1, // Add one for the "Add" button
        itemBuilder: (context, index) {
          if (index == intervals.length) {
            // This is the last item, return the "Add" button
            return ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add new interval'),
              onTap: () async {
                final Map<String, String>? newInterval = await showDialog<Map<String, String>>(
                  context: context,
                  builder: (BuildContext context) {
                    return const IntervalSettings();
                  },
                );

                if (newInterval != null) {
                  setState(() {
                    intervals.add(newInterval);
                  });
                  var stringedIntervals = jsonEncode(intervals);
                  await getPrefs().then((value) => value.setString("intervals", stringedIntervals));
                }
              },
            );
          } else {
            // This is a regular item, return the interval
            final interval = intervals[index];
            return ListTile(
              title: Text(interval['name']!),
              subtitle: Text('${interval['amount']!}\$ ${interval['recurrance']!}'),
              onTap: () {
                if (removeMode) {
                  setState(() {
                    intervals.removeAt(index);
                    removeMode = false;
                    // Save the new intervals list to SharedPreferences
                    var stringedIntervals = jsonEncode(intervals);
                    getPrefs().then((value) => value.setString("intervals", stringedIntervals));
                  });
                }
              }
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            removeMode = !removeMode;
          });
        },
        child: const Icon(Icons.remove),
      )
    );
  }
}