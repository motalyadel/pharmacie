import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmacie_1/components/textformfield.dart';
import 'package:pharmacie_1/homepage.dart';
import 'package:pharmacie_1/user_auth/firebase_auth_services.dart';
// import 'components/textformfield.dart';
import 'package:google_sign_in/google_sign_in.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {


  final _auths = FirebaseAuthService();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>(); // Clé globale pour le formulaire
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  // Future<void> signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //
  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //
  //   // Once signed in, return the UserCredential
  //    await FirebaseAuth.instance.signInWithCredential(credential);
  //    Navigator.of(context).pushNamedAndRemoveUntil('/homepage', (route)=>false);
  // }



  // Future<void> signInWithGoogle() async {
  //   try {
  //     final GoogleSignIn _googleSignIn = GoogleSignIn(clientId: "YOUR_CLIENT_ID");
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //
  //     if (googleUser == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Google Sign-In was canceled.")),
  //       );
  //       return;
  //     }
  //
  //     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //
  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //     Navigator.of(context).pushNamedAndRemoveUntil('/homepage', (route) => false);
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("An error occurred during Google Sign-In: $e")),
  //     );
  //   }
  // }


  // @override void dispose() {
  //   _emailController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {


    // void _submitForm() {
    //   if (_formKey.currentState!.validate()) {
    //     // Logique pour envoyer les données au backend ou Firebase
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text("Sign up successful!")),
    //     );
    //     // Redirection ou autre logique après inscription
    //     // Navigator.pushNamed(context, '/login');
    //   }
    // }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child:Column(
              children: [Container(
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/org.png'),
                    fit: BoxFit.fill
                    )
                    ),
                    child: Stack(children: [
                    //   Positioned(
                    //     left: 30,
                    //     width: 80,
                    //     height: 150,
                    //     child: Container(
                    //     decoration: BoxDecoration(
                    //       image: DecorationImage(
                    // image: AssetImage('assets/images/phLog.png'),)

                    //     ),
                    //     )
                    //     ),
                      Positioned(
                        right: 0,
                        bottom: 60,
                        width: 180,
                        height: 100,
                        child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                    image: AssetImage('assets/images/log.png'),)

                        ),
                        )
                        ),
                    //   Positioned(
                    //     top: 40,
                    //     right: 40,
                    //     width: 80,
                    //     height: 150,
                    //     child: Container(
                    //     decoration: BoxDecoration(
                    //       image: DecorationImage(
                    // image: AssetImage('assets/images/clock.png'),)

                    //     ),
                    //     )
                    //     ),
                        Positioned(
                          // top: 20,
                          // left: 10,
                          child: Container(
                          // margin: EdgeInsets.only(top: 30),
                          child: Center(child: Text('Login',style: TextStyle(fontSize: 30,color: Colors.white),),),
                        )
                        )
                    ],
                    ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
              child: Column(children: [
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),

                     boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(143, 148, 251, 1),
                          blurRadius: 20.0,
                          offset: Offset(0, 10),
                        ),
                        ],

                  ),
                  child: Column(children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        // border: Border(bottom: BorderSide(color: Colors.grey[100])),

                      ),
                      child: CustomTextForm(hinttext: 'Email or phone number',mycontroller: _emailController, validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email or phone number';
                            } else if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(value) &&
                                !RegExp(r"^\d{8}$").hasMatch(value)) {
                              return 'Enter a valid email or phone number';
                            }
                            return null;
                          },
                        icon:  Icon(Icons.person,
                        color: const Color.fromARGB(224, 253, 192, 39) ,
                        ),
                        obscureText: false,
                      )

                      ),
                    Container(
                      padding: EdgeInsets.all(8.0),

                      // decoration: BoxDecoration(
                      //   // border: Border(bottom: BorderSide(color: Colors.grey[100])),
                      //
                      // ),
                        child: CustomTextForm(hinttext: 'password', mycontroller: _passwordController, validator: (value){
                              if (value == null || value.isEmpty) {
                                return 'Password Dosn\'t be Empty';
                              } else if (value.length < 4) {
                                return 'Password must be at least 4 characters';
                              }
                              return null;
                        },
                          icon: Icon(Icons.lock,
                            color: const Color.fromARGB(224, 253, 192, 39) ,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                              color: const Color.fromARGB(224, 253, 192, 39),
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          obscureText: !_passwordVisible,
                        ),

                      ),
                    ],
                    ),
                ),
                      SizedBox(height: 30,),
                      Container(
                        height: 50,

                        decoration: BoxDecoration(
                          borderRadius:BorderRadius.circular(10),
                          // gradient:
                          // LinearGradient(
                          //   colors:[
                          //     // Color.fromRGBO(143, 148, 251, 1),
                          //     // Color.fromRGBO(143, 148, 251, 6),

                          //     // pour couleur de l'application orange
                          //     Color.fromRGBO(244, 125, 0, 1),
                          //     Color.fromRGBO(244, 225, 0, 6),
                          //     ]
                          //   )
                        ),
                        child: ElevatedButton(onPressed: () async{
                          if (_formKey.currentState!.validate()) {
                            try {
                              final credential = await _auth
                                  .signInWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                              // FirebaseAuth.instance.currentUser!.sendEmailVerification();
                              if (credential.user!.emailVerified){
                                Navigator.pushReplacementNamed(context, '/homepage');
                              }
                              // else{
                              //   FirebaseAuth.instance.currentUser!.sendEmailVerification();
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     const SnackBar(content: Text(
                              //         "Please go to your email and click on the link to verify your account  . ")
                              //     ),
                              //   );
                              // }
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                print('No user found for that email.');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text(
                                      "No user found for that email. ")
                                  ),
                                );
                              } else if (e.code == 'wrong-password') {
                                print('Wrong password provided for that user.');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(
                                      "Wrong password provided for that user. ")
                                  ),
                                );
                              }else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error: ${e.message}")),
                                );
                              }
                            }
                            catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("An unexpected error occurred: $e")),
                              );
                            }
                          }
                          // Navigator.pushNamed(context, "/singup");
                          // if(_formKey.currentState!.validate()){
                          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("login avec succes ")
                          //   ),
                          //   );
                          // //   logique de connextion ont vas ajouter ici ;
                          // //   Navigator.pushNamed(context, '/homepage');
                          // }
                        }, style: OutlinedButton.styleFrom(backgroundColor: Color.fromRGBO(247, 144, 35, 1),),
                         child: Center(child: Text("Log in", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, ),
                        ),
                        ),
                        ),
                        ),
                SizedBox(height: 10,),
                Container(
                  height: 50,

                  decoration: BoxDecoration(
                    borderRadius:BorderRadius.circular(10),
                    // gradient:
                    // LinearGradient(
                    //   colors:[
                    //     // Color.fromRGBO(143, 148, 251, 1),
                    //     // Color.fromRGBO(143, 148, 251, 6),

                    //     // pour couleur de l'application orange
                    //     Color.fromRGBO(244, 125, 0, 1),
                    //     Color.fromRGBO(244, 225, 0, 6),
                    //     ]
                    //   )
                  ),
                  child: ElevatedButton(onPressed: () async{
                    await signInWithGoogle();
                    // Navigator.pushNamed(context, "/login");
                  }, style: OutlinedButton.styleFrom(backgroundColor: Color.fromRGBO(215, 161, 104, 1),),
                    child: Center(child: Text("LOGIN WHITH GOOGLE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, ),
                    ),
                    ),
                  ),
                ),

                        SizedBox(height: 70,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text("Don't have an acount ?  "),
                          GestureDetector(
                            onTap: () {Navigator.pushNamed(context, '/singup');} ,
                            child: Text(" Sing up ", style: TextStyle(fontWeight: FontWeight.bold),))
                          ],
                        ),
                        SizedBox(height: 10,),
                        InkWell(

                          onTap: ()async {
                            if (_emailController.text == ''){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text(
                                    " email doesn't be null . ")
                                ),
                              );
                              return ;
                            }
                            try{
                              await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
                              AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.infoReverse,
                                  animType: AnimType.rightSlide,
                                  title: 'error',
                                  desc: 'Please go to your email and add new password  .'
                              ).show();
                            } catch(e){
                              AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'error',
                                  desc: 'The email you entered is incorrect please try again  .'
                              ).show();
                            }

                          },

                          child: Container(
                              child: Text("Forget Passoword ?", style: TextStyle(color: Color.fromRGBO(244, 125, 0, 3), ),)),
                        )
              ],),),)
              ],

              ) ,

          ),
        ),
      ),
    );
  }
}