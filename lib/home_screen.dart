import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timmy_todo/database_helper.dart';
import 'package:timmy_todo/todo_item_model.dart';

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
          title: Text(widget.title),
        ),
        body: Center(
          child: FutureBuilder(
            future: entries,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return generateList(snapshot.data);
              }
              if (snapshot.data == null) {
                return Text('test');
              }
              return CircularProgressIndicator();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
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
                          children: [
                            TextFormField(
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
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  child: Text('Cancel'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                ElevatedButton(
                                  child: Text('Submit'),
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
                });
            // databaseHelper.addItem(
            //   TodoItem(
            //     id: 0,
            //     title: 'title',
            //     subTitle: 'subTitle',
            //     isDone: false,
            //   ),
            // );
            // getEntries();
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ));
  }

  ListView generateList(data) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        TodoItem item = data.elementAt(index);
        return Container(
          child: CheckboxListTile(
            title: Text('Entry ${item.title}'),
            subtitle: Text('this is the subtitle'),
            secondary: const Icon(Icons.alarm),
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
