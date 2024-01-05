import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class getCategories extends StatefulWidget {
  const getCategories({super.key});

  @override
  State<getCategories> createState() => _getCategoriesState();
}

const String _baseURL = 'https://nutmegged-amperages.000webhostapp.com/';
bool _isloading = false;
List<cat> _cats = [];
// asynchronously update _products list

class _getCategoriesState extends State<getCategories> {
  @override
  void initState() {
    _getCategories();
    super.initState();
  }

  Future<void> _getCategories() async {
    _cats = [];
    setState(() {
      _isloading = true;
    });
    final String apiUrl = '${_baseURL}/getCategories.php';

    var response = await http.get(Uri.parse(apiUrl));
    final jasonResponse = convert.jsonDecode(response.body);
    for (var row in jasonResponse) {
      cat t = cat(row['cid'], row['name']);
      _cats.add(t);
    }
    setState(() {
      _isloading = false;
    });
    print('Response: ${response.body}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note List'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isloading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _cats.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${_cats[index].id}-  ${_cats[index].name}'),
                  //subtitle: Text(_cats[index].content),
                );
              },
            ),
    );
  }
}

class cat {
  String id;
  String name;
  cat(this.id, this.name);
}
