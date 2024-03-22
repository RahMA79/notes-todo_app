import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'SqlDatabase.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            setState(() {
              SqlHelper().deleteAllNotes();
            });
          }, icon: Icon(Icons.delete, color: Colors.white,)),
        ],
        backgroundColor: Colors.purple,

        title: Text('Notes', style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight:FontWeight.w300
        ),),

      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder(
                    future: SqlHelper().loadNote(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Map>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                  onDismissed: (direction) {
                                    SqlHelper().deleteNote(
                                        snapshot.data![index]['id']);
                                  },
                                  key: UniqueKey(),
                                  child: Card(
                                    color: Colors.white30,
                                    child: Column(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              showEditNoteDialog(
                                                context,
                                                snapshot.data![index]['title'],
                                                snapshot.data![index]
                                                    ['content'],
                                                snapshot.data![index]['id'],
                                              );
                                            },
                                            icon: Icon(Icons.edit)),
                                        Text(('id : ') +
                                            (snapshot.data![index]['id'])
                                                .toString()),
                                        Text(('title : ') +
                                            (snapshot.data![index]['title'])
                                                .toString()),
                                        Text(('content : ') +
                                            (snapshot.data![index]['content'])
                                                .toString()),
                                      ],
                                    ),
                                  ));
                            });
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    })),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: FloatingActionButton(
          heroTag: 'note',
          tooltip: 'Add Note',
          onPressed: () {
            showInsertNoteDialog(context);
          },
          backgroundColor: Colors.purple,
          child: Icon(Icons.add, color: Colors.white,),
        ),
      ),
    );
  }

  showInsertNoteDialog(context) {
    showCupertinoDialog(
        context: context,
        builder: (_) {
          return Material(
            color: Colors.white.withOpacity(0.3),
            child: CupertinoAlertDialog(
              title: Text('Add new note'),
              content: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'title...',
                      hintStyle: TextStyle(
                          color: Colors.grey
                      ),
                    ),
                  ),
                  TextField(
                    controller: contentController,
                    decoration:InputDecoration(
                        hintStyle: TextStyle(
                      color: Colors.grey
                    ),
                        hintText: 'content...'

                    ),
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
                        .insertNote(Note(
                          title: titleController.text,
                          content: contentController.text,
                        ))
                        .whenComplete(() => setState(() {}));
                    titleController.clear();
                    contentController.clear();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  showEditNoteDialog(context, String titleInit, String contentInit, int id) {
    showCupertinoDialog(
        context: context,
        builder: (_) {
          return Material(
            color: Colors.white.withOpacity(0.3),
            child: CupertinoAlertDialog(
              title: const Text('Edit note'),
              content: Column(
                children: [
                  TextFormField(
                    initialValue: titleInit,
                    onChanged: (val) {
                      titleInit = val;
                    },
                  ),
                  TextFormField(
                    initialValue: contentInit,
                    onChanged: (val) {
                      contentInit = val;
                    },
                  ),
                ],
              ),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('Yes'),
                  onPressed: () {
                    SqlHelper()
                        .updateNote(Note(
                            title: titleInit, content: contentInit, id: id))
                        .whenComplete(() => setState(() {}));
                  },
                ),
              ],
            ),
          );
        });
  }
}
