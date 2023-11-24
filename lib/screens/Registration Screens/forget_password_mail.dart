import 'package:flutter/material.dart';
import 'package:regexed_validator/regexed_validator.dart';

class ForgetPasswordMailScreen extends StatefulWidget {
  const ForgetPasswordMailScreen({super.key});

  @override
  State<ForgetPasswordMailScreen> createState() =>
      _ForgetPasswordMailScreenState();
}

class _ForgetPasswordMailScreenState extends State<ForgetPasswordMailScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.orange,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.1,
              ),
              Image.asset(
                "images/forgetpassword.png",
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Text(
                "Forget Password",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: size.width * 0.07),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Text(
                "Please enter your e-mail address below to receive a link for resting your password",
                style: TextStyle(fontSize: size.width * 0.04),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              Form(
                key: _formKey,
                child: Container(
                  constraints: const BoxConstraints(minHeight: 50),
                  child: TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.account_circle_rounded),
                          labelText: "Email Address",
                          border: OutlineInputBorder(
                              gapPadding: 3.3,
                              borderRadius: BorderRadius.circular(20))),
                      validator: (value) {
                        if (!validator.email(value!)) {
                          return "Please enter valid email address";
                        }
                        return null;
                      }),
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              SizedBox(
                width: size.width,
                height: 50,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          return Colors.deepOrange;
                        }),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        //
                        // setState(() {
                        //   _data.name = _data.name;
                        // });
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("All is good")));
                      }
                    },
                    child: const Text("Submit")),
              )
            ],
          ),
        ),
      ),
    );
  }

  /*void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _ErrorMessage = "Email cannot be empty";
      });
    } else if (!RegExp(r"\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b").hasMatch(val)) {
      setState(() {
        _ErrorMessage = "Invalid Email Address";
      });
    } else {
      setState(() {
        _ErrorMessage = "";
      });
    }
  }*/
}
