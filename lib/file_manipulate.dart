import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final String _key = 'count';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _setData() async {
    var pref = await SharedPreferences.getInstance();
    pref.setInt(_key, _counter);
  }

  void _loadData() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      var value = pref.getInt(_key);
      if (value == null) {
        _counter = 0;
      } else {
        _counter = value;
      }
    });
  }

  void _onTabCounterAdd() {
    setState(() {
      _counter++;
      _setData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SharedPreferred Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You counter is now'),
            Text('$_counter', style: const TextStyle(fontSize: 24.0)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTabCounterAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyWriteFile extends StatefulWidget {
  const MyWriteFile({Key? key}) : super(key: key);

  @override
  _MyWriteFileState createState() => _MyWriteFileState();
}

class _MyWriteFileState extends State<MyWriteFile> {
  int _counter = 0;
  final String _fileName = '/count.txt';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _setData() async {
    var dir = await getApplicationDocumentsDirectory();
    File(dir.path + _fileName).writeAsStringSync(_counter.toString());
  }

  void _loadData() async {
    try {
      var dir = await getApplicationDocumentsDirectory();
      var file = await File(dir.path + _fileName).readAsString();
      print(file);
      setState(() {
        _counter = int.parse(file);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _onTabCounterAdd() {
    setState(() {
      _counter++;
      _setData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SharedPreferred Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You counter is now'),
            Text('$_counter', style: const TextStyle(fontSize: 24.0)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTabCounterAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}
