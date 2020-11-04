import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart';

createLog(String categoryId, String data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var categories = prefs.getString('categories');
  var jsonDecoded = jsonDecode(categories);

  if (categoryId == 'added') {
    categoryId = jsonDecoded['Added Data'];
    //
  } else if (categoryId == 'edited') {
    categoryId = jsonDecoded['Edited Data'];
//
  } else if (categoryId == 'deleted') {
    categoryId = jsonDecoded['Deleted Data'];
//
  } else if (categoryId == 'change') {
    categoryId = jsonDecoded['Change State'];
//
  } else if (categoryId == 'poke') {
    categoryId = jsonDecoded['Poked'];
//
  } else if (categoryId == 'unfollow') {
    categoryId = jsonDecoded['Unfollowed'];
  }
  // else if (categoryId == 'follow') {

  // }
  else {
    categoryId = jsonDecoded['Followed'];
  }
  print(categoryId);
  var id = prefs.getInt('id');
  var time = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
  try {
    final response = await post(
      'https://aoide.tk/api/logs/users/$id',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "logs_category_id": categoryId,
        "data": data,
        "date": time,
      }),
    );
    final res = json.decode(response.body);
    if (response.statusCode == 200) {}
  } catch (e) {
    print(e);
  }
}

savePreferences(dynamic list) async {
  Map<String, String> tempMap = {};
  list.forEach((x) => {tempMap[x['category']] = x['id'].toString()});
  var json = jsonEncode(tempMap);
  print(json);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  {
    await prefs.setString('categories', json);
  }
}

getCategories() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var id = prefs.getInt('id');
  try {
    final getRequest = await get(
      'https://aoide.tk/api/logs/categories/user/$id',
    );
    final res = json.decode(getRequest.body);
    if (getRequest.statusCode == 200) {
      var logCategories = res['data']['log_categories'];
      // if (logCategories.length > 0) {
      //   await makeCategories();
      // }
      if (logCategories.length == 0) {
        await makeCategories();
        await savePreferences(logCategories);
      } else {
        savePreferences(logCategories);
      }
    }
  } catch (e) {
    print(e);
  }
}

makeCategories() async {
  var categories = [
    'Added Data',
    'Edited Data',
    'Deleted Data',
    'Change State',
    'Poked',
    'Followed',
    'Unfollowed'
  ];
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var id = prefs.getInt('id');
  for (var category in categories) {
    try {
      final response = await post(
        'https://aoide.tk/api/logs/categories/user/$id',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'category': category,
        }),
      );
      final res = json.decode(response.body);
      if (response.statusCode == 200) {}
    } catch (e) {
      print(e);
    }
  }
}
