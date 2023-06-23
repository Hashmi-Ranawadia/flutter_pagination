import 'dart:convert';

import 'package:demo_pagination/model/user_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserData> userData = [];
  var page = 1;
  bool isLoad = false;
  ScrollController _scrollController = ScrollController();

  Future<List<UserData>> getData() async {
    var URL =
        'https://jsonplaceholder.typicode.com/posts?_page=$page&_limit=10';
    var response = await http.get(Uri.parse(URL));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var allData in data) {
        setState(() {
          userData.add(UserData.fromJson(allData));
        });
      }
      return userData;
    } else {
      print("Fail");
      return userData;
    }
  }

  void scrollListner() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        isLoad = true;
      });
      page = page + 1;
      await getData();
      setState(() {
        isLoad = false;
      });
    }
  }

  @override
  void initState() {
    getData();
    _scrollController.addListener(scrollListner);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pagination"),
      ),
      body: Column(
        children: [
          Expanded(
            child: userData.isNotEmpty
                ? ListView.builder(
                    controller: _scrollController,
                    itemCount: isLoad ? userData.length + 1 : userData.length,
                    itemBuilder: (context, index) {
                      if (index < userData.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          child: Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(userData[index].id.toString()),
                              ),
                              title: Text(
                                userData[index].title.toString(),
                                maxLines: 1,
                              ),
                              subtitle: Text(
                                userData[index].body.toString(),
                                maxLines: 1,
                              ),
                            ),
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ],
      ),
    );
  }
}
