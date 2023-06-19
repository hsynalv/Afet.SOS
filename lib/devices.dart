import 'package:flutter/material.dart';
import 'dm_page.dart';

class Devices extends StatelessWidget {
  const Devices({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF262626),
              title: Text('Ağdaki Cihazlar'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: 7, //cihaz.length
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xFF404040),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            width: 3,
                            color: Color(0xFF262626),
                          )),
                      child: ListTile(
                        title: Text(
                          "Cihaz İsimleri",
                          style: TextStyle(color: Colors.white),
                        ), //cihaz adları cihaz.firstname falan
                        leading: Icon(
                          Icons.person,
                          color: Colors.white,
                        ), //baştaki icon
                        trailing: Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                        ), //sondaki icon
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => dmPage()));
                        },
                      ),
                    ),
                  ],
                );
              },
            )));
  }
}
