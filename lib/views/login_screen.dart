import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:sample_task/controllers/login_controllers.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController controller = LoginController();

  bool isOtpSent = false;
  int remainingTime = 0;
  Timer? timer;
  bool isResendButtonVisible = false;

  @override
  void initState() {
    super.initState();
    controller.initializeNotifications();
  }

  void sendOtp() async {
    final random = Random();
    setState(() {
      controller.generatedOtp = (100000 + random.nextInt(900000)).toString();
      isOtpSent = true;
      remainingTime = 25;
      isResendButtonVisible = false;
    });

    print('Generated OTP: ${controller.generatedOtp}');

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: 'otp_channel',
        title: 'Vijay Sample App',
        body: 'Your OTP is ${controller.generatedOtp}',
        notificationLayout: NotificationLayout.Messaging,
      ),
    );

    startTimer();
  }

  void startTimer() {
    if (timer != null) {
      timer!.cancel();
    }

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          isResendButtonVisible = true;
          timer!.cancel();
        }
      });
    });
  }

  void verifyOtp() {
    if (controller.otpController.text == controller.generatedOtp) {
      Navigator.pushNamed(context, '/dashboard', arguments: controller.phoneController.text);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Colors.grey.shade900,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 240),
            Text('Login', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 40)),
            SizedBox(height: 20),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 40, left: 24, right: 24, bottom: 24),
                    decoration: BoxDecoration(
                      color: Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'Phone number',
                            filled: true,
                            fillColor: Colors.black,
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 10),
                        if (isOtpSent)
                          TextField(
                            controller: controller.otpController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'OTP',
                              filled: true,
                              fillColor: Colors.black,
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                        SizedBox(height: 10),
                        if (!isOtpSent)
                          ElevatedButton(
                            onPressed: () {
                              if (controller.phoneController.text.isNotEmpty) {
                                sendOtp();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Please enter a phone number')),
                                );
                              }
                            },
                            child: Text('Send OTP', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        if (isResendButtonVisible)
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isOtpSent = false;
                                remainingTime = 0;
                                isResendButtonVisible = false;
                              });
                              sendOtp();
                            },
                            child: Text('Resend OTP', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        if (remainingTime > 0 && !isResendButtonVisible)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Wait for ${remainingTime}s to resend OTP',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        if (isOtpSent && !isResendButtonVisible)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: verifyOtp,
                              child: Text('LOGIN', style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[800],
                                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),

                      ],
                    ),
                  ),


                ],
              ),
            ),
            // SizedBox(height: 190,),
            // Text('Developed By Vijay Arther', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.phoneController.dispose();
    controller.otpController.dispose();
    timer?.cancel();
    super.dispose();
  }
}
