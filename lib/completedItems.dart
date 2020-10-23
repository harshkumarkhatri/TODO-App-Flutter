import 'package:flutter/material.dart';

import 'databaseHelper.dart';

class CompletedItems extends StatefulWidget {
  CompletedItems({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CompletedItemsState createState() => _CompletedItemsState();
}

class _CompletedItemsState extends State<CompletedItems> {
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
    _queryRows = await DatabaseHelper.instance.queryAll("completedItems");
    setState(() {
      _queryRows;
      print(_queryRows);
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
                                      // print("$toUpdateId is to update id");
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
                                      // print("${_queryRows} is queryRows");
                                      // print(
                                      // "${_queryRows[index]} is index wala");
                                      // print(
                                      // "${_queryRows[index]["_id"]} is passed");
                                      addItemToCompletedTable(
                                          _queryRows[index]);
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
                                        // fontSize: 16,
                                        letterSpacing: 1.2)
                                    // _queryRows[index]["dateTime"].substring(0, 1) ==
                                    //         "U"
                                    //     ? _queryRows[index]["dateTime"].substring(8)
                                    //     : _queryRows[index]["dateTime"].substring(5),
                                    )),
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
          print(_queryRows);
          // if (myController.text.length > 0) {
          //   int i = await DatabaseHelper.instance.insert("myTable", {
          //     DatabaseHelper.columnName: myController.text,
          //     DatabaseHelper.columnName2: "Added ${DateTime.now()}"
          //   });

          //   // print("The inserted id is $i");
          // }
          // if (myController2.text.length > 0) {
          //   int updatedId = await DatabaseHelper.instance.update({
          //     DatabaseHelper.columnId: toUpdateId,
          //     DatabaseHelper.columnName: myController2.text,
          //     DatabaseHelper.columnName2: "Updated ${DateTime.now()}"
          //   });
          //   // print("Updated id is $updatedId");
          // }
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

          // List<Map<String, dynamic>> queryRows =
          //     await DatabaseHelper.instance.queryAll();
          await setState(() {
            // _queryRows = queryRows;
          });

          // print("query rows are ${_queryRows}");
          // print("${queryRows.runtimeType} is runtime type");
          clearTextInput();
          // print(_queryRows.length);
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
    // print(date.minute);
    return dateToBeReturned =
        "${_queryRows[index]["dateTime"].substring(0, 1) == "U" ? _queryRows[index]["dateTime"].substring(0, 8) : _queryRows[index]["dateTime"].substring(0, 6)}on ${date.day}-${date.month}-${date.year} at ${date.hour}:${date.minute}:${date.second}";
  }

  deleteItem(indexOfItem) async {
    // print("inside deleting item");
    // _queryRows = await DatabaseHelper.instance.queryAll();
    // // print(_queryRows);
    // // addItemToCompletedTable(_queryRows[indexOfItem]);
    // // print("index of item is ${indexOfItem + 1}");
    // await DatabaseHelper.instance.delete(indexOfItem);
    // _queryRows = await DatabaseHelper.instance.queryAll();
    // setState(() {
    //   _queryRows;
    // });
  }

  addItemToCompletedTable(Map<String, dynamic> itemJson) {
    print("addItemToCompletedTable");
    print(itemJson.toString());
  }
}