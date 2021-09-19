import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_done/database_helper.dart';
import 'package:to_done/todo_item_model.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DatabaseHelper databaseHelper;
  Future<List<TodoItem>>? entries;

  final _formKey = GlobalKey<FormState>();
  final newItemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    getEntries();
  }

  @override
  void dispose() {
    newItemController.dispose();
    super.dispose();
  }

  getEntries() {
    setState(() {
      entries = databaseHelper.getItems(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          child: Container(
            color: Colors.grey,
            height: 0.5,
          ),
          preferredSize: Size.fromHeight(0),
        ),
      ),
      backgroundColor: Color(0xFFF0F0F0),
      body: Center(
        child: FutureBuilder(
          future: entries,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return generateList(snapshot.data);
            }
            if (snapshot.data == null) {
              return Text('Click on the Add button to create a new To-Do');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.0),
        height: 64,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey),
          ),
          color: Colors.white,
        ),
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'New Item',
                    textAlign: TextAlign.center,
                  ),
                  content: SizedBox(
                    height: 180,
                    width: 100,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            cursorColor: Colors.grey,
                            autocorrect: true,
                            textAlign: TextAlign.center,
                            autofocus: true,
                            keyboardType: TextInputType.multiline,
                            maxLines: 4,
                            controller: newItemController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text or Cancel';
                              }
                              return null;
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  elevation: 0.0,
                                  primary: Colors.white,
                                ),
                                onPressed: () {
                                  newItemController.clear();
                                  return Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0.0,
                                  primary: Colors.white,
                                ),
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    databaseHelper.addItem(
                                      TodoItem(
                                          id: 0,
                                          title: newItemController.text,
                                          subTitle: '',
                                          isDone: false),
                                    );
                                    getEntries();
                                    newItemController.clear();
                                    return Navigator.pop(context);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: Icon(Icons.add, color: Colors.black),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(
                side: BorderSide(
              color: Colors.grey,
              width: 1.5,
            )),
            primary: Colors.white,
            elevation: 0.0,
          ),
        ),
      ),
    );
  }

  ListView generateList(data) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        TodoItem item = data.elementAt(index);
        return Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: CheckboxListTile(
            title: Text('${item.title}'),
            value: item.isDone,
            onChanged: (value) {
              item.isDone = value!;
              databaseHelper.updateItem(item);
              getEntries();
            },
          ),
        );
      },
    );
  }
}
