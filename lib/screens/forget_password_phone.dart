import 'package:flutter/material.dart';
import 'package:regexed_validator/regexed_validator.dart';

class ForgetPasswordPhoneScreen extends StatefulWidget {
  const ForgetPasswordPhoneScreen({super.key});

  @override
  State<ForgetPasswordPhoneScreen> createState() => _ForgetPasswordPhoneScreenState();
}

class _ForgetPasswordPhoneScreenState extends State<ForgetPasswordPhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.white, Colors.orange],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          padding: EdgeInsets.all(30.0),
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
                "Please enter your Phone No. below to receive a OTP for resting your password",
                style: TextStyle(fontSize: size.width * 0.04),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              Form(
                key: _formKey,
                child: Container(
                  constraints: BoxConstraints(minHeight: 50),
                  child: TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone_android_rounded),
                          labelText: "Phone No",
                          border: OutlineInputBorder(
                              gapPadding: 3.3,
                              borderRadius: BorderRadius.circular(20))),
                      validator:(value) {
                        if (!validator.phone(value!)){
                          return "Please enter valid Phone Number";
                        }
                        return null;
                      }
                  ),
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
                            SnackBar(content: Text("All is good")));
                      }
                    },
                    child: Text("Submit")),
              )
            ],
          ),
        ),
      ),
    );
  }
  String _ErrorMessage = "";
  void validatePhoneNo(String val) {
    if (val.isEmpty) {
      setState(() {
        _ErrorMessage = "Field cannot be empty";
      });
    } else if (!RegExp(r"((\+92)?(0092)?(92)?(0)?)(3)([0-9]{9})$").hasMatch(val)) {
      setState(() {
        _ErrorMessage = "Invalid Phone No";
      });
    } else {
      setState(() {
        _ErrorMessage = "";
      });
    }
  }
}
