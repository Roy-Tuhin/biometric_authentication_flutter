

// ignore_for_file: prefer_const_constructors

import 'package:BioAuth/finger_print_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final auth = LocalAuthentication();
  String authorized = " not authorized";
  bool _canCheckBiometric = false;
  late List<BiometricType> _availableBiometric;
  bool face = false;
  bool fingerprint = false;
  String _selectedAuthMethod = 'Fingerprint'; // Default auth method is fingerprint

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkBiometric();
    _getAvailableBiometric();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _authenticateWithSelectedMethod();
    }
  }

  Future<void> _authenticateWithSelectedMethod() async {
    bool authenticated = false;
    String localizedReason;

    if (_selectedAuthMethod == 'Fingerprint') {
      if (fingerprint) {
        localizedReason = "Scan your fingerprint to authenticate";
      } else {
        return; // Fingerprint authentication not available
      }
    } else if (_selectedAuthMethod == 'MPIN') {
      if (_isCorrectMpin('123456')) {
        authenticated = true;
      } else {
        authorized = "Failed to authenticate with MPIN";
      }
      setState(() {
        authorized = authenticated ? "Authorized success" : "Failed to authenticate";
        print(authorized);
      });
      return;
    }

   while (!authenticated) {
  //alert box with  two button in flutter  =>MPIN and finger print
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Center(child: Text('Please authentication with MPIN or Fingerprint')),
      content: TextField(
        //hinttext
              decoration: InputDecoration(hintText: 'Enter your 6 digit MPIN'),
             obscureText: true,
             maxLength: 6,
             onChanged: (value) {
               if (_isCorrectMpin(value)) {
                 authenticated = true;
                 Navigator.of(context).pop(); // Dismiss the alert dialog
               }
             },
           ),
      actions: [

            TextButton(
              onPressed: ()async {
                _selectedAuthMethod = 'Fingerprint';
                try {
                  authenticated = await auth.authenticate(
                    localizedReason: "localizedReason",
                    useErrorDialogs: true,
                    stickyAuth: true,
                    biometricOnly: true,
                  );
                   if (authenticated) {
                  Navigator.of(context).pop(); // Dismiss the alert dialog
                }
                } on PlatformException catch (e) {
                  print(e);
                }

              },
              child: Text('Fingerprint'),
            ),
            //cancel button to exit the app
            TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: Text('Cancel'),
            ),
          ],
        ),
      );
     
      setState(() {
        authorized = authenticated ? "Authorized success" : "Failed to authenticate";
        print(authorized);
      });
    }
  }

  bool _isCorrectMpin(String mpin) {
    // Check if the given MPIN matches the actual MPIN (in this case, "123456")
    return mpin == '123456';
  }

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;

    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future<void> _getAvailableBiometric() async {
    List<BiometricType> availableBiometric = [];

    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    setState(() {
      _availableBiometric = availableBiometric;
      face = availableBiometric.contains(BiometricType.face);
      fingerprint = availableBiometric.contains(BiometricType.fingerprint);
    });
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop(); // Exit app if back button is pressed
          return true;
        },
      child: Scaffold(
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
                    statusBarColor: Color(0xffEFF1F3),
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
            body: SingleChildScrollView(
              child: Column(
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
            ),
          )
    
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
