import 'package:alzaware/Basic%20Resources/LoadingWidget.dart';
import 'package:alzaware/home.dart';
import 'package:alzaware/signup.dart';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';

class SignInAlzAware extends StatefulWidget {
  const SignInAlzAware({Key? key}) : super(key: key);

  @override
  State<SignInAlzAware> createState() => _SignInAlzAwareState();
}

class _SignInAlzAwareState extends State<SignInAlzAware> {

  String emailVal="", passwordVal = "";
  bool signingIn = false;

  void signInUser() {
      final auth = FirebaseAuth.instance;
      auth.signInWithEmailAndPassword(email: emailVal, password: passwordVal).then((result){
        signingIn = false;
        setState(() {});
        Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeAlzAware(result.user!.uid)));
      }).catchError( (error){
        String errorType = error.toString().substring(15);
        if(errorType.startsWith("user")){
          errorType = "User not found, please sign up!";
        }
        else if(errorType.startsWith("wrong")){
          errorType = "Please enter correct password!";
        }
        else if(errorType.startsWith("too-many")){
          errorType = "Too many login requests, try again later!";
        }
        Toast.show(errorType, textStyle: const TextStyle(color: Colors.red,), backgroundColor: Colors.white, duration: Toast.lengthLong);
      });
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      body: !signingIn?Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 200,
            child: Image(image: AssetImage("assets/images/alzawarelogo.jpg"),),
          ),
          Text("Alzhemist", style: TextStyle(color: Color(0xFF77ADDC), fontWeight: FontWeight.bold, fontSize: 60,),),
          const SizedBox(height: 50,),
          SizedBox(
            width: MediaQuery.of(context).size.width*0.9,
            child: TextField(
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 20),
              decoration: InputDecoration(
                hintText: "Phone number/Email address",
                hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                filled: true,
                fillColor: Colors.grey,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 3,
                      color: Colors.black45,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 3,
                    color: Colors.black45,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (val){
                emailVal = val;
                setState(() {

                });
              },
              cursorColor: Colors.white,
            ),
          ),
          const SizedBox(height: 10,),
          SizedBox(
            width: MediaQuery.of(context).size.width*0.9,
            child: TextField(
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 20),
              obscureText: true,
              onChanged: (val){
                passwordVal = val;
                setState((){});
              },
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                filled: true,
                fillColor: Colors.grey,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 3,
                      color: Colors.black45,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 3,
                    color: Colors.black45,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              cursorColor: Colors.white,
              onSubmitted: (term){
                signingIn = true;
                setState(() {});
                signInUser();
                //Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeAlzAware()));
              },
            ),
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account? ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignUpAlzAware()));
                },
                child: const Text("Create a new account", style: TextStyle(color: Color(0xFF77ADDC),fontSize: 16, fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        ],
      ):LoadingWidget("Signing In"),
    );
  }
}
