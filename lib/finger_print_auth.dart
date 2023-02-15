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

class _FingerprintAuthState extends State<FingerprintAuth> {
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
        statusBarIconBrightness: Brightness.light, // For Android (dark icons)
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
        
                                  /////////////////Email///////////////////////////
                                 Container(
                                      decoration: BoxDecoration(
                                        // color: kSecondaryColor.withOpacity(0.1),
                                        color: Color(0xFFf0f0f0),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      margin: EdgeInsets.all(10),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8.0),
        
                                        ////////////////////////Enter email//////////////////////////////
        
                                        child: TextFormField(
                                         // controller: emailController,
                                          keyboardType: TextInputType.text,
        
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
                                              hintText: "Enter your Email",
                                              hintStyle: TextStyle(
                                                  color:
                                                      Colors.black.withOpacity(0.4)),
                                              prefixIcon:
                                                  Icon(Icons.mail, size: 13.0)),
        
                                          // decoration: InputDecoration(
                                          //     prefixIcon: Icon(
                                          //       Icons.mail,
                                          //       size: 13.0,
                                          //     ),
                                          //     fillColor: Color(0XFF6A62B7).withAlpha(50),
                                          //     border: InputBorder.none,
                                          //     hintText: 'Enter your Email | Phone no.',
                                          //     hintStyle: TextStyle(color: Colors.grey),
                                          //     //labelText: 'Enter your Email | Phone no.',
                                          //     labelStyle: TextStyle(
                                          //         color: Colors.grey,
                                          //         fontSize: 13,
                                          //         fontFamily: 'Muli')),
        
                                          //=======================================================
                                          validator: (value) {
                                            
                                          },
                                          //=======================================================
        
                                          // validator: (value) {
                                          //   if (!RegExp(
                                          //           "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                          //       .hasMatch(value!)) {
                                          //     return 'Please enter a valid Email';
                                          //   } else if (value == null) {
                                          //     emailController =
                                          //         '' as TextEditingController;
                                          //   }
                                          //   return null;
                                          // },
                                          // onSaved: (name) {
                                          //   emailController =
                                          //       name as TextEditingController;
                                          // },
                                        ),
                                      ),
                                    ),
                                  
                                  Container(
                                      decoration: BoxDecoration(
                                        // color: kSecondaryColor.withOpacity(0.1),
                                        color: Color(0xFFf0f0f0),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      margin: EdgeInsets.all(10),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8.0),
        
                                        ////////////////////////////Password//////////////////////////////
        
                                        child: TextFormField(
        
        
                                          decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                  
                                                  });
                                                },
                                                color: Theme.of(context)
                                                    .accentColor
                                                    .withOpacity(0.4),
                                                icon: Icon(
                                                 
                                                     
                                                     Icons.visibility,
                                                  size: 17,
                                                ),
                                              ),
                                              contentPadding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      getProportionateScreenWidth(20),
                                                  vertical:
                                                      getProportionateScreenWidth(
                                                          15)),
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              hintText: "Enter your password",
                                              hintStyle: TextStyle(
                                                  color:
                                                      Colors.black.withOpacity(0.4)),
                                              prefixIcon:
                                                  Icon(Icons.lock, size: 13.0)),
        
                                          // decoration: InputDecoration(
                                          //   prefixIcon: Icon(
                                          //     Icons.lock,
                                          //     size: 13.0,
                                          //   ),
                                          // suffixIcon: IconButton(
                                          //   onPressed: () {
                                          //     setState(() {
                                          //       hidepassword = !hidepassword;
                                          //     });
                                          //   },
                                          //   color: Theme.of(context)
                                          //       .accentColor
                                          //       .withOpacity(0.4),
                                          //   icon: Icon(
                                          //     hidepassword
                                          //         ? Icons.visibility_off
                                          //         : Icons.visibility,
                                          //     size: 17,
                                          //   ),
                                          // ),
                                          // fillColor: Colors.white,
                                          // border: InputBorder.none,
                                          // hintText: 'Enter your password',
                                          // hintStyle: TextStyle(
                                          //     color: Colors.grey, fontFamily: 'Muli'),
                                          // labelText: 'Enter your password',
                                          // labelStyle: TextStyle(
                                          //     color: Colors.grey,
                                          //     fontSize: 13,
                                          //     fontFamily: 'Muli'),
                                          // ),
        
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Enter password';
                                            } else {
                                              return null;
                                            }
                                          },
                                          // onSaved: (pass) {
                                          //   passwordontroller =
                                          //       pass as TextEditingController;
                                          // },
                                        ),
                                      ),
                                    ),
                                 
                                  Row(
                                      children: [
                                        Checkbox(
                                          value: true,
                                          activeColor: Colors.green,
                                          onChanged: (value) {
                                            setState(() {
                                            //  remember = value;
                                            });
                                          },
                                        ),
                                        Text("Remember me"),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                          
                                          },
                                          // Navigator.pushNamed( context, ForgotPasswordScreen.routeName),
                                          child: Text(
                                            "Forgot Password ?",
                                            style: TextStyle(fontFamily: "Muli"),
                                          ),
                                        )
                                      ],
                                    ),
                                  
                                  InkWell(
                                    // onTap: validate,
                                    onTap: () {
                                    _authenticate();
        
                                      // // validate();
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => HomeScreen()));
                                    },
                                    child: Container(
                                        width: double.infinity,
                                        height: getProportionateScreenHeight(56),
                                        margin: const EdgeInsets.all(5.0),
                                        alignment: Alignment.center,
                                        //  height: blockSizeVertical*7.5,
                                        //  width: blockSizeHorizontal*60,
                                        // margin: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(20),
                                            color: Color(0XFF385277)),
                                        child: Text(
                                          'Authenticate',
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  
                                ],
                              ),
                            ),
        
                            //===============================================================================================================
                            SizedBox(height: screenHeightVar * 0.02),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     SocalCard(
                            //       icon: "assets/icons/google-icon.svg",
                            //       press: () {},
                            //     ),
                            //     SocalCard(
                            //       icon: "assets/icons/facebook-2.svg",
                            //       press: () {},
                            //     ),
                            //     SocalCard(
                            //       icon: "assets/icons/twitter.svg",
                            //       press: () {},
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(height: screenHeightVar * 0.02),
                            //NoAccountText(),
         Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don’t have an account? ",
                                    style: TextStyle(
                                       ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                     
                                    },
                                    //Navigator.pushNamed(context, SignUpScreen.routeName),
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle(
                                          
                                         ),
                                    ),
                                  ),
                                ],
                              ),
                            
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
