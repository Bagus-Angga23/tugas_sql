import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SqliteApp());
}

class SqliteApp extends StatefulWidget {
  const SqliteApp({Key? key}) : super(key: key);

  @override
  _SqliteAppState createState() => _SqliteAppState();
}

class _SqliteAppState extends State<SqliteApp> {
  int? selectedId;
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: TextField(
            controller: textController,
          ),
        ),
        body: Center(
          child: FutureBuilder<List<Toko>>(
              future: DatabaseHelper.instance.getToko(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Toko>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return snapshot.data!.isEmpty
                    ? Center(child: Text('Masukan Nama Anda.'))
                    : ListView(
                  children: snapshot.data!.map((grocery) {
                    return Center(
                      child: Card(
                        child: ListTile(
                          title: Text(grocery.name),
                          leading: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                DatabaseHelper.instance
                                    .remove(grocery.id!);
                              });
                            },
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                textController.text = grocery.name;
                                selectedId = grocery.id;
                              });
                            },
                          ),
                          onTap: () {
                            setState(() {
                              textController.text = grocery.name;
                              selectedId = grocery.id;
                            });
                          },
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.save),
            onPressed: () async {
              selectedId != null
                  ? await DatabaseHelper.instance.update(
                Toko(id: selectedId, name: textController.text),
              )
                  : await DatabaseHelper.instance.add(
                Toko(name: textController.text),
              );
              setState(() {
                textController.clear();
                selectedId = null;
              });
            }), //FloatingActionB
      ),
    );
  }
}
