import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddList extends StatefulWidget {
  final Map? todo;

  const AddList({Key? key, this.todo }) : super(key: key);

  @override
  State<AddList> createState() => _AddListState();
}

class _AddListState extends State<AddList> {
  TextEditingController TitleController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if(todo != null){
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      TitleController.text = title;
      DescriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(isEdit ? "Edit Page" : "Add Todo")),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: TitleController,
            decoration: InputDecoration(hintText: "Title"),
          ),
          TextField(
            controller: DescriptionController,
            decoration: InputDecoration(hintText: "Description"),
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            minLines: 5,
          ),
          SizedBox(height: 20),
          ElevatedButton(onPressed: isEdit ? Updatedata :submitdata, child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(isEdit ? "Update" : "Submit"),
          )),
        ],
      ),
    );
  }

  //******************************************* update method *********************************************************************//
  Future<void> Updatedata() async {
    final todo = widget.todo;
    if(todo == null){
      print("You can not call updated without todo date");
      return;
    }
    final id = todo['_id'];
    final title = TitleController.text;
    final Description = DescriptionController.text;
    final body = {
      "title": title,
      "description": Description,
      "is_completed": false
    };

    // Submit Update data to the server
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    // show update success or fail massage based on status

    if (response.statusCode == 200) {

      print("Creation Success");
      ShowMessage("Updation Success");
    } else {
      print("Creation Failed");
      ShowerrorMessage("Updation Failed");
    }
  }

  //******************************************* Submit method *********************************************************************//
  Future<void> submitdata() async {
    final title = TitleController.text;
    final Description = DescriptionController.text;
    final body = {
      "title": title,
      "description": Description,
      "is_completed": false
    };

    // Submit data to the server

    final url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    // show success or fail massage based on status
    if (response.statusCode == 201) {
      DescriptionController.clear();
      TitleController.clear();

      print("Creation Success");
      ShowMessage("Creation Success");
    } else {
      print("Creation Failed");
      ShowerrorMessage("Creation Failed");
    }
  }

  void ShowMessage(String message) {
    final snackBar = SnackBar(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void ShowerrorMessage(String message) {
    final snackBar = SnackBar(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
        ),
      ),
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
