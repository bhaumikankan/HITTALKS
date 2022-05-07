import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impulse/models/postModel.dart';

class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  final _formkey=GlobalKey<FormState>();
  final TextEditingController titlecontroller=TextEditingController();
  final TextEditingController contentcontroller=TextEditingController();
  bool isloading=false;
  @override
  Widget build(BuildContext context) {
    final titleInput=TextFormField(
      controller: titlecontroller,
      autofocus: false,
      onSaved: (value){
        titlecontroller.text=value!;
      },
      validator: (value){
        if(value!.isEmpty){
          return "Please enter post title";
        }
      },
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      maxLength: 30,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(15, 20, 15, 20),
        border: OutlineInputBorder(),
        labelText: "Enter post title",
        hintText: "Enter post title",
        focusedBorder:OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.lightBlue, width: 2.0),
        ),
        labelStyle: TextStyle(color: Colors.lightBlue)
      ),
    );

    final bodyInput=TextFormField(
      controller: contentcontroller,
      autofocus: false,
      onSaved: (value){
        contentcontroller.text=value!;
      },
      validator: (value){
        if(value!.isEmpty){
          return "Please enter post body";
        }
      },
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      minLines: 5,
      maxLines: 5,
      maxLength: 500,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(15, 20, 15, 20),
          border: OutlineInputBorder(),
          labelText: "Enter post body",
          hintText: "Enter post body",
          focusedBorder:OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.lightBlue, width: 2.0),
          ),
          labelStyle: TextStyle(color: Colors.lightBlue)
      ),
    );

    final postbtn=Material(
      elevation: 5,
      color: Colors.lightBlue[800],
      child: MaterialButton(
        onPressed: (){
          uploadPost();
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
            Text("Post your confession",style: TextStyle(color: Colors.white),),
          ],
        ),
      ),
      borderRadius: BorderRadius.circular(30),
    );
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[800],
        title: Center(child: Text("HIT TALKS",style: GoogleFonts.play(),),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  Text("Confess yourself",style: GoogleFonts.play(
                    fontSize: 35,
                    color: Colors.lightBlue[800]
                  ),),
                  SizedBox(height: 15,),
                  titleInput,
                  SizedBox(height: 10,),
                  bodyInput,
                  SizedBox(height: 15,),
                  postbtn
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<void> uploadPost()async {
    setState(() {
      isloading=true;
    });
    PostModel post = PostModel(authorid: FirebaseAuth.instance.currentUser!.uid,title: titlecontroller.text,body: contentcontroller.text,createdAt: DateTime.now().millisecondsSinceEpoch);
    final db=FirebaseFirestore.instance.collection("Posts");
    if(_formkey.currentState!.validate()){
      titlecontroller.clear();
      contentcontroller.clear();
      await db.add(post.toMap()).then((value) => {
        Fluttertoast.showToast(
            msg: "Post upload successful",),

      }).catchError((e){
        Fluttertoast.showToast(msg: e!.message);
      });
    }

    setState(() {

      isloading=false;
    });
  }
}
