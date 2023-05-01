import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
class Medicine {
  final String name;
  final String time;
  final bool isDaily;
  final String weekdays;

  Medicine({
    required this.name,
    required this.time,
    required this.isDaily,
    required this.weekdays,
  });
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const initializationSettingsAndroid =
  AndroidInitializationSettings('app_icon');
  final initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

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
      home: const MedicineListPage(),
    );
  }
}

class MedicineListPage extends StatefulWidget {
  const MedicineListPage({Key? key}) : super(key: key);

  @override
  _MedicineListPageState createState() => _MedicineListPageState();
}

class _MedicineListPageState extends State<MedicineListPage> {
  List<Medicine> _medicines = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('약 복용 알림'),
      ),
      body: _medicines.isEmpty
          ? const Center(
        child: Text('복용 약이 없습니다.'),
      )
          : ListView.builder(
        itemCount: _medicines.length,
        itemBuilder: (context, index) {
          return MedicineCard(medicine: _medicines[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newMedicine = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const RegisterMedicinePage()),
          );
          if (newMedicine != null) {
            setState(() {
              _medicines.add(newMedicine);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MedicineCard extends StatefulWidget {
  final Medicine medicine;

  const MedicineCard({Key? key, required this.medicine}) : super(key: key);

  @override
  _MedicineCardState createState() => _MedicineCardState();
}

class _MedicineCardState extends State<MedicineCard> {
  bool _isAlarmOn = true;

  // 알람 설정 메서드 추가
  Future<void> _setAlarm(Medicine medicine) async {
    final now = DateTime.now();
    final timeParts = medicine.time.split(':');
    final alarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'medicine_alarm',
      'Medicine Alarm',
      importance: Importance.max,
      priority: Priority.high,
    );

    final platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    int id = DateTime
        .now()
        .millisecondsSinceEpoch ~/ 1000;
    MatchDateTimeComponents matchDateTimeComponents =
    medicine.isDaily ? MatchDateTimeComponents.time : MatchDateTimeComponents
        .dayOfWeekAndTime;
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Medicine Reminder',
      'Time to take your medicine!',
      TZDateTime.from(alarmTime, LocalData.defaultTimeZone),
      platformChannelSpecifics,
      uiLocalNotification,
      androidAllowWhileIdle: true,
      payload: medicine.name,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: matchDateTimeComponents,
    );
  }

  // 알람 해제 메서드 추가
  Future<void> _cancelAlarm(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.medical_services),
        title: Text(widget.medicine.name),
        subtitle: Text('복용 시간: ${widget.medicine.time}'),
        trailing: Switch(
          value: _isAlarmOn,
          onChanged: (value) async {
            setState(() {
              _isAlarmOn = value;
            });
            if (_isAlarmOn) {
              await _setAlarm(widget.medicine);
            } else {
              await _cancelAlarm(DateTime
                  .now()
                  .millisecondsSinceEpoch ~/ 1000);
            }
          },
        ),
      ),
    );
  }
}

class RegisterMedicinePage extends StatefulWidget {
  const RegisterMedicinePage({Key? key}) : super(key: key);

  @override
  _RegisterMedicinePageState createState() => _RegisterMedicinePageState();
}

class _RegisterMedicinePageState extends State<RegisterMedicinePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  bool _isDaily = true;
  String _weekdays = '';

  @override
  void dispose() {
    _nameController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새로운 약 추가'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: '약 이름',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '약 이름을 입력해주세요.';
                    }
                    return null;
                  },
                  controller: _nameController,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: '복용시간 (예: 09:00)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '복용시간을 입력해주세요.';
                    }
                    final pattern = r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$';
                    final regExp = RegExp(pattern);
                    if (!regExp.hasMatch(value)) {
                      return '올바른 시간 형식을 입력해주세요. (예: 09:00)';
                    }
                    return null;
                  },
                  controller: _timeController,
                ),
                const SizedBox(height: 16.0),
                Text(
                  '복용 주기',
                  style: Theme
                      .of(context)
                      .textTheme
                      .subtitle1,
                ),
                RadioListTile<bool>(
                  title: const Text('매일'),
                  value: true,
                  groupValue: _isDaily,
                  onChanged: (value) {
                    setState(() {
                      _isDaily = value!;
                      _weekdays = '';
                    });
                  },
                ),
                RadioListTile<bool>(
                  title: const Text('특정 요일'),
                  value: false,
                  groupValue: _isDaily,
                  onChanged: (value) {
                    setState(() {
                      _isDaily = value!;
                    });
                    _showWeekdaysDialog();
                  },
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    child: const Text('저장'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final newMedicine = Medicine(
                          name: _nameController.text,
                          time: _timeController.text,
                          isDaily: _isDaily,
                          weekdays: _weekdays,
                        );
                        Navigator.pop(context, newMedicine);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showWeekdaysDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final bool monday = _weekdays.contains('월');
        final bool tuesday = _weekdays.contains('화');
        final bool wednesday = _weekdays.contains('수');
        final bool thursday = _weekdays.contains('목');
        final bool friday = _weekdays.contains('금');
        final bool saturday = _weekdays.contains('토');
        final bool sunday = _weekdays.contains('일');
        return AlertDialog(
          title: const Text('복용 요일 선택'),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CheckboxListTile(
                title: const Text('월요일'),
                value: monday,
                onChanged: (value) {
                  setState(() {
                    _weekdays = _updateWeekdays('월', value!);
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('화요일'),
                value: tuesday,
                onChanged: (value) {
                  setState(() {
                    _weekdays = _updateWeekdays('화', value!);
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('수요일'),
                value: wednesday,
                onChanged: (value) {
                  setState(() {
                    _weekdays = _updateWeekdays('수', value!);
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('목요일'),
                value: thursday,
                onChanged: (value) {
                  setState(() {
                    _weekdays = _updateWeekdays('목', value!);
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('금요일'),
                value: friday,
                onChanged: (value) {
                  setState(() {
                    _weekdays = _updateWeekdays('금', value!);
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('토요일'),
                value: saturday,
                onChanged: (value) {
                  setState(() {
                    _weekdays = _updateWeekdays('토', value!);
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('일요일'),
                value: sunday,
                onChanged: (value) {
                  setState(() {
                    _weekdays = _updateWeekdays('일', value!);
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('완료'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  String _updateWeekdays(String day, bool value) {
    if (value) {
      return '${_weekdays} $day';
    } else {
      return _weekdays.replaceAll(day, '');
    }
  }

}