import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FruiteApp extends StatefulWidget {
  const FruiteApp({Key? key}) : super(key: key);

  @override
  _FruiteAppState createState() => _FruiteAppState();
}

class _FruiteAppState extends State<FruiteApp> {
  final String _key = 'first';
  final String _fileName = '/fruits.txt';
  List<String> itemList = List.empty(growable: true);
  TextEditingController? _todoItemController;

  @override
  void initState() {
    super.initState();
    initData();
    _todoItemController = TextEditingController();
  }

  void initData() async {
    try {
      var result = await readListFile();
      print(result);
      setState(() {
        itemList.addAll(result);
      });
    } catch (e) {
      print(e);
    }
  }

  void writeListFile() async {
    var dir = await getApplicationDocumentsDirectory();
    var file = await File(dir.path + _fileName).readAsString();
    file = file + '\n' + _todoItemController!.value.text;
    File(dir.path + _fileName).writeAsStringSync(file);
  }

  Future<List<String>> readListFile() async {
    List<String> itemList = List.empty(growable: true);
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool? firstCheck = pref.getBool(_key);
    var dir = await getApplicationDocumentsDirectory();
    bool fileExist = await File(dir.path + _fileName).exists();
    print(fileExist);

    if (firstCheck == null || firstCheck == false || fileExist == false) {
      pref.setBool(_key, true);
      var file =
          await DefaultAssetBundle.of(context).loadString('assets/fruits.txt');
      File(dir.path + _fileName).writeAsStringSync(file);
      var array = file.split('\n');
      for (var item in array) {
        print(item);
        itemList.add(item);
      }
      return itemList;
    } else {
      var file = await File(dir.path + _fileName).readAsString();
      var array = file.split('\n');
      for (var item in array) {
        print(item);
        itemList.add(item);
      }
      return itemList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('File example')),
      body: Center(
          child: Column(children: [
        TextField(
          controller: _todoItemController,
          keyboardType: TextInputType.text,
        ),
        Expanded(
            child: ListView.builder(
          itemBuilder: (context, index) {
            return Card(
                child: Center(
                    child: Text(itemList[index],
                        style: const TextStyle(fontSize: 30))));
          },
          itemCount: itemList.length,
        ))
      ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
