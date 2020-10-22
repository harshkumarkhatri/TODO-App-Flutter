import 'package:flutter/material.dart';

import 'databaseHelper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
  final myController = TextEditingController();
  List<Map<String, dynamic>> _queryRows;
  List data;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Retrieve Text Input'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: myController,
            ),
          ),
          // makingList(_queryRows)
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: _queryRows == null ? 0 : _queryRows.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left:15,right:15),
                    child: new Card(
                      child: Row(
                        children: [
                          new Text(
                            _queryRows[index]["name"],
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 24,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.delete, color: Colors.red),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () async {
          int i = await DatabaseHelper.instance
              .insert({DatabaseHelper.columnName: myController.text});

          print("The inserted id is $i");
          // return showDialog(
          //   context: context,
          //   builder: (context) {
          //     return AlertDialog(
          //       // Retrieve the text the that user has entered by using the
          //       // TextEditingController.
          //       content: Text(myController.text),
          //     );
          //   },
          // );

          List<Map<String, dynamic>> queryRows =
              await DatabaseHelper.instance.queryAll();
          await setState(() {
            _queryRows = queryRows;
          });

          print("query rows are ${_queryRows[0]}");
          print("${queryRows.runtimeType} is runtime type");
          clearTextInput();
          print(_queryRows.length);
        },
        tooltip: 'Show me the value!',
        child: Icon(Icons.text_fields),
      ),
    );
  }

  clearTextInput() {
    myController.clear();
  }

  Widget makingList(queryRows) {
    return ListView.builder(itemCount: 3, itemBuilder: (context, index) {});
  }
}
