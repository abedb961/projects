import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(EventCountdownApp());
}

class EventCountdownApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CountdownHomePage(),
    );
  }
}

class CountdownHomePage extends StatefulWidget {
  @override
  _CountdownHomePageState createState() => _CountdownHomePageState();
}

class _CountdownHomePageState extends State<CountdownHomePage> {
  TextEditingController _eventController = TextEditingController();
  DateTime? _selectedDate;
  String? _eventName;
  Duration? _remainingTime;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _eventController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    if (_selectedDate == null || _eventName == null || _eventName!.isEmpty) {
      return;
    }

    setState(() {
      _remainingTime = _selectedDate!.difference(DateTime.now());
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime = _selectedDate!.difference(DateTime.now());
        if (_remainingTime!.isNegative) {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Countdown Timer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _eventController,
              decoration: InputDecoration(labelText: 'Event Name'),
              onChanged: (value) {
                setState(() {
                  _eventName = value;
                });
              },
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'No date selected'
                        : 'Selected Date: ${_selectedDate.toString().split(' ')[0]}',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                  child: Text('Select Date'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _startCountdown,
                child: Text('Start Countdown'),
              ),
            ),
            SizedBox(height: 40),
            if (_remainingTime != null && !_remainingTime!.isNegative)
              Center(
                child: Text(
                  '${_remainingTime!.inDays} days, ${_remainingTime!.inHours % 24} hours, ${_remainingTime!.inMinutes % 60} minutes, ${_remainingTime!.inSeconds % 60} seconds remaining!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            if (_remainingTime != null && _remainingTime!.isNegative)
              Center(
                child: Text(
                  'The event has passed!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
