import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Employees with ChangeNotifier {
  List<Employee> _allemployee = [];

  List<Employee> get allEmployee => _allemployee;

  int get jumlahEmployee => _allemployee.length;

  Employee selectById(String id) =>
      _allemployee.firstWhere((element) => element.id == id);

  addEmployee(
    String name,
    String position,
    String image,
  ) async {
    DateTime datetimeNow = DateTime.now();

    Uri url = Uri.parse(
        "https://mini-projeck-default-rtdb.asia-southeast1.firebasedatabase.app/employees.json");

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            "name": name,
            "position": position,
            "imageUrl": image,
            "createdAt": datetimeNow.toString(),
          },
        ),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        _allemployee.add(
          Employee(
            id: json.decode(response.body)["name"].toString(),
            name: name,
            position: position,
            imageUrl: image,
            createdAt: datetimeNow,
          ),
        );
      } else {
        throw ("${response.statusCode}");
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  editEmployee(
    String id,
    String name,
    String position,
    String image,
  ) async {
    Uri url = Uri.parse(
        "https://mini-projeck-default-rtdb.asia-southeast1.firebasedatabase.app/employees/$id.json");
    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {
            "name": name,
            "position": position,
            "imageUrl": image,
          },
        ),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Employee selectEmployee =
            _allemployee.firstWhere((element) => element.id == id);
        selectEmployee.name = name;
        selectEmployee.position = position;
        selectEmployee.imageUrl = image;
        notifyListeners();
      } else {
        throw ("${response.statusCode}");
      }
    } catch (error) {
      throw (error);
    }
  }

  deleteEmployee(String id) async {
    Uri url = Uri.parse(
        "https://mini-projeck-default-rtdb.asia-southeast1.firebasedatabase.app/employees/$id.json/");
    final response = await http.delete(url).then((response) {
      _allemployee.removeWhere((element) => element.id == id);
      notifyListeners();
    });
  }

  Future<void> initialData() async {
    Uri url = Uri.parse(
        "https://mini-projeck-default-rtdb.asia-southeast1.firebasedatabase.app/employees.json/");
    // try {
    var hasilGetData = await http.get(url);
    // if (hasilGetData.statusCode == 200) {

    var dataResponse = jsonDecode(hasilGetData.body) as Map<String, dynamic>;
    if (dataResponse != null) {
      dataResponse.forEach(
        (key, value) {
          DateTime dateTimeParse =
              DateFormat("yyyy-mm-dd hh:mm:ss").parse(value["createdAt"]);
          _allemployee.add(
            Employee(
              id: key,
              name: value["name"],
              position: value["position"],
              imageUrl: value["imageUrl"],
              createdAt: dateTimeParse,
            ),
          );
        },
      );
      notifyListeners();
    }
    //   } else {
    //     throw Exception("Failed to load data, status code: ${hasilGetData.statusCode}");
    //   }
    // } catch (e) {
    //   throw Exception(e);
    // }
  }
}
