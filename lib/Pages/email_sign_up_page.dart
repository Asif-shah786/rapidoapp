import 'package:flutter/material.dart';
import 'package:rapido_app/Pages/email_sign_in_page.dart';
import 'package:rapido_app/models/signupmodel/signup_request_model.dart';

import '../services/api_service.dart';

class EmailSignUpPage extends StatefulWidget {
  static const routeName = '/signup';
  const EmailSignUpPage({Key? key}) : super(key: key);

  @override
  _EmailSignUpPageState createState() => _EmailSignUpPageState();
}

class _EmailSignUpPageState extends State<EmailSignUpPage> {
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  //bool isAPICallProcess = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: height,
          width: width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: width,
                  height: height * 0.35,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35),
                      bottomRight: Radius.circular(35),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image(
                      //   width: width / 2,
                      //   image: const AssetImage('assets/ride2.png'),
                      //   fit: BoxFit.fill,
                      // ),
                      Text(
                        'Rapido',
                        style: TextStyle(
                            fontSize: width * 0.09,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(width * 0.05),
                  child: Text(
                    "Signup",
                    style: TextStyle(
                      fontSize: width * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: width * 0.02),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            if (value.length < 3) {
                              return 'username should be more then 2 letters';
                            }

                            return null;
                          },
                          keyboardType: TextInputType.text,
                          controller: _usernameController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: 'Username',
                            suffixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: width * 0.01),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            suffixIcon: const Icon(
                              Icons.mail,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: width * 0.01),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passwordController,
                          obscureText: hidePassword,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                hidePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: width * 0.01),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            if (value != _passwordController.text) {
                              return 'Not Match';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          controller: _confirmPasswordController,
                          obscureText: hideConfirmPassword,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintText: 'Confirm password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                hideConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  hideConfirmPassword = !hideConfirmPassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: width * 0.01),
                      Padding(
                        padding: EdgeInsets.all(width * 0.03),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.yellow,
                                ),
                                foregroundColor: MaterialStateProperty.all(
                                  Colors.black,
                                ),
                              ),
                              child: const Text('SignUp'),
                              onPressed: () {
                                if (validateAndSave()) {
                                  // setState(() {
                                  //   isAPICallProcess = false;
                                  // });
                                  SignupRequestModel model = SignupRequestModel(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    username: _usernameController.text,
                                  );
                                  ApiService.regiser(model).then(
                                    (response) {
                                      if (response.data != null) {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(builder: (_) => EmailSignInPage()),
                                            (route) => false);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content:
                                                  Text(response.message ?? '')),
                                        );
                                      }
                                    },
                                  );
                                  // } else {
                                  //   ScaffoldMessenger.of(context).showSnackBar(
                                  //     const SnackBar(content: Text('ERROR')),
                                  //   );

                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: width * 0.01),
                      InkWell(
                        child: Text(
                          'Already have an account? Login',
                          style: TextStyle(
                              fontSize: width * 0.037,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (_) => EmailSignInPage()),);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: width * 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    } else {
      return false;
    }
  }
}
