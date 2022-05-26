import 'package:flutter/material.dart';
import 'package:rapido_app/Pages/email_sign_up_page.dart';
import 'package:rapido_app/models/loginmodel/login_request_model.dart';
import 'package:rapido_app/services/api_service.dart';

class EmailSignInPage extends StatefulWidget {
  const EmailSignInPage({Key? key}) : super(key: key);

  @override
  _EmailSignInPageState createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage> {
  //bool isAPICallProcess = false;
  bool hidePassword = true;

  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                //const SizedBox(height: 10),
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
                  padding: EdgeInsets.all(width * 0.06),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: width * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: width * 0.03,
                ),
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
                            return null;
                          },
                          controller: mailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            suffixIcon: const Icon(
                              Icons.mail,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: width * 0.02),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: hidePassword,
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
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: width * 0.02),
                      Padding(
                        padding: EdgeInsets.all(width * 0.03),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Forget password ?',
                              style: TextStyle(
                                  fontSize: width * 0.035,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                            ),
                            SizedBox(width: width * 0.3),
                            ElevatedButton(
                              child: const Text('Login'),
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(context, 'HomePage', (rout)=> false);
                                if (validateAndSave()) {
                                  // setState(() {
                                  //   isAPICallProcess = true;
                                  // });
                                  LoginRequestModel model = LoginRequestModel(
                                      email: mailController.text,
                                      password: passwordController.text);
                                  ApiService.login(model).then((response) {
                                    if (response) {
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          "HomePage", (route) => false);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(content: Text('ERROR')),
                                      );
                                    }
                                  });
                                }
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.black),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.yellow),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: width * 0.1),
                      InkWell(
                        child: Text(
                          'Don\'t have an account? Signup ',
                          style: TextStyle(
                              fontSize: width * 0.037,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, 'EmailSignUpPage');
                        },
                      )
                    ],
                  ),
                ),
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
