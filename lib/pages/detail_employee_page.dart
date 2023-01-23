import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/employees.dart';

class DetailEmployee extends StatelessWidget {
  static const routeName = "/detail-Employee";

  @override
  Widget build(BuildContext context) {
    final employee = Provider.of<Employees>(context, listen: false);

    final employeeId = ModalRoute.of(context)?.settings.arguments as String;

    final selectEmployee = employee.selectById(employeeId);

    final TextEditingController imageController =
        TextEditingController(text: selectEmployee.imageUrl);
    final TextEditingController nameController =
        TextEditingController(text: selectEmployee.name);
    final TextEditingController positionController =
        TextEditingController(text: selectEmployee.position);
    return Scaffold(
      appBar: AppBar(
        title: Text("DETAIL EMPLOYEE"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(imageController.text),
                    ),
                  ),
                ),
              ),
              TextFormField(
                autocorrect: false,
                autofocus: true,
                decoration: InputDecoration(labelText: "Nama"),
                textInputAction: TextInputAction.next,
                controller: nameController,
              ),
              TextFormField(
                autocorrect: false,
                decoration: InputDecoration(labelText: "Posisi"),
                textInputAction: TextInputAction.next,
                controller: positionController,
              ),
              TextFormField(
                autocorrect: false,
                decoration: InputDecoration(labelText: "Image URL"),
                textInputAction: TextInputAction.done,
                controller: imageController,
                onEditingComplete: () {
                  employee.editEmployee(
                    employeeId,
                    nameController.text,
                    positionController.text,
                    imageController.text,
                  ).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Berhasil diubah"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.pop(context);
                  });
                },
              ),
              SizedBox(height: 50),
              Container(
                width: double.infinity,
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: () {
                    employee.editEmployee(
                      employeeId,
                      nameController.text,
                      positionController.text,
                      imageController.text,
                    ).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Berhasil diubah"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    "Edit",
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
