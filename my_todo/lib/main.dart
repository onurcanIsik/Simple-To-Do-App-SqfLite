import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:my_todo/todomDao.dart';
import 'package:my_todo/todoslar.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime date = DateTime.now();
  String dateFormat = DateFormat('dd/MM/yyyy hh:mm').format(DateTime.now());
  String dateFormatNoClock = DateFormat('dd/MM/yyyy').format(DateTime.now());

  List todo = [];
  String input = "";
  var tfNameController = TextEditingController();

  Future<List<Todoslar>> tumTodoslar() async {
    var todosList = await TodomDao().tumTodom();

    return todosList;
  }

  Future<void> ekle(String todo_name, String todo_day) async {
    await TodomDao().todoEkle(
      todo_name,
      todo_day,
    );
  }

  Future<void> sil(int todo_id) async {
    await TodomDao().todoSil(todo_id);
  }

  Future<void> printTumTodo() async {
    var tumTodo = await TodomDao().tumTodom();

    for (Todoslar index in tumTodo) {
      print("*****");
      print("todo_id : ${index.todo_id}");
      print("todo_name : ${index.todo_name}");
      print("todo_day : ${index.todo_day}");
    }
  }

  @override
  void initState() {
    super.initState();
    tumTodoslar();
    printTumTodo();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                padding: EdgeInsets.zero,
                child: Center(
                  child: Text(
                    "MYTodom",
                    style: TextStyle(
                        fontFamily: "Lobster",
                        color: Colors.white,
                        fontSize: 40),
                  ),
                ),
                decoration: BoxDecoration(color: Colors.redAccent),
              ),
              ListTile(
                title: Text(
                  "Calorie Saver",
                  style: TextStyle(
                    fontFamily: "Flower",
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {},
                leading: Icon(
                  Icons.fitness_center,
                  size: 30,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(35))),
          centerTitle: true,
          title: Text(
            "MYTodom",
            style: TextStyle(fontSize: 28, fontFamily: "Lobster"),
          ),
          backgroundColor: Colors.redAccent,
          actions: [
            Row(
              children: [
                Text(
                  dateFormatNoClock,
                  style: TextStyle(
                      fontFamily: "Flower",
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 15,
                )
              ],
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.redAccent,
          shape: CircularNotchedRectangle(),
          child: Container(height: 53),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
          width: 90,
          height: 90,
          child: FloatingActionButton(
            elevation: 10,
            splashColor: Colors.black,
            backgroundColor: Colors.red[900],
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35),
                        ),
                      ),
                      title: Text(
                        "Add Note",
                        style: TextStyle(
                          fontFamily: "Flower",
                          fontSize: 30,
                        ),
                      ),
                      elevation: 10,
                      backgroundColor: Colors.redAccent,
                      actions: [
                        Container(
                          child: Column(
                            children: [
                              TextField(
                                controller: tfNameController,
                                onChanged: (String value) {
                                  input = value;
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.note_add,
                                    size: 30,
                                    color: Colors.red[900],
                                  ),
                                  filled: true,
                                  fillColor: Colors.white38,
                                  hintText: "Enter Text",
                                  hintStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        todo.add(input);
                                        ekle(tfNameController.text, dateFormat);
                                      });
                                      tfNameController.clear();
                                    },
                                    icon: Icon(
                                      Icons.clear,
                                      color: Colors.white,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                decoration:
                                    BoxDecoration(color: Colors.red[900]),
                                width: 100,
                                height: 50,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      todo.add(input);
                                      ekle(tfNameController.text, dateFormat);
                                    });
                                    tfNameController.clear();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "ADD",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: "Flower",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  });
            },
            child: Icon(
              Icons.note_add_rounded,
              size: 55,
              color: Colors.white,
            ),
          ),
        ),
        body: FutureBuilder<List<Todoslar>>(
          future: tumTodoslar(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var notum = snapshot.data;
              return StaggeredGridView.countBuilder(
                staggeredTileBuilder: (int index) => StaggeredTile.count(
                  index % 5 == 0 ? 2 : 1,
                  index % 15 != 0 ? 1 : 2,
                ),
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 10.0,
                crossAxisCount: 2,
                itemCount: notum!.length,
                itemBuilder: (context, index) {
                  var listem = notum[index];
                  return Card(
                    elevation: 8,
                    shadowColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    color: Colors.redAccent,
                    child: ListTile(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                    topLeft: Radius.circular(35),
                                    topRight: Radius.circular(35),
                                  ),
                                ),
                                title: Text("${listem.todo_name}"),
                                actions: [
                                  Column(
                                    children: [
                                      Container(
                                        width: 70,
                                        height: 40,
                                        color: Colors.redAccent,
                                        child: TextButton(
                                          child: Text(
                                            "Sil",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Flower",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              sil(listem.todo_id);
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                      Text(
                                        "${listem.todo_day}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )
                                ],
                              );
                            });
                      },
                      title: Column(
                        children: [
                          Text(
                            "${listem.todo_name}",
                            style: TextStyle(
                                fontFamily: "Flower",
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            "${listem.todo_day}",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Flower"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Center();
          },
        ),
      ),
    );
  }
}
