import 'package:flutter/material.dart';

import 'aboutTheDeveloper.dart';
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

  // Open the page respective to the choice from top 3 dots
  void handleClick(String value) {
    switch (value) {
      // Opens the About the Developer page
      case 'About The Developer':
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => AboutTheDev()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks'),
        actions: [
          Positioned(
            top: 45,
            right: 0,
            child: FlatButton(
              onPressed: () {
                print("pressing");
              },
              child: PopupMenuButton<String>(
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {
                    'About The Developer',
                  }.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ),
          ),
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
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, top: 4, bottom: 4),
                            child: Container(
                                child: Text(completedOn(index),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: 1.05))),
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
          await setState(() {
            // _queryRows = queryRows;
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

  String completedOn(index) {
    String dateToBeReturned;
    DateTime date = DateTime.parse(_queryRows[index]["completedOn"]);
    return dateToBeReturned =
        "Completed on ${date.day}-${date.month}-${date.year} at ${date.hour}:${date.minute}:${date.second}";
  }

  addItemToCompletedTable(Map<String, dynamic> itemJson) {
    print("addItemToCompletedTable");
    print(itemJson.toString());
  }
}
