import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'addTaskScreen.dart';

import 'firebase/db.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map task = {};
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLogs();
  }

  getLogs() async {
    getUserInfo().then((value) {
      setState(() {
        loading = false;
        if (value != null) {
          task = value!;
        }
      });
    });
  }

  Future<void> showDeleteNotification(task) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Image.asset('assets/delete-file.png', height: 100),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("Do you want to delete this event?")
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                deleteTask(task);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(27, 56, 100, 1.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
        ),
        toolbarHeight: 100,
        flexibleSpace: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 85,
                width: 110,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/logo.png'),
                      fit: BoxFit.fitHeight),
                ),
              ),
            )
          ],
        ),
      ),
      body: loading
          ? Center(
        child: Column(
          children: [CircularProgressIndicator()],
        ),
      )
          : task.isNotEmpty
          ? Container(
        color: const Color.fromRGBO(246, 244, 235, 1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              const Text(
                "Task List",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(50, 50, 50, 1),
                ),
              ),
              Container(
                height: 3,
                color: const Color.fromRGBO(50, 50, 50, 1),
              ),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: task!.length,
                itemBuilder: (BuildContext context, int index) {
                  String taskName = task.keys.elementAt(index);
                  if (taskName != 'schedule') {
                    return Card(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                taskName,
                                style:
                                TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  'Due Date: ${task[taskName]['due_date']}'),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  showDeleteNotification(taskName);
                                },
                              ),
                            ),
                            ExpansionTile(
                              title: const Text('More'),
                              children: <Widget>[
                                Container(
                                  child: Text(
                                      "Frequency: ${task[taskName]['frequency']}\n Type: ${task[taskName]['type']}\nTime per day: ${task[taskName]['time_per_day']}"),
                                ),
                              ],
                            ),
                          ],
                        ));
                  } else
                    return SizedBox();
                },
              ),
            ],
          ),
        ),
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('There is not task')],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(116, 155, 194, 1),
        child: const Icon(Icons.add_task),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddTaskPage()))
              .then((value) => getLogs());
        },
      ),
    );
  }
}