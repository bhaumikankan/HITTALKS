import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:impulse/models/userModel.dart';
import 'package:impulse/screens/botttomnav.dart';
import 'package:impulse/screens/home_page.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth=FirebaseAuth.instance;
  bool isloading=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[800],
        title: Center(child: Text("HIT TALKS",style: GoogleFonts.play(),),),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: SizedBox(
                      height: 300,
                      child: Image.asset('assets/images/login_pic.png',fit: BoxFit.contain,),
                    ),
                  ),
                  SizedBox(height: 0,),
                  /*Text("Welcome to \nHIT TALKS",textAlign: TextAlign.center,style: GoogleFonts.play(
                    textStyle: TextStyle(
                      fontSize:30,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent
                    )
                  ),),*/
                  SizedBox(height: 30,),
                  Material(
                    elevation: 5,
                    color: Colors.lightBlue[800],
                    child: MaterialButton(
                      onPressed: (){
                        signInWithGoogle();
                      },
                      child: isloading?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.white,),
                          SizedBox(width: 10,),
                          Text("Please wait...",style: TextStyle(color: Colors.white),),
                        ],
                      ):Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.android,color: Colors.white,),
                          SizedBox(width: 10,),
                          Text("Sign in with google",style: TextStyle(color: Colors.white),),
                        ],
                      ),
                    ),
                    borderRadius: BorderRadius.circular(30),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    setState(() {
      isloading=true;
    });
    // Once signed in, return the UserCredential
     await _auth.signInWithCredential(credential).then((value) => {
       savetofirestore()
     }).catchError((e){
       Fluttertoast.showToast(msg: e!.message);
     });
  }

  savetofirestore()async{
    User? user=_auth.currentUser;
    UserModel data=UserModel(uid:user!.uid, email:user.email, name:user.displayName, profileimg:user.photoURL);
    var userDocRef=FirebaseFirestore.instance.collection("User").doc(user.uid);
    var doc = await userDocRef.get();
    if (!doc.exists) {
      await userDocRef.set(data.toMap());
    }

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Bottomnav()), (route) => false);
    //Navigator.replace(context, oldRoute: MaterialPageRoute(builder: (context)=>Login()), newRoute: MaterialPageRoute(builder: (context)=>Navi));
    Fluttertoast.showToast(msg: "Sign in successful");
    setState(() {
      isloading=false;
    });
  }
}
