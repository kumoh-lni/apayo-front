import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'hospital_search.dart'; // 이전에 작성한 HospitalSearchPage 코드 임포트

class WritePage extends StatefulWidget {
  const WritePage({Key? key}) : super(key: key);

  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('건강일지 작성'),
      ),
      body: Container(
        // 건강일지 작성 페이지의 내용을 작성
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HospitalSearchPage(recommendedSpecialistName: '학교'),
            ),
          );
        },
        child: const Icon(Icons.map),
      ),
    );
  }
}
