import 'dart:convert';
import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/last_login_screen.dart';
import '../views/login_screen.dart';

class LoginController extends GetxController{

  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  String generatedOtp = '';
  bool isOtpSent = false;

  int? randomNumber;
  String? ipAddress;
  String phoneNumber = '';
  GlobalKey qrKey = GlobalKey();

  void initializeNotifications() {
    AwesomeNotifications().initialize(
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
          channelKey: 'otp_channel',
          channelName: 'OTP Notifications',
          channelDescription: 'Notification channel for OTP',
          defaultColor: Color(0xFF26FF00),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          playSound: true,
          soundSource: 'resource://raw/notification_sound',
        ),
      ],
    );
  }


  Future<void> saveData(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    String formattedTime = DateFormat('HH:mm a').format(DateTime.now());


    RenderRepaintBoundary boundary = qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    String qrImageBase64 = base64Encode(pngBytes);

    List<String> dataList = [
      phoneNumber,
      ipAddress ?? '',
      randomNumber.toString(),
      qrImageBase64,
      formattedTime
    ];

    List<String> allData = prefs.getStringList('allUserData') ?? [];
    allData.add(jsonEncode(dataList));
    await prefs.setStringList('allUserData', allData);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LastLoginScreen()),
    );
  }


  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? dataList = prefs.getStringList('userData');
    if (dataList != null) {
      print("Stored Data: $dataList");
    }
  }


  void logout(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }


}