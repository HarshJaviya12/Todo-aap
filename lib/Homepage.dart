import 'package:api_project/ADD_List-Page.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final Map? todo;

  HomePage({Key? key, this.todo}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// String? stringResponse;
// Map? mapResponse;
// Map? dataResponse;
// List? listResponse;

class _HomePageState extends State<HomePage> {
  List items = [];
  bool isLoading = true;

  // Future apicall() async {
  //   http.Response response;
  //   response = await http.get(Uri.parse("https://reqres.in/api/users?page=2"));
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       // stringResponse = response.body;
  //       mapResponse = jsonDecode(response.body);
  //       listResponse = mapResponse!['data'];
  //     });
  //   }
  // }
  //
  @override
  void initState() {
    super.initState();
    FetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: GradientText(
            "Todo List",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
            colors: [
              Colors.white,
              Colors.green,
              Colors.red,
              Colors.white,
              Colors.purple,
            ],
          ),
        ),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: FetchData,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
                child: Text("No item Todo",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))),
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final id = item['_id'] as String;
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Card(
                      color: Colors.brown,
                      child: ListTile(
                        leading: CircleAvatar(child: Text('${index + 1}')),
                        title: Text(item['title']),
                        subtitle: Text(item["description"]),
                        trailing: PopupMenuButton(onSelected: (value) {
                          if (value == 'edit') {
                            NavigatetoEditpage(item);
                            //  open edit Page
                          } else if (value == 'delete') {
                            //  open Delete page
                            deletebyid(id);
                          }
                        }, itemBuilder: (context) {
                          return [
                            PopupMenuItem(child: Text("Edit"), value: 'edit'),
                            PopupMenuItem(
                              child: Text("Delete"),
                              value: 'delete',
                            )
                          ];
                        }),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: NavigatetoAddpage,
        label: Text(
          "Add List",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
        ),
      ),
    );
  }

  //************************************************************** ADD List Method ****************************************************************************************//
  Future<void> NavigatetoAddpage() async {
    final response = MaterialPageRoute(builder: (context) => AddList());
    await Navigator.push(context, response);
    setState(() {
      isLoading = true;
    });
    FetchData();
  }

  //************************************************************** Edit Method ****************************************************************************************//

  Future<void> NavigatetoEditpage(Map item) async {
    final response =
        MaterialPageRoute(builder: (context) => AddList(todo: item));
    await Navigator.push(context, response);
    setState(() {
      isLoading = true;
    });

    FetchData();
  }

  //************************************************************** Delete List Method ****************************************************************************************//

  Future<void> deletebyid(String id) async {
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {}
  }

  //**************************************************************  Data Get Method ****************************************************************************************//

  Future<void> FetchData() async {
    final url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json["items"] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
