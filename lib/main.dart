// main.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catchline',
      home: HomePage(),
      theme: new ThemeData(
        primarySwatch: Colors.green,
        primaryTextTheme:
            TextTheme(headline6: TextStyle(color: Colors.white70)),
        scaffoldBackgroundColor: new Color(0x999999),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // This will be displayed on the screen
  String _content;

  // TextField controller
  final _textController = TextEditingController();

  @override
  void initState() {
    _readData();
    super.initState();
  }

  // Find the Documents path
  Future<String> _getDirPath() async {
    final _dir = await getApplicationDocumentsDirectory();
    return _dir.path;
  }

  // This function is triggered when the "Read" button is pressed
  Future<void> _readData() async {
    final _dirPath = await _getDirPath();
    final _myFile = File('$_dirPath/data.txt');
    final _data = await _myFile.readAsString(encoding: utf8);
    setState(() {
      _content = _data;
    });
  }

  // This function is triggered when the "Write" buttion is pressed
  Future<void> _writeData() async {
    final _dirPath = await _getDirPath();

    final _myFile = File('$_dirPath/data.txt');
    // If data.txt doesn't exist, it will be created automatically

    final _data = await _myFile.readAsString(encoding: utf8);
    await _myFile.writeAsString(_textController.text + '\n' + _data);
    _textController.clear();
    _readData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prepender'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: new SingleChildScrollView(
                scrollDirection: Axis.vertical, //.horizontal
                child: Text(
                  _content != null ? _content : 'Add a phrase to begin',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
            ),
            Container(
              // width: 250.0,
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Phrase',
                  labelStyle: TextStyle(fontSize: 16.0, color: Colors.white),
                  border: new UnderlineInputBorder(
                    borderSide: new BorderSide(color: Colors.greenAccent),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.greenAccent),
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                ),
                onSubmitted: (value) {
                  //value is entered text after ENTER press
                  //you can also call any function here or make setState() to assign value to other variable
                  _writeData();
                },
                textInputAction: TextInputAction.send,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
