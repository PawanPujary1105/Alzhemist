import 'package:alzaware/Basic%20Resources/LoadingWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:toast/toast.dart';

class SignUpAlzAware extends StatefulWidget {
  const SignUpAlzAware({Key? key}) : super(key: key);

  @override
  State<SignUpAlzAware> createState() => _SignUpAlzAwareState();
}

class _SignUpAlzAwareState extends State<SignUpAlzAware> {

  String nameVal="", emailVal="", phoneVal="",passwordVal="", cpasswordVal="";
  FirebaseDatabase fbData = FirebaseDatabase.instance;
  bool signingUp = false;


  void createUser(BuildContext context) async{
    if(emailVal!="" && emailVal.contains('@')){
      if(passwordVal!=""){
        if(passwordVal==cpasswordVal){
          signingUp = true;
          setState(() {});
          final firebaseAuth = FirebaseAuth.instance;
          final fbRef = fbData.ref();
          final dbVal = {"fullname":nameVal,"phone":phoneVal, "email": emailVal};
          try{
            await firebaseAuth.createUserWithEmailAndPassword(email: emailVal, password: passwordVal);
            await fbRef.child(firebaseAuth.currentUser!.uid).set(dbVal);
            signingUp = false;
            setState(() {});
            Navigator.pop(context);
          }
          catch(e){
            String errorType = e.toString().substring(15);
            signingUp = false;
            setState(() {});
            if(errorType.startsWith("email")){
              Toast.show("Email already registered, please signin!", textStyle: const TextStyle(color: Colors.red,), backgroundColor: Colors.white, duration: Toast.lengthLong);
            }
          }
        }
        else{
          Toast.show("Please ensure passwords match!", textStyle: const TextStyle(color: Colors.red,), backgroundColor: Colors.white, duration: Toast.lengthLong);
        }
      }
      else{
        Toast.show("Please ensure password is not empty!", textStyle: const TextStyle(color: Colors.red,), backgroundColor: Colors.white, duration: Toast.lengthLong);
      }
    }
    else{
      Toast.show("Please enter a valid email!", textStyle: const TextStyle(color: Colors.red), backgroundColor: Colors.white, duration: Toast.lengthLong);
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: !signingUp?Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: const Color(0xFF77ADDC),
                padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0, bottom: 20.0),
                child: Text("Create New Account", style: TextStyle(color: Colors.white, fontSize: 22),),
              ),
            ],
          ),
          SizedBox(height: 80,),
          Container(
            width: MediaQuery.of(context).size.width*0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 20),
              decoration: InputDecoration(
                hintText: "Full Name",
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
              onChanged: (val){
                nameVal =val;
                setState(() {

                });
              },
            ),
          ),
          SizedBox(height: 20,),
          SizedBox(
            width: MediaQuery.of(context).size.width*0.9,
            child: TextField(
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 20),
              decoration: InputDecoration(
                hintText: "E-mail",
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
              onChanged: (val){
                emailVal=val;
                setState(() {

                });
              },
            ),
          ),
          SizedBox(height: 20,),
          SizedBox(
            width: MediaQuery.of(context).size.width*0.9,
            child: TextField(
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 20),
              decoration: InputDecoration(
                hintText: "Phone Number",
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
              onChanged: (val){
                phoneVal = val;
                setState(() {

                });
              },
            ),
          ),
          SizedBox(height: 20,),
          SizedBox(
            width: MediaQuery.of(context).size.width*0.9,
            child: TextField(
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 20),
              obscureText: true,
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
              onChanged: (val){
                passwordVal=val;
                setState(() {

                });
              },
            ),
          ),
          SizedBox(height: 20,),
          SizedBox(
            width: MediaQuery.of(context).size.width*0.9,
            child: TextField(
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 20),
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Confirm Password",
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
              onChanged: (val){
                cpasswordVal=val;
                setState(() {

                });
              },
            ),
          ),
          SizedBox(height: 30,),
          Container(
            height: 50,
            width: 150,
            child: ElevatedButton(
              onPressed: (){
                createUser(context);
              },
              child: Text("Sign up", style: TextStyle(fontSize: 18),),
            ),
          ),
        ],
      ):LoadingWidget("Signing Up"),
    );
  }
}