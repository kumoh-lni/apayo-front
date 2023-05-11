import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  String? _selectedGender;
  int? _selectedBirthYear;

  // 출생년도 선택용 드롭다운 메뉴에 사용될 아이템 리스트
  final _birthYearList = List.generate(100, (index) => 2022 - index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('회원가입'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _idController,
                    decoration: InputDecoration(
                      labelText: '아이디',
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return '아이디를 입력하세요';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: '비밀번호',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return '비밀번호를 입력하세요';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: '비밀번호 확인',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return '비밀번호 확인을 입력하세요';
                      }
                      if (value != _passwordController.text) {
                        return '비밀번호가 일치하지 않습니다';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: '이름',
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return '이름을 입력하세요';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  DropdownButtonFormField<int>(
                    value: _selectedBirthYear,
                    items: _birthYearList.map((year) {
                      return DropdownMenuItem<int>(
                        value: year,
                        child: Text('$year년'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBirthYear = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: '출생년도',
                    ),
                    validator: (value) {
                      if (value == null) {
                        return '출생년도를 선택하세요';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    items: ['남성', '여성']
                        .map((label) => DropdownMenuItem(
                      child: Text(label),
                      value: label,
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: '성별',
                    ),
                    validator: (value) {
                      if (value == null) {
                        return '성별을 선택하세요';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32.0),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff5CCFD4), // 버튼 색상 설정
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true) {
                          // 회원가입 로직 처리
                        }
                      },
                      child: Text('회원가입'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}