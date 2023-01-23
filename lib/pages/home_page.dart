import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../pages/detail_employee_page.dart';
import '../pages/add_employee_page.dart';

import '../providers/employees.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  // @override
  // //langsung menjalankan tetapi tidak bisa menggunakan bild contex
  // void initState() {
  //   Provider.of<Employees>(context).initialData();
  //   super.initState();
  // }

  @override
  //langsung jalan pada saat restart
  bool isInit = true;
  void didChangeDependencies() {
    if(isInit){
      Provider.of<Employees>(context).initialData();
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    isInit = true;
    super.dispose();


  }
  @override
  Widget build(BuildContext context) {
    final allEmployeeProvider = Provider.of<Employees>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("ALL EMPLOYEES"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, AddEmployee.routeName);
            },
          ),

        ],
      ),
      body: (allEmployeeProvider.jumlahEmployee == 0)
          ? Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No Data",
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AddEmployee.routeName);
                    },
                    child: Text(
                      "Add Employee",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: allEmployeeProvider.jumlahEmployee,
              itemBuilder: (context, index) {
                var id = allEmployeeProvider.allEmployee[index].id;
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      DetailEmployee.routeName,
                      arguments: id,
                    );
                  },
                  // leading: CircleAvatar(
                  //   backgroundImage: NetworkImage(
                  //     allEmployeeProvider.allEmployee[index].imageUrl,
                  //   ),
                  // ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: 50,
                      height: 50,
                      child: CachedNetworkImage(
                        imageUrl: allEmployeeProvider.allEmployee[index].imageUrl,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),

                  title: Text(
                    allEmployeeProvider.allEmployee[index].name,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMMd()
                        .format(allEmployeeProvider.allEmployee[index].createdAt),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      allEmployeeProvider.deleteEmployee(id).then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Berhasil dihapus"),
                            duration: Duration(milliseconds: 500),
                          ),
                        );
                      });
                    },
                    icon: Icon(Icons.delete),
                  ),
                );
              },
            ),
    );
  }
}
