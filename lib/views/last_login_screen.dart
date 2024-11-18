import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import '../controllers/login_controllers.dart';

class LastLoginScreen extends StatefulWidget {
  @override
  _LastLoginScreenState createState() => _LastLoginScreenState();
}

class _LastLoginScreenState extends State<LastLoginScreen> {
  LoginController controller = LoginController();

  List<List<String>>? allUserData;
  List<Uint8List> qrImages = [];

  @override
  void initState() {
    super.initState();
    loadAllLoginData();
  }

  Future<void> loadAllLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? allData = prefs.getStringList('allUserData');

    if (allData != null) {
      setState(() {
        allUserData = allData.map((data) {
          List<String> dataList = List<String>.from(jsonDecode(data));
          qrImages.add(base64Decode(dataList[3]));
          return dataList;
        }).toList();
      });
    }
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('allUserData');

    setState(() {
      allUserData = null;
      qrImages.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('All login data cleared.')),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(""),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout,color: Colors.white,),
            onPressed: (){
              controller.logout(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 80),
          Center(
            child: Container(
              width: 170,
              height: 40,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  'LAST LOGIN',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: allUserData != null
                ? ListView.builder(
              itemCount: allUserData!.length,
              itemBuilder: (context, index) {
                final dataSet = allUserData![index];
                final qrImage = qrImages[index];

                return Card(
                  color: Colors.grey[900],
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Phone Number: ${dataSet[0]}',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'IP Address: ${dataSet[1]}',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'QR Code Number: ${dataSet[2]}',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Login Time: ${dataSet[4]}',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          child: Image.memory(
                            qrImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
                : const Center(
              child: Text(
                'No previous login data',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: clearAllData,
        child: Icon(Icons.delete_forever),
        backgroundColor: Colors.red,
      ),
    );
  }
}
