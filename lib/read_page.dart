import 'package:flutter/material.dart';

class ReadPage extends StatefulWidget {
  const ReadPage({Key? key}) : super(key: key);

  @override
  _ReadPageState createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  List<HealthRecord> healthRecords = [
    HealthRecord(
      date: '2023-05-20',
      summary: '과로로 인한 두통',
      details: '과로로 인해 머리가 아프고 지침',
    ),
    HealthRecord(
      date: '2023-05-19',
      summary: '운동 후 근육통',
      details: '운동을 하고 나서 근육통이 생김',
    ),
    HealthRecord(
      date: '2023-05-18',
      summary: '식도염으로 인한 속 쓰림',
      details: '식도염으로 인해 속이 쓰림',
    ),
    HealthRecord(
      date: '2023-05-17',
      summary: '눈 건조',
      details: '컴퓨터 작업으로 인해 눈이 건조해짐',
    ),
    HealthRecord(
      date: '2023-05-16',
      summary: '수면 부족',
      details: '어제 밤에 잠을 제대로 못 잠',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff5CCFD4),
        title: Text(
          '건강일지 목록',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: healthRecords.length,
          itemBuilder: (context, index) {
            final healthRecord = healthRecords[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 2.0,
              child: ListTile(
                title: Text(
                  healthRecord.date,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                subtitle: Text(
                  healthRecord.summary,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        healthRecord.date,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      content: Text(
                        healthRecord.details,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('닫기'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class HealthRecord {
  final String date;
  final String summary;
  final String details;

  HealthRecord({
    required this.date,
    required this.summary,
    required this.details,
  });
}