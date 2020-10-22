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
  final myController2 = TextEditingController();

  List<Map<String, dynamic>> _queryRows;
  List data;
  bool _visible = false;
  bool _editVisibility = false;
  int toUpdateId = 0;

  @override
  void initState() {
    // TODO: implement initState
    init();

    super.initState();
  }

  void init() async {
    _queryRows = await DatabaseHelper.instance.queryAll();
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
          // makingList(_queryRows)
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: _queryRows == null ? 0 : _queryRows.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: new Card(
                      child: Column(
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
                                      print("$toUpdateId is to update id");
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
                                    onTap: () {
                                      print("${_queryRows} is queryRows");
                                      print(
                                          "${_queryRows[index]} is index wala");
                                      print(
                                          "${_queryRows[index]["id"]} is passed");
                                      deleteItem(_queryRows[index]["_id"]);
                                    },
                                    child: Icon(Icons.delete,
                                        color: Colors.red, size: 30)),
                              ],
                            ),
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
            int i = await DatabaseHelper.instance
                .insert({DatabaseHelper.columnName: myController.text});

            print("The inserted id is $i");
          }
          if (myController2.text.length > 0) {
            int updatedId = await DatabaseHelper.instance.update({
              DatabaseHelper.columnId: toUpdateId,
              DatabaseHelper.columnName: myController2.text
            });
            print("Updated id is $updatedId");
          }
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

          print("query rows are ${_queryRows}");
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
    myController2.clear();
  }

  Widget makingList(queryRows) {
    return ListView.builder(itemCount: 3, itemBuilder: (context, index) {});
  }

  deleteItem(indexOfItem) async {
    print("index of item is ${indexOfItem + 1}");
    await DatabaseHelper.instance.delete(indexOfItem);
    _queryRows = await DatabaseHelper.instance.queryAll();
    setState(() {
      _queryRows;
    });
  }
}
