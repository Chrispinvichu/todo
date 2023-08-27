import 'package:flutter/material.dart';
import 'package:todo/sql_helper.dart';

class Todo_App extends StatefulWidget {
  const Todo_App({super.key});

  @override
  State<Todo_App> createState() => _Todo_AppState();
}

class _Todo_AppState extends State<Todo_App> {
  final _formkey=GlobalKey<FormState>();
  List<Map<String,dynamic>> _journals=[];
  bool _isLoading = true;
  void _refreshJournals() async{
    final data = await Sql_helper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState(){
    super.initState();
    _refreshJournals();
  }
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  void _showForm(int? id) async{
    if(id!=null){
      final existingJournal = _journals.firstWhere((element) => element['id']==id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
    }
    showModalBottomSheet(

        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom+120,
          ),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  validator: (value) {
                    if(value!.isEmpty){
                      return 'Enter title';
                    }
                    return null;
                  },
                  controller: _titleController,
                  decoration: const InputDecoration(hintText:'Title'),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if(value!.isEmpty){
                      return 'Enter title';
                    }
                    return null;
                  },
                  controller: _descriptionController,
                  decoration: const InputDecoration(hintText: 'Description'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Save new journal
                    if(_formkey.currentState!.validate())
                    {
                      if (id == null) {
                        await _addItem();
                        Navigator.of(context).pop();
                        _titleController.text = '';
                        _descriptionController.text = '';
                      }
                    }

                    if (id != null) {
                      await _updateItem(id);
                      _titleController.text = '';
                      _descriptionController.text = '';

                    }

                    _titleController.text = '';
                    _descriptionController.text = '';


                  },
                  child: Text(id == null ? 'Create New' : 'Update'),
                )
              ],
            ),
          ),
        ));
  }
  Future<void> _addItem() async{
    await Sql_helper.createItem(
        _titleController.text, _descriptionController.text);
    _refreshJournals();
  }

  Future<void> _updateItem(int id) async {
    await Sql_helper.updateItem( id,
        _titleController.text, _descriptionController.text);
    _refreshJournals();
  }
  void _deleteItem(int id) async{
    await Sql_helper.deleteItem(id);
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ALERT'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Delete this reminder'),
                Text('Click yes to delete?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('YES'),
              onPressed: () {
                setState(() {
                  Sql_helper.deleteItem(id);
                  _refreshJournals();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //   content: Text('Successfully deleted a journal!')
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyReminder',
          style: TextStyle(
              fontFamily: "Fasthand"
          ),),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _journals.length,
        itemBuilder: (context, index) => Card(
          color: Colors.white24,

          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_journals[index]['title'],
                style: TextStyle(
                    fontFamily: "Fasthand"
                ),  ),
              subtitle: Text(_journals[index]['description'],
                style: TextStyle(
                    fontFamily: "Fasthand"
                ),
              ),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit,),
                      onPressed: () => _showForm(_journals[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteItem(_journals[index]['id']),
                    ),
                  ],
                ),
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }}
