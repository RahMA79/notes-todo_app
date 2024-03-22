import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'SqlDatabase.dart';

class ToDo_list extends StatefulWidget {
  const ToDo_list({super.key});

  @override
  State<ToDo_list> createState() =>_ToDoState();
}

class _ToDoState extends State<ToDo_list> {
  TextEditingController titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            setState(() {
              SqlHelper().deleteAllTodos();
            });
          }, icon: Icon(Icons.delete, color: Colors.white,)),
        ],
        backgroundColor: Colors.blueAccent,

        title: Text('Todo', style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight:FontWeight.w300
        ),),

      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
                  future: SqlHelper().loadToDo(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Map>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            bool isDone = snapshot.data![index]['value'] == 0
                                ? false
                                : true;
                            return Dismissible(
                              onDismissed: (direction) {
                                SqlHelper().deleteToDo(
                                    snapshot.data![index]['id']);
                              },
                              key: UniqueKey(),
                              child:
                              Padding(
                                padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                                child: Card(
                                  color: isDone ? Colors.blueAccent : Colors.grey,
                                  child: Row(
                                    children: [
                                      Checkbox(
                                          value: isDone,
                                          onChanged: (bool? val) {
                                            SqlHelper()
                                                .updateTodoChecked(
                                              snapshot.data![index]['id'],
                                              snapshot.data![index]['value'],
                                            )
                                                .whenComplete(
                                                    () => setState(() {}));
                                          }),
                                      Text(
                                        '${(snapshot.data![index]['title'])}',
                                        style: TextStyle(
                                          color: isDone
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  })),
        ],
      ),
      floatingActionButton:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: FloatingActionButton(
          heroTag: 'todo',
          tooltip: 'Add ToDo',
          onPressed: () {
            showInsertToDoDialog(context);
          },
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.add, color:Colors.white),
        ),
      ),
    );
  }
  showInsertToDoDialog(context) {
    showCupertinoDialog(
        context: context,
        builder: (_) {
          return Material(
            color: Colors.white.withOpacity(0.3),
            child: CupertinoAlertDialog(
              title: Text('Add new Todo'),
              content: Column(
                children: [
                  TextField(
                    controller: titleController,
                  ),

                ],
              ),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: Text('Yes'),
                  onPressed: () {
                    SqlHelper()
                        .insertTodo(ToDo(title: titleController.text))
                        .whenComplete(() => setState(() {}));
                    titleController.clear();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

}
