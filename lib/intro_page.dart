import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/file_manipulate.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  Widget logo = const Icon(Icons.info, size: 50);
  final String _fileName = "/myimage.jpg";

  void initData() async {
    var dir = await getApplicationDocumentsDirectory();
    var file = File(dir.path + _fileName);
    bool fileExist = await file.exists();
    if (fileExist) {
      setState(() {
        logo = Image.file(file, height: 200, width: 200, fit: BoxFit.contain);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          logo,
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const MyHomePage()));
              },
              child: const Text('다음으로 가기'))
        ],
      ),
    ));
  }
}
