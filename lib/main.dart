import 'package:flutter/material.dart';
import 'package:todo_app_flutter/completedItems.dart';

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
  final myController2 = TextEditingController();

  List<Map<String, dynamic>> _queryRows;
  List data;
  bool _visible = false;
  bool _editVisibility = false;
  int toUpdateId = 0;

  @override
  void initState() {
    init();

    super.initState();
  }

  void init() async {
    _queryRows = await DatabaseHelper.instance.queryAll("myTable");
    setState(() {
      _queryRows;
    });
  }

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
        title: Text('TODO Adder'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    _editVisibility = false;
                    _visible == false ? _visible = true : _visible = false;
                  });
                },
                child: Icon(Icons.add)),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => CompletedItems()));
              },
              child: Container(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(color:Colors.black,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 3.0,spreadRadius: 1
                        ),
                      ],
                      border: Border.all(
                        width: 2,
                        color: Colors.black,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Completed item",
                          style: TextStyle(
                              fontSize: 28,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          _editVisibility == true
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration:
                        InputDecoration(hintText: "Enter text to replace"),
                    controller: myController2,
                  ),
                )
              : Container(),
          _visible == true
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration:
                        InputDecoration(hintText: "Enter new item to add"),
                    controller: myController,
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(9),
                  child: Container(
                    child: Center(
                      child: Text(
                        "Add new items clicking on the + button.",
                      ),
                    ),
                  ),
                ),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: _queryRows == null ? 0 : _queryRows.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: new Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
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
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      toUpdateId = _queryRows[index]["_id"];
                                      _editVisibility == false
                                          ? _editVisibility = true
                                          : _editVisibility = false;
                                      _visible = false;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Icon(Icons.edit),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () async {
                                      addItemToCompletedTable(
                                          _queryRows[index]);
                                      int i = await DatabaseHelper.instance
                                          .insert("completedItems", {
                                        DatabaseHelper.columnName:
                                            _queryRows[index]['name'],
                                        DatabaseHelper.columnName2:
                                            _queryRows[index]["dateTime"],
                                        DatabaseHelper.columnName3:
                                            DateTime.now().toString()
                                      });
                                      deleteItem(_queryRows[index]["_id"]);
                                    },
                                    child: Icon(Icons.delete,
                                        color: Colors.red, size: 30)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, top: 4, bottom: 4),
                            child: Container(
                                child: Text(displayDateTime(index),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.2))),
                          ),
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
          if (myController.text.length > 0) {
            int i = await DatabaseHelper.instance.insert("myTable", {
              DatabaseHelper.columnName: myController.text,
              DatabaseHelper.columnName2: "Added ${DateTime.now()}"
            });
          }
          if (myController2.text.length > 0) {
            int updatedId = await DatabaseHelper.instance.update({
              DatabaseHelper.columnId: toUpdateId,
              DatabaseHelper.columnName: myController2.text,
              DatabaseHelper.columnName2: "Updated ${DateTime.now()}"
            });
          }

          List<Map<String, dynamic>> queryRows =
              await DatabaseHelper.instance.queryAll("myTable");
          await setState(() {
            _queryRows = queryRows;
          });

          clearTextInput();
        },
        tooltip: 'Show me the value!',
        child: Icon(Icons.text_fields),
      ),
    );
  }

  clearTextInput() {
    myController.clear();
    myController2.clear();
  }

  Widget makingList(queryRows) {
    return ListView.builder(itemCount: 3, itemBuilder: (context, index) {});
  }

  String displayDateTime(index) {
    String dateToBeReturned;
    DateTime date = DateTime.parse(
        _queryRows[index]["dateTime"].substring(0, 1) == "U"
            ? _queryRows[index]["dateTime"].substring(8)
            : _queryRows[index]["dateTime"].substring(6));
    return dateToBeReturned =
        "${_queryRows[index]["dateTime"].substring(0, 1) == "U" ? _queryRows[index]["dateTime"].substring(0, 8) : _queryRows[index]["dateTime"].substring(0, 6)}on ${date.day}-${date.month}-${date.year} at ${date.hour}:${date.minute}:${date.second}";
  }

  deleteItem(indexOfItem) async {
    _queryRows = await DatabaseHelper.instance.queryAll("myTable");
    await DatabaseHelper.instance.delete(indexOfItem);
    _queryRows = await DatabaseHelper.instance.queryAll("myTable");
    setState(() {
      _queryRows;
    });
  }

  addItemToCompletedTable(Map<String, dynamic> itemJson) {
    print("addItemToCompletedTable");
    print(itemJson.toString());
  }
}
