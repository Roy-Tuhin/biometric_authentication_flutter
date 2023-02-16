import 'package:BioAuth/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';

class FingerprintAuth extends StatefulWidget {
  const FingerprintAuth({Key? key}) : super(key: key);

  @override
  _FingerprintAuthState createState() => _FingerprintAuthState();
}

class _FingerprintAuthState extends State<FingerprintAuth>{
  //6 digit pin code
  String pin = "123456";
  TextEditingController pinController = TextEditingController();
  final auth = LocalAuthentication();
  String authorized = " not authorized";
  bool _canCheckBiometric = false;
  late List<BiometricType> _availableBiometric;
  bool face = false;
  bool fingerprint = false;

  Future<void> _authenticate() async {
    bool authenticated = false;

    String localizedReason;
    if (face && fingerprint) {
      localizedReason = "Scan your face or fingerprint to authenticate";
    } else if (face) {
      localizedReason = "Scan your face to authenticate";
    } else if (fingerprint) {
      localizedReason = "Scan your fingerprint to authenticate";
    } else {
      return; // No biometric authentication available
    }

    try {
      authenticated = await auth.authenticate(
        localizedReason: localizedReason,
        useErrorDialogs: true,
        stickyAuth: true,
        biometricOnly: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    setState(() {
      authorized = authenticated ? "Authorized success" : "Failed to authenticate";
      print(authorized);
      if (authenticated == true) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    });
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

  Future _getAvailableBiometric() async {
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
  void initState() {
    _checkBiometric();
    _getAvailableBiometric();
    super.initState();

        pinController.addListener(() {
      // Check if the entered MPIN is correct
      if (pinController.text == '123456') {
        // Navigate to HomePage if the MPIN is correct
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
      var screenWidthVar = MediaQuery.of(context).size.width;
    var screenHeightVar = MediaQuery.of(context).size.height;
    var blockSizeHorizontal = (screenWidthVar / 100);
    var blockSizeVertical = (screenHeightVar / 100);

    double getProportionateScreenHeight(double inputHeight) {
      double? screenHeight = screenHeightVar;
      // 812 is the layout height that designer use
      return (inputHeight / 812.0) * screenHeight;
    }

// Get the proportionate height as per screen size
    double getProportionateScreenWidth(double inputWidth) {
      double? screenWidth = screenWidthVar;
      // 375 is the layout width that designer use
      return (inputWidth / 375.0) * screenWidth;
    }
    return
    Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
           title:   Text(
                                "Welcome Back",
                                style: TextStyle(
                                  fontFamily: "Muli",
                                  color: Colors.black,
                                  fontSize: getProportionateScreenWidth(28),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              centerTitle: true,
          backgroundColor:Colors.white,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Positioned(
                      top: 100,
                      right: -50,
                      child: 
                         Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color(0XFF385277)),
                        ),
                      ),
                  Positioned(
                      top: 10,
                      left: -50,
                      
                       
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Color(0XFF385277)),
                        ),
                      ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(height: screenHeightVar * 0.02),
                         
                            
                            Text("Sign in with your Biometric or email",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: "Muli")),
                            
                            SizedBox(height: screenHeightVar * 0.02),
        
                            Container(
                                height: getProportionateScreenHeight(180),
                             child: Lottie.network(
                                    'https://assets1.lottiefiles.com/packages/lf20_idfHDi.json',
                                    fit: BoxFit.cover,
                                  ),
                                ),
        
                            // SizedBox(height: screenHeightVar * 0.02),
        
                            //===============================================================================================================
                            Form(
                              // key: formkey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                               
                                  
                                   SizedBox(height: screenHeightVar * 0.05),
        
                                 Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFf0f0f0),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      margin: EdgeInsets.all(10),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8.0),
        

        
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          maxLength: 6,
                                          controller: pinController,
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      getProportionateScreenWidth(20),
                                                  vertical:
                                                      getProportionateScreenWidth(
                                                          15)),
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              hintText: "Use your 6 digit MPIN",
                                              hintStyle: TextStyle(
                                                  color:
                                                      Colors.black.withOpacity(0.4)),
                                              prefixIcon:
                                                  Icon(Icons.pin, size: 13.0)),

                                        ),
                                      ),
                                    ),
                                  
                                  
                                 
                                
                                  
                                  InkWell(
                                    onTap: () {
                                    _authenticate();
                                    },
                                    child: Container(
                                        width: double.infinity,
                                        height: getProportionateScreenHeight(56),
                                        margin: const EdgeInsets.all(5.0),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(20),
                                            color: Color(0xFFf0f0f0)),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                             Container(
                                              height: getProportionateScreenHeight(180),
                                               child: Lottie.network(
                                                  'https://assets1.lottiefiles.com/packages/lf20_idfHDi.json',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            Text(
                                              'Use Biometric',
                                              style: TextStyle(
                                                  color: Colors.black, ),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                  
                                ],
                              ),
                            ),
        
                            //===============================================================================================================
                            SizedBox(height: screenHeightVar * 0.02),      
                            SizedBox(height: screenHeightVar * 0.02),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  }
}
