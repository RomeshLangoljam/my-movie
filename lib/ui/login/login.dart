import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movies_record/auth/firebase_service.dart';
import 'package:movies_record/ui/home/homepage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    /*try {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print(user?.displayName);
      }
    }catch(e){
    }*/
    super.initState();
  }

  bool showSkipLogin = true;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 243, 247, 1),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 25),
                    RichText(
                        text: TextSpan(
                            text: "WEL",
                            style: TextStyle(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                            children: <TextSpan>[
                          TextSpan(
                              text: "COME",
                              style: TextStyle(
                                  color: Colors.pinkAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30))
                        ])),
                    SizedBox(
                      height: 25,
                    ),
                    RichText(
                        text: TextSpan(
                            text: "T",
                            style: TextStyle(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                            children: <TextSpan>[
                          TextSpan(
                              text: "O",
                              style: TextStyle(
                                  color: Colors.pinkAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30))
                        ])),
                    SizedBox(
                      height: 25,
                    ),
                    RichText(
                        text: TextSpan(
                            text: "MY",
                            style: TextStyle(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                            children: <TextSpan>[
                          TextSpan(
                              text: " MOVIES",
                              style: TextStyle(
                                  color: Colors.pinkAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30))
                        ])),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
                width: 450,
                child: Center(
                  child: ElevatedButton(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "images/search.png",
                              width: 30,
                              height: 30,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(width: 10),
                            Text("Sign In with Google",
                                style: TextStyle(
                                  color: Color.fromRGBO(102, 102, 102, 1),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ))
                          ],
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: BorderSide(color: Colors.blue)))),
                      onPressed: () async {
                        try {
                          FirebaseService fire = FirebaseService();
                          await fire.signInwithGoogle();
                          Future.delayed(Duration(seconds: 2)).then((value) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ));
                          });
                        } catch (e) {
                          if (e is FirebaseAuthException) {
                            showToast(e.message!);
                            setState(() {
                              showSkipLogin = true;
                            });
                          }
                        }
                      }),
                ),
              ),
              showSkipLogin
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ));
                      },
                      child: Center(
                        child: Text("Skip"),
                      ),
                    )
                  : SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }

  showToast(String text) {
    Fluttertoast.showToast(
        msg: "$text",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
