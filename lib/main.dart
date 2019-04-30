import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    testDB();
  }

  testDB() async {
    final db = await getDb();
    String query = '''
           SELECT u.* FROM users u LEFT JOIN user_tags ut ON u.id = ut.user_id WHERE ut.tag_id in (3) ORDER BY ut.rank DESC LIMIT 30 OFFSET 0
        ''';
    print('runnin raw query');
    final now = DateTime.now();
    final result = await db.rawQuery(query);
    print(result);
    print(
      'finished runnin raw query on ${Platform.isAndroid ? 'Android' : 'iOS'} in ${DateTime.now().difference(now).inMilliseconds}ms',
    );
  }

  Future<Database> getDb() async {
    var databasesPath = await getDatabasesPath();
    var path = databasesPath + '/db.sqlite';
    ByteData data = await rootBundle.load('assets/db.sqlite');
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await Directory(databasesPath).create(recursive: true);
    await File(path).writeAsBytes(bytes, flush: true);
    return await openDatabase(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
    );
  }
}
