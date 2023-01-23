// ignore_for_file: prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/employees.dart';

class AddEmployee extends StatelessWidget {
  static const routeName = "/add-employee";
  final TextEditingController nameController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  AddEmployee({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final employees = Provider.of<Employees>(context, listen: false);

    final addEmployees = ()  {
      employees.addEmployee(
        nameController.text,
        positionController.text,
        imageController.text,
      ).then((respone) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Berhasil ditambahkan"),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      }).catchError(
              (error) => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title:  Text("Terjadi Error $error"),
                content:  const Text("Terjadi kesalahan pada server"),
                actions: [
                  TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text("Okkay"),
                  ),
                ],
              )));
    };
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADD EMPLOYEE"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: addEmployees,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                autofocus: true,
                decoration: const InputDecoration(labelText: "Nama"),
                textInputAction: TextInputAction.next,
                controller: nameController,
              ),
              TextFormField(
                autocorrect: false,
                decoration: const InputDecoration(labelText: "Posisi"),
                textInputAction: TextInputAction.next,
                controller: positionController,
              ),
              // TextFormField(
              //   autocorrect: false,
              //   decoration: const InputDecoration(labelText: "Image URL"),
              //   textInputAction: TextInputAction.done,
              //   controller: imageController,
              //   onEditingComplete: addEmployees,
              // ),
              const SizedBox(height: 50),
              Container(
                width: double.infinity,
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: addEmployees,
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );


  }
}
