import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easyed/models/Datamodel.dart';

import 'package:http/http.dart' as http;

class test1screen extends StatefulWidget {
  const test1screen({super.key});

  @override
  State<test1screen> createState() => _test1screenState();
}

Future<DataModel> submitdata(String name, String job) async {
  var response = await http.post(Uri.https('reqres.in', '/api/users'), body: {
    "name": name,
    "job": job,
  });

  var data = response.body;

  print(data);

  if (response.statusCode == 201) {
    String responsestring = response.body;
    dataModelFromJson(responsestring);

    return DataModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(" Failed");
  }
}

class _test1screenState extends State<test1screen> {
  DataModel modeldata =
      DataModel(name: "name", job: "job", id: "id", createdAt: DateTime.now());
  TextEditingController namecoltroller = TextEditingController();
  TextEditingController jobcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: namecoltroller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          // borderRadius: BorderRadius.circular(20),
                          ),
                      hintText: "Enter name"),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: jobcontroller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          // borderRadius: BorderRadius.circular(20),
                          ),
                      hintText: "job title"),
                ),
                ElevatedButton(
                    onPressed: () async {
                      String name = namecoltroller.text;
                      String job = jobcontroller.text;

                      DataModel data = await submitdata(name, job);

                      setState(() {
                        modeldata = data;
                      });
                    },
                    child: Text("Submit"))
              ],
            )),
      ),
    );
  }
}
