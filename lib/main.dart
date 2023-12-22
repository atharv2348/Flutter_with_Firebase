import 'package:assignment/backend.dart';
import 'package:assignment/firebase_options.dart';
import 'package:assignment/new_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 640),
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: GoogleFonts.nunito().fontFamily),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              // snapshot.hasData
              if (snapshot.hasData) {
                // return Group1();
                return NewScreen();
              } else {
                return HomePage();
              }
            },
          ),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //* Colors used in page
  final purpleColor = Color(0xff6688FF);

  final darkTextColor = Color(0xff1F1A3D);

  final lightTextColor = Color(0xff999999);

  final textFieldColor = Color(0xffF5F6FA);

  final borderColor = Color(0xffD9D9D9);

  Widget getTextFields(
      {required String hint, TextEditingController? controller}) {
    return TextField(
      onChanged: (value) {
        controller?.text = value;
      },
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.transparent, width: 0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.transparent, width: 0),
        ),
        filled: true,
        fillColor: textFieldColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
      ),
    );
  }

  void showErrorSnackbar(BuildContext context, String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            //* or
            // horizontal: ScreenUtil().setWidth(24)
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 52.h),
                Text(
                  "Sign ups to Materminds",
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: darkTextColor),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Wrap(
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: lightTextColor),
                    ),
                    Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: purpleColor),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                getTextFields(
                    hint: "Signin email", controller: emailController),
                SizedBox(height: 16.h),
                getTextFields(hint: "Email", controller: emailController),
                SizedBox(height: 16.h),
                getTextFields(hint: "Password", controller: passwordController),
                SizedBox(height: 16.h),
                getTextFields(
                    hint: "Signin Password", controller: passwordController),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      print(
                          emailController.text + " " + passwordController.text);

                      try {
                        await BackEnd.CreateUser(
                            email: emailController.text,
                            password: passwordController.text);
                        print("Account created Successfully!!");
                      } catch (e) {
                        print(e);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(purpleColor),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                          horizontal: 105.w, vertical: 14.h)),
                      textStyle: MaterialStateProperty.all(TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w700)),
                    ),
                    child: const Text("Create Account"),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      try {
                        final user = await BackEnd.SignInUser(
                            email: emailController.text,
                            password: passwordController.text);

                        if (user != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const NewScreen()));
                        }
                        print("SignIn Scuccessfully!!!");
                      } catch (e) {
                        print(e);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(purpleColor),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                          horizontal: 105.w, vertical: 14.h)),
                      textStyle: MaterialStateProperty.all(TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w700)),
                    ),
                    child: const Text("SignIn"),
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(child: Divider(endIndent: 16.w)),
                    Text("or Sign up via",
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: lightTextColor)),
                    Expanded(child: Divider(indent: 16.w)),
                  ],
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      try {
                        final GoogleSignInAccount? gAcc =
                            await GoogleSignIn().signIn();
                        final GoogleSignInAuthentication gAuth =
                            await gAcc!.authentication;
                        final credential = GoogleAuthProvider.credential(
                            idToken: gAuth.idToken,
                            accessToken: gAuth.accessToken);
                        await FirebaseAuth.instance
                            .signInWithCredential(credential)
                            .then((value) => NewScreen());
                      } catch (e) {
                        showErrorSnackbar(context, e.toString());
                        print(e);
                      }
                    },
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                          BorderSide(color: borderColor)),
                      foregroundColor: MaterialStateProperty.all(darkTextColor),
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                          horizontal: 106.w, vertical: 14.h)),
                      textStyle: MaterialStateProperty.all(TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w700)),
                    ),
                    child: Text("Google"),
                  ),
                ),
                SizedBox(height: 16.h),
                Wrap(
                  children: [
                    Text(
                      "By signing up to Masterminds  you agreee to our",
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: lightTextColor),
                    ),
                    Text(
                      "terms and condition",
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: purpleColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
