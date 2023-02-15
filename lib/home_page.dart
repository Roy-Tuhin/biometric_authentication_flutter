

// ignore_for_file: prefer_const_constructors

import 'package:BioAuth/finger_print_auth.dart';
import 'package:BioAuth/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Color(0xffEFF1F3),
        appBar:AppBar(
  // ignore: prefer_const_constructors
              title: Text(
                "Home Page",
                style: TextStyle(
                  fontFamily: "Muli",
                  color: Colors.black,
                  fontSize:28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFf0f0f0), Colors.white],
                  ),
                ),
              ),
            ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          //add asset image
            Image.asset('assets/images/408.png',fit: BoxFit.cover,),
            SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: buildLogoutButton(context),
            )
          ],
        ),
      );

  Widget buildLogoutButton(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color(0XFF385277),
          minimumSize: Size.fromHeight(50),
        ),
        child: Text(
          'Logout',
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => FingerprintAuth()),
        ),
      );
}
