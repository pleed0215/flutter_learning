import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class LargeFile extends StatefulWidget {
  const LargeFile({Key? key}) : super(key: key);

  @override
  _LargeFileState createState() => _LargeFileState();
}

class _LargeFileState extends State<LargeFile> {
  TextEditingController? _fileUrlController;
  bool _downloading = false;
  String progressString = '';
  String file = '';

  @override
  void initState() {
    super.initState();
    _fileUrlController = TextEditingController(
        text:
            'https://images.pexels.com/photos/240040/pexels-photo-240040.jpeg?auto=compress');
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();
    try {
      var dir = await getApplicationDocumentsDirectory();
      var url = _fileUrlController!.value.text;
      await dio.download(url, '${dir.path}/myimage.jpg',
          onReceiveProgress: (rec, total) {
        print('Rec: $rec, Total: $total');
        file = '${dir.path}/myimage.jpg';
        setState(() {
          _downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + '%';
        });
      });
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      _downloading = false;
      progressString = 'Completed';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _fileUrlController,
          keyboardType: TextInputType.text,
        ),
      ),
      body: Center(
        child: _downloading
            ? SizedBox(
                height: 120.0,
                width: 200.0,
                child: Card(
                    color: Colors.black,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 20.0),
                        Text('Downloading File: $progressString',
                            style: const TextStyle(color: Colors.white))
                      ],
                    )))
            : FutureBuilder(
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      print('none');
                      return const Text('No data');
                    case ConnectionState.waiting:
                      print('waiting');
                      return const CircularProgressIndicator();
                    case ConnectionState.active:
                      print('active');
                      return const CircularProgressIndicator();
                    case ConnectionState.done:
                      print('done');
                      return snapshot.data as Widget;
                    default:
                      return const Text('No Data');
                  }
                },
                future: downloadWidget(file)),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            downloadFile();
          },
          child: const Icon(Icons.download)),
    );
  }

  Future<Widget> downloadWidget(String filePath) async {
    File file = File(filePath);
    bool exist = await file.exists();
    FileImage(file).evict();

    if (exist) {
      return Center(
          child: Column(
        children: [Image.file(file)],
      ));
    } else {
      return const Text('No Data');
    }
  }
}
