import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const initializationSettingsAndroid =
  AndroidInitializationSettings('app_icon');
  final initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  await FlutterLocalNotificationsPlugin().initialize(initializationSettings);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '약 복용 알림',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AlarmPage(),
    );
  }
}

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _time = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('약 복용시간 알림'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                labelText: '약 복용시간',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '약 복용시간을 입력해주세요.';
                }
                return null;
              },
              onSaved: (value) {
                _time = value!;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _scheduleAlarm(_time);
                }
              },
              child: const Text('알림 설정'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _scheduleAlarm(String time) async {
    final scheduledNotificationDateTime = _nextInstanceOfTime(time);
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'medicine_channel',
      'medicine_channel_name',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alarm_sound'),
    );
    const iOSPlatformChannelSpecifics = IOSNotificationDetails();
    const notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: IOSNotificationDetails(),
    );
    await FlutterLocalNotificationsPlugin().schedule(
      0,
      '약 복용시간입니다.',
      '약을 복용해주세요.',
      scheduledNotificationDateTime,
      notificationDetails,
      androidAllowWhileIdle: true,
    );
  }

  DateTime _nextInstanceOfTime(String time) {
    final now = DateTime.now();
    final scheduledTime = DateTime(now.year, now.month, now.day,
        TimeOfDay.fromDateTime(DateTime.parse(time)).hour,
        TimeOfDay.fromDateTime(DateTime.parse(time)).minute);
    return scheduledTime.isBefore(now)
        ? scheduledTime.add(const Duration(days: 1))
        : scheduledTime;
  }
}