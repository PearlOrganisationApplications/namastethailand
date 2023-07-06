import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:namastethailand/CreateAccount/signUp.dart';
import 'package:namastethailand/Dashboard/dashboard.dart';
import 'package:namastethailand/widget/api_services.dart';
import 'package:namastethailand/widget/otpForFogetPassword.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io';
import 'UserProfile/otpScreen.dart';
import 'Utility/sharePrefrences.dart';
import 'core/constants/my_colors.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> signInWithGooogle() async {
    final googleUser = await GoogleSignIn(
      scopes: ['email', 'profile', 'openid',],
      clientId: '471866643979-mlq0gvg8sj9vt1o1puh5a5bpvpp511b4.apps.googleusercontent.com'
    ).signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if(googleAuth.idToken == null){
        EasyLoading.showError('Login failed, unable to generate token!');
      }else{
        performLogin(type: 'google', email: googleUser.email, password: '', name: googleUser.displayName, clientToken: googleUser.email, appleId: '');
      }
    } else {
      EasyLoading.showError('Login failed!');
      print("User sign-in failed or missing required properties");
    }
  }

  Dio dio = Dio();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                // email
                // password
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Image.asset("assets/icons/namasteThai.png"),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                    border: InputBorder.none, hintText: 'Email'),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: TextField(
                                controller: _passController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none, hintText: 'Password'),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: GestureDetector(
                            onTap: () {

                               if(_emailController.text.isEmpty || _passController.text.isEmpty){
                                 showTopSnackBar(context);
                               }
                             else if(_formKey.currentState!.validate()){
                                performLogin(type: 'normal', email: _emailController.text, password: _passController.text);
                              }
                              //_onSubmit();
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                decoration: BoxDecoration(
                                    color: Colors.orangeAccent,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Center(
                                    child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.sp),
                                ))),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Enter your email'),
                                    content: TextFormField(
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        hintText: 'Email',
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text('Next'),
                                        onPressed: () async {

                                          if(_emailController.text != ''){
                                            EasyLoading.show();
                                            Response? response = await Api.forgotPassword(email: _emailController.text);
                                            EasyLoading.dismiss();
                                            if(response == null){
                                              EasyLoading.showToast('Unable to communicate to server!');
                                            }else if(response.data['status'] == "true"){
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        OtpScreenForgetPassword(
                                                            email: _emailController.text
                                                                .toString())),
                                              );
                                            }else if(response.data['status'] == "false"){
                                              EasyLoading.showToast(response.toString());

                                            }else{
                                              EasyLoading.showToast(response.toString());

                                            }
                                          }else{
                                            EasyLoading.showToast('Enter your email!');
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text("Forgot your password",style: TextStyle(fontSize: 8.sp, color: Colors.purpleAccent),)),

                        GestureDetector(
                            onTap: (){
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context)=>Dashboard()));
                            },
                            child: Text("Login as a guest",
                              style: GoogleFonts.aBeeZee( color: Colors.red,
                                  fontSize: 7.sp, fontWeight: FontWeight.w500),)),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Not a member?',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 7.sp,
                                    letterSpacing: 1)),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SignUp(),
                                  ),
                                );
                              },
                              child: Text('Register',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 7.sp,
                                      color: Colors.blue,
                                      letterSpacing: 1)),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: Divider(
                              color: Colors.blueGrey,
                            )),
                            Text(
                              "Or Login With",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 7.sp,
                                  letterSpacing: 1),
                            ),
                            Expanded(
                                child: Divider(
                              color: Colors.blueGrey,
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Platform.isIOS?
                            GestureDetector(
                              onTap: () async{
                                try {

                                  final credential = await SignInWithApple.getAppleIDCredential(
                                    scopes: [
                                      AppleIDAuthorizationScopes.email,
                                      AppleIDAuthorizationScopes.fullName,
                                    ],
                                  );


                                  if(credential.userIdentifier != null){
                                    performLogin(type: 'apple', email: '${credential.userIdentifier}@apple.com', clientToken: '${credential.userIdentifier}', name: '${credential.givenName} ${credential.familyName}');
                                  }else{
                                    EasyLoading.showError('Login failed!');
                                  }

                                  //credential.
                                }catch (exception) {
                                  print('error:' + exception.toString());
                                }
                              },

                              child: BlurryContainer(
                                height: 50.h,
                                width: 40.w,
                                blur: 10,
                                elevation: 1,
                                color: Colors.white,
                                child: Center(
                                  child: Icon(
                                    Icons.apple,
                                    color: Colors.black,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                            ):


                            GestureDetector(
                              onTap: () async {
                                await signInWithGooogle();
                                /*if (mounted) {
                                  Navigator.pushReplacement<void, void>(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          Dashboard(),
                                    ),
                                  );
                                }*/
                              },
                              child:
                              BlurryContainer(
                                height: 70,
                                width: 70,
                                blur: 10,
                                elevation: 1,
                                color: Colors.white,
                                padding: EdgeInsets.all(25),
                                child: Image.asset("assets/icons/google.png"),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  Future<void> performLogin({required String type, String? email, String? password, String? name, String? clientToken, String? appleId}) async {
    EasyLoading.show();
    Response? response = await Api.signInWithOptions(email: email, idToken: clientToken, name: name, type: type, appleId: appleId, password: password);

    EasyLoading.dismiss();
    print(response.toString());
    if(response == null){
      EasyLoading.showToast('Unable to communicate to server!');

    }else if(response.data['status'].toString() == "201"){
      EasyLoading.showToast('Login successful!');

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                Dashboard(),
          ));
    }else if(response.data['status'] == "501"){
      EasyLoading.showToast('Invalid Credential');
      print('No Data Available');
    }else{
      EasyLoading.showToast(response.toString());
      print(response.toString());
    }

  }
}
void showTopSnackBar(BuildContext context)=>
    Flushbar(
  icon: Icon(
    Icons.error,
    size: 25.sp,
  ),
  shouldIconPulse: true,
  title: "Error",
    message: "Please check your input fields",
  duration: Duration(seconds: 3),
  flushbarPosition: FlushbarPosition.TOP,
  backgroundColor: Colors.red,
  borderRadius: BorderRadius.circular(20.r),
  margin: EdgeInsets.all(10),
)..show(context);
