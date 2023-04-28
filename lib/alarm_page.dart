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

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.medicine.name,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    widget.medicine.time,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    widget.medicine.isDaily ? '매일' : widget.medicine.weekdays,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            Switch(
              value: _isAlarmOn,
              onChanged: (value) {
                setState(() {
                  _isAlarmOn = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Medicine {
  final String name;
  final String time;
  final bool isDaily;
  final String weekdays;

  Medicine({
    required this.name,
    required this.time,
    required this.isDaily,
    this.weekdays = '',
  });
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
                style: Theme.of(context).textTheme.subtitle1,
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
                title: const Text('요일별'),
                value: false,
                groupValue: _isDaily,
                onChanged: (value) {
                  setState(() {
                    _isDaily = value!;
                  });
                },
              ),
              if (!_isDaily) ...[
                const SizedBox(height: 16.0),
                Text(
                  '요일 선택',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      CheckboxListTile(
                        title: const Text('월'),
                        value: _weekdays.contains('월'),
                        onChanged: (value) {
                          setState(() {
                            _weekdays = _weekdays.contains('월')
                                ? _weekdays.replaceAll('월', '').trim()
                                : '$_weekdays 월';
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('화'),
                        value: _weekdays.contains('화'),
                        onChanged: (value) {
                          setState(() {
                            _weekdays = _weekdays.contains('화')
                                ? _weekdays.replaceAll('화', '').trim()
                                : '$_weekdays 화';
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('수'),
                        value: _weekdays.contains('수'),
                        onChanged: (value) {
                          setState(() {
                            _weekdays = _weekdays.contains('수')
                                ? _weekdays.replaceAll('수', '').trim()
                                : '$_weekdays 수';
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('목'),
                        value: _weekdays.contains('목'),
                        onChanged: (value) {
                          setState(() {
                            _weekdays = _weekdays.contains('목')
                                ? _weekdays.replaceAll('목', '').trim()
                                : '$_weekdays 목';
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('금'),
                        value: _weekdays.contains('금'),
                        onChanged: (value) {
                          setState(() {
                            _weekdays = _weekdays.contains('금')
                                ? _weekdays.replaceAll('금', '').trim()
                                : '$_weekdays 금';
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('토'),
                        value: _weekdays.contains('토'),
                        onChanged: (value) {
                          setState(() {
                            _weekdays = _weekdays.contains('토')
                                ? _weekdays.replaceAll('토', '').trim()
                                : '$_weekdays 토';
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('일'),
                        value: _weekdays.contains('일'),
                        onChanged: (value) {
                          setState(() {
                            _weekdays = _weekdays.contains('일')
                                ? _weekdays.replaceAll('일', '').trim()
                                : '$_weekdays 일';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newMedicine = Medicine(
                      name: _nameController.text,
                      time: _timeController.text,
                      isDaily: _isDaily,
                      weekdays: _weekdays.trim(),
                    );
                    Navigator.pop(context, newMedicine);
                  }
                },
                child: const Text('추가'),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
