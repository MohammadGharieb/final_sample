import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'getCategories.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
TextEditingController _controllerID = TextEditingController();
TextEditingController _controllerName = TextEditingController();
const String _baseURL = 'https://nutmegged-amperages.000webhostapp.com/';

class _HomeState extends State<Home> {
  void Show(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      body: Form(
        key:
            _formKey, // key to uniquely identify the form when performing validation
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _controllerID,
                decoration: const InputDecoration(
                  hintText: 'Enter ID',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter id';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerName,
                decoration: const InputDecoration(
                  hintText: 'Enter Name',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                // we need to prevent the user from sending another request, while current
                // request is being processed
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final response =
                        await http.post(Uri.parse('$_baseURL/save.php'),
                            // convert the cid, name and key to a JSON object
                            body: convert.jsonEncode(<String, String>{
                              'cid': '${_controllerID.text}',
                              'name': _controllerName.text,
                            }));
                    if (response.statusCode == 200) {
                      // if successful, call the update function
                      Show(response.body);
                      print(response.body);
                    }
                  } else {
                    Show('Not Validated');
                  }
                },
                child: const Text('Submit'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () => {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const getCategories()))
                      },
                  child: Text('show categories'))
            ],
          ),
        ),
      ),
    );
  }
}
