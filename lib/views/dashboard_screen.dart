import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../controllers/login_controllers.dart';
import 'package:flutter/services.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  LoginController controller = LoginController();
  String currentTime = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final phoneNumber = ModalRoute.of(context)?.settings.arguments as String?;
      if (phoneNumber != null) {
        setState(() {
          controller.phoneNumber = phoneNumber;
        });
      }
      generateRandomNumber();
      getIpAddress();
      updateCurrentTime();
    });
  }

  void generateRandomNumber() {
    setState(() {
      controller.randomNumber = Random().nextInt(100000);
    });
  }

  Future<void> getIpAddress() async {
    try {
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4) {
            setState(() {
              controller.ipAddress = addr.address;
            });
            break;
          }
        }
        if (controller.ipAddress != null) break;
      }
    } catch (e) {
      setState(() {
        controller.ipAddress = 'Failed to get IP address';
      });
    }
  }

  void updateCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour == 0 ? 12 : now.hour;
    final amPm = now.hour >= 12 ? 'PM' : 'AM';

    setState(() {
      currentTime = "$hour:${now.minute.toString().padLeft(2, '0')} $amPm";
    });
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
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
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
              width: 130,
              height: 40,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  'PLUGIN',
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
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RepaintBoundary(
                      key: controller.qrKey,
                      child: QrImageView(
                        data: controller.randomNumber.toString(),
                        size: 180.0,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFF1A1A2E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Generated number',
                            style: TextStyle(color: Colors.white70),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${controller.randomNumber}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1.0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Current time: $currentTime',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        controller.saveData(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        padding: EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'SAVE',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
