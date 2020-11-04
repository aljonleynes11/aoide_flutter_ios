import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:Aiode/model/Dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RegisterScreen5th extends StatefulWidget {
  @override
  _RegisterScreen5thState createState() => _RegisterScreen5thState();
}

Dashboard user = Dashboard();
Future<Dashboard> setup() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var id = prefs.getInt('id');
  final response = await get('https://aoide.tk/api/dashboard/user/$id');
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    print(data);
    user = Dashboard.fromJson(data);
    return user;
  }
  return user;
}

class _RegisterScreen5thState extends State<RegisterScreen5th> {
  Future dashboardFuture;
  @override
  void initState() {
    super.initState();
    dashboardFuture = setup();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: dashboardFuture, // function where you call your api
      builder: (context, snapshot) {
        // if (snapshot.hasData)
        //   return Container(child: Center(child: Text('try')));
        // else if (snapshot.connectionState == ConnectionState.waiting)
        //   return Container(child: Center(child: CircularProgressIndicator()));
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.articles.length,
              itemBuilder: (context, index) {
                var article = snapshot.data.articles[index];
                return Container(
                  height: 100,
                  margin: const EdgeInsets.all(8),
                  child: Row(
                    children: <Widget>[
                      Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(
                              article.urlToImage,
                              fit: BoxFit.cover,
                            )),
                      ),
                      SizedBox(width: 16),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              article.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              article.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        } else
          return Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<String> downloadData() async {
    //   var response =  await http.get('https://getProjectList');
    return Future.value("Data download successfully"); // return your response
  }
}
