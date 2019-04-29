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
          SELECT u.name, t.title as tag, ut.rank FROM users u
          LEFT JOIN user_tags ut ON u.id = ut.user_id
          LEFT JOIN tags t on ut.tag_id = t.id
          ORDER BY rank DESC
        ''';
    print('runnin raw query');
    final now = DateTime.now();
    await db.rawQuery(query);
    print(
      'finished runnin raw query in ${DateTime.now().difference(now).inMilliseconds}ms',
    );
  }

  Future<Database> getDb() async {
    var databasesPath = await getDatabasesPath();
    var path = databasesPath + '/db.sqlite';
    var exists = await databaseExists(path);
    if (!exists) {
      ByteData data = await rootBundle.load('assets/db.sqlite');
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await Directory(databasesPath).create(recursive: true);
      await File(path).writeAsBytes(bytes, flush: true);
    }
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
