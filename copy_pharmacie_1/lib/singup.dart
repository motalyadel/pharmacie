// Mon Page Sign up

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmacie_1/components/textformfield.dart';
import 'package:pharmacie_1/user_auth/firebase_auth_services.dart';

import 'homepage.dart';
// import 'package:copy_pharmacie_1/user_auth/firebase_auth_services.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _auths = FirebaseAuthService();
  late Timer timer;
  @override
  void initState(){
    super.initState();
    _auths.sendEmailVerificationLink();
    timer = Timer.periodic(Duration(seconds: 4), (timer){
      FirebaseAuth.instance.currentUser?.reload();
      if(FirebaseAuth.instance.currentUser?.emailVerified == true ){
        timer.cancel();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage()));
      }
    });
  }


  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>(); // Clé globale pour le formulaire
  final _userController = TextEditingController();
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmeController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

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
  // @override void dispose() {
  //   _userController.dispose();
  //   _emailOrPhoneController.dispose();
  //   _passwordController.dispose();
  //   _passwordConfirmeController.dispose();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    // final _formKey = GlobalKey<FormState>(); // Clé globale pour le formulaire
    // final _userController = TextEditingController();
    // final _emailOrPhoneController = TextEditingController();
    // final _passwordController = TextEditingController();
    // final _passwordConfirmeController = TextEditingController();

    // void _submitForm() {
    //   if (_formKey.currentState!.validate()) {
    //     // Logique pour envoyer les données au backend ou Firebase
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text("Sign up successful!")),
    //     );
    //     // Redirection ou autre logique après inscription
    //     Navigator.pushNamed(context, '/login');
    //   }
    // }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child:Column(
              children: [Container(
                height: 220,
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
                  // image: AssetImage('assets/images/light-1.png'),)

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
                        child: Center(child: Text('Sign up',style: TextStyle(fontSize: 30,color: Colors.white),),),
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
                              color: Color.fromRGBO(239, 160, 107, 0.878),
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
                            child: CustomTextForm(hinttext: 'UserName', mycontroller: _userController, validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a username';
                              }
                              return null;
                            },
                              obscureText: false ,
                              icon: Icon(
                                Icons.person,
                                color: Color.fromARGB(224, 253, 192, 39) ,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              // border: Border(bottom: BorderSide(color: Colors.grey[100])),

                            ),
                            child: CustomTextForm(hinttext: 'Email or phone number', mycontroller: _emailOrPhoneController, validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email or phone number';
                              } else if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(value) &&
                                  !RegExp(r"^\d{8}$").hasMatch(value)) {
                                return 'Enter a valid email or phone number';
                              }
                              return null;
                            },
                              obscureText: false ,
                              icon: Icon(
                                Icons.person,
                                color: Color.fromARGB(224, 253, 192, 39) ,
                              ),
                            ),

                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              // border: Border(bottom: BorderSide(color: Colors.grey[100])),

                            ),
                            child: CustomTextForm(hinttext: 'Password', mycontroller: _passwordController, validator:(value) {
                              if (value == null || value.isEmpty) {
                                return 'Password Dosn\'t be Empty';
                              } else if (value.length < 4) {
                                return 'Password must be at least 4 characters';
                              }
                              return null;
                            } ,
                              obscureText: !_passwordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible ?
                                  Icons.visibility : Icons.visibility_off,
                                  color: const Color.fromARGB(224, 253, 192, 39),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                              icon:const Icon(
                                Icons.lock,
                                color:  Color.fromARGB(224, 253, 192, 39) ,
                              ),

                            ),

                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              // border: Border(bottom: BorderSide(color: Colors.grey[100])),

                            ),
                            child: CustomTextForm(hinttext: 'Confirm Password', mycontroller: _passwordConfirmeController, validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              } else if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                              obscureText: !_confirmPasswordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _confirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: const Color.fromARGB(224, 253, 192, 39),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _confirmPasswordVisible = !_confirmPasswordVisible;
                                  });
                                },
                              ),
                              icon:const Icon(
                                Icons.lock,
                                color:  Color.fromARGB(224, 253, 192, 39) ,
                              ),
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
                              final credential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: _emailOrPhoneController.text,
                                password: _passwordController.text,
                              );
                              FirebaseAuth.instance.currentUser!.sendEmailVerification();
                              if (credential.user!.emailVerified){
                                Navigator.pushReplacementNamed(context, '/homepage');
                              }else{
                                FirebaseAuth.instance.currentUser!.sendEmailVerification();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text(
                                      "Please go to your email and click on the link to verify your account  . ")
                                  ),
                                );
                              }
                              // Navigator.pushReplacementNamed(
                              //     context, "/login");
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'email-already-in-use') {
                                print(
                                    'The account already exists for that email.');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(
                                      "The account already exists for that email. ")
                                  ),
                                );
                              }


                              else if (e.code == 'weak-password') {
                                print('The password provided is too weak.');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(
                                      "The password provided is too weak. ")
                                  ),
                                );
                              }
                              else if (e.code == 'email-already-in-use') {
                                print(
                                    'The account already exists for that email.');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(
                                      "The account already exists for that email. ")
                                  ),
                                );
                              }
                            } catch (e) {
                              print(e);
                            }
                          }
                        },
                        // _signUp,
                          // Navigator.pushNamed(context, "/homepage");
                          style: OutlinedButton.styleFrom(backgroundColor: Color.fromRGBO(247, 144, 35, 1),),
                          child: Center(child: Text("Sign up", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, ),
                          ),
                          ),
                        ),
                      ),
                      // SizedBox(height: 10,),
                      // Container(
                      //   height: 50,
                      //
                      //   decoration: BoxDecoration(
                      //     borderRadius:BorderRadius.circular(10),
                      //     // gradient:
                      //     // LinearGradient(
                      //     //   colors:[
                      //     //     // Color.fromRGBO(143, 148, 251, 1),
                      //     //     // Color.fromRGBO(143, 148, 251, 6),
                      //
                      //     //     // pour couleur de l'application orange
                      //     //     Color.fromRGBO(244, 125, 0, 1),
                      //     //     Color.fromRGBO(244, 225, 0, 6),
                      //     //     ]
                      //     //   )
                      //   ),
                      //   child: ElevatedButton(onPressed: (){
                      //     Navigator.pushNamed(context, "/login");
                      //   }, style: OutlinedButton.styleFrom(backgroundColor: Color.fromRGBO(215, 161, 104, 1),),
                      //     child: Center(child: Text("LOGIN WHITH GOOGLE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, ),
                      //     ),
                      //     ),
                      //   ),
                      // ),

                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("Already have account ?  "),
                          GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: Text(" Log in ", style: TextStyle(color:Color.fromRGBO(247, 144, 35, 1) ,fontWeight: FontWeight.bold),))
                        ],
                      ),
                      // Text("Already have account ?", style: TextStyle(color: Color.fromRGBO(244, 125, 0, 3), ),)
                    ],
                    ),
                  ),
                )
              ],

            ) ,

          ),
        ),
      ),
    );


  }
  // void _signUp() async {
  //
  //   String username = _userController.text;
  //   String email = _emailOrPhoneController.text;
  //   String password = _passwordController.text;
  //   String passwordConfirme = _passwordConfirmeController.text;
  //
  //   User? userName = await _auth.signInWithEmailAndPassword(email, password);
  //   if (userName != null){
  //     print("User is SuccessfUlly created");
  //     Navigator.pushNamed(context, '/homepage');
  //   }else print("Some error happend");
  //
  // }
}
