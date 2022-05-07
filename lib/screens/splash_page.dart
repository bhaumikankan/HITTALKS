import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'botttomnav.dart';
import 'login_page.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  var currentPage;
  final _auth=FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _handelScreenchange();
  }
  _handelScreenchange()async{
    await Future.delayed(Duration(seconds: 2));
    if(_auth.currentUser==null)
    {
      currentPage=Login();
    }else{
      currentPage=Bottomnav();
    }
    setState(() {

    });

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>currentPage), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Center(
          child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: SizedBox(
                      height: 500,
                      child: Image.asset('assets/images/login_pic.png',fit: BoxFit.contain,),
                    ),
                  ),
                  /*Text("HIT TALKS",textAlign: TextAlign.center,style: GoogleFonts.cinzelDecorative(fontSize: 30,fontWeight: FontWeight.bold),),
                  Text("Define yourself..\nThe way you want",textAlign: TextAlign.center,style: GoogleFonts.play(),)*/
                ],
              ),
          ),
        ),
      );
  }
}