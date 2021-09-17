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

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    getEntries();
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
                  return CupertinoAlertDialog(
                    title: Text(
                      'New Item',
                      textAlign: TextAlign.center,
                    ),
                    content: SizedBox(
                      height: 100,
                      width: 100,
                      child: Form(
                        child: Column(
                          children: [
                            TextFormField(
                              autocorrect: true,
                              textAlign: TextAlign.center,
                              autofocus: true,
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      CupertinoDialogAction(
                        child: Text('cancel'),
                        onPressed: () {},
                      ),
                      CupertinoDialogAction(
                        child: Text('submit'),
                        onPressed: () {},
                      ),
                    ],
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
