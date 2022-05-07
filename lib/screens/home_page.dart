import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:impulse/screens/botttomnav.dart';
import 'package:impulse/screens/login_page.dart';

enum showName{yes,no}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user = FirebaseAuth.instance.currentUser;
  final db=FirebaseFirestore.instance.collection("Posts").orderBy('createdAt',descending: true);
  final _formkey=GlobalKey<FormState>();
  final TextEditingController openioncontroller=TextEditingController();
  bool isloading=false;
  showName _value=showName.no;


  @override
  Widget build(BuildContext context) {



    //text input for opinion dialog////
    final bodyInput=TextFormField(
      controller: openioncontroller,
      autofocus: true,
      onSaved: (value){
        openioncontroller.text=value!;
      },
      validator: (value){
        if(value!.isEmpty){
          return "Please enter a opinion";
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
          labelText: "Enter your opinion",
          hintText: "Enter your opinion",
          focusedBorder:OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.lightBlue, width: 2.0),
          ),
          labelStyle: TextStyle(color: Colors.lightBlue[800])
      ),
    );

    //button to submit posts
     postbtn(var snapshot) {
       return Material(
         elevation: 5,
         color: Colors.lightBlue[800],
         child: MaterialButton(
           onPressed: () {
             uploadOpinion(snapshot);

           },
           child: isloading ?
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               CircularProgressIndicator(color: Colors.white,),
               SizedBox(width: 10,),
               Text("Please wait...", style: TextStyle(color: Colors.white),),
             ],
           ) : Row(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               Text(
                 "Send your opinion", style: TextStyle(color: Colors.white),),
             ],
           ),
         ),
         borderRadius: BorderRadius.circular(30),
       );
     }

     //opinion dialogs
    opiniondialog(var snapshot){
      return StatefulBuilder(
        builder: (context, setState){
        return Dialog(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Container(
                height: 430,
                child: Column(
                  children: [
                    Text("Share your opinion secretly for\n ${snapshot.data()['title']}",textAlign: TextAlign.center,style: GoogleFonts.play(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.lightBlue[800]),),
                    Divider(thickness: 2,),
                    SizedBox(height: 10,),
                    Text("Want to share your Name ?",style: TextStyle(fontSize: 20,color: Colors.lightBlue[700]),),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                              value: showName.no,
                              title: Text("No"),
                              groupValue: _value,
                              onChanged: (showName? val){
                                  _value=val!;
                                  setState(() {

                                  });
                                  print(val.name);
                              }
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                              value: showName.yes,
                              title: Text("Yes"),
                              groupValue: _value,
                              onChanged: (showName? val){
                                  _value=val! ;
                                  setState(() {
                                    
                                  });
                                  print(val.name);
                              }
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 20,),
                    bodyInput,
                    postbtn(snapshot),

                  ],
                ),
              ),
            ),
          ),
        ),
    );}
    );
     }

    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[800],
        title: Center(child: Text("HIT TALKS",style: GoogleFonts.play(),),),
        leading: Padding(
          padding: EdgeInsets.all(10),
          child: GestureDetector(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                user!.photoURL.toString(),
              )
              ),
            onTap: (){
              showDialog(context: context,
                  builder: (context){
                return Dialog(
                  child: Container(
                    height: 160,
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              user!.photoURL.toString(),
                              height: 70,
                            )
                        ),

                        Center(child: Text(user!.displayName.toString().toUpperCase(),textAlign: TextAlign.center,style: GoogleFonts.play(
                          textStyle: TextStyle(fontWeight: FontWeight.bold)
                        ),),),
                        Center(child: Text(user!.email.toString(),textAlign: TextAlign.center,style: GoogleFonts.lato(
                            textStyle: TextStyle(fontWeight: FontWeight.bold)
                        ),),),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
        ),
        actions: [
          IconButton(onPressed: (){
            showDialog(context: context,
                builder: (context){
                  return  AlertDialog(
                    title: Text("Sign out",style: TextStyle(color: Colors.redAccent),),
                    content: Text("Do you want to continue?"),
                    actions: [
                      FlatButton(
                        child: Text("No",style: TextStyle(color: Colors.blue),),
                        onPressed:  () {
                          Navigator.of(context).pop(); // dismiss dialog
                        },
                      ),
                      FlatButton(
                        child: Text("Yes",style: TextStyle(color: Colors.blue),),
                        onPressed:  () {
                          _signOut();
                          Navigator.of(context).pop();
                          setState(() {

                          });// dismiss dialog
                        },
                      )
                      //continueButton,
                    ],
                  );;
                });
          }, icon: Icon(Icons.logout))
        ],
        ),
      body: FirestoreListView<Map<String, dynamic>>(
        query: db,
        itemBuilder: (context,snapshot){
          Map<String, dynamic> user = snapshot.data();
          return Card(
            elevation: 10,
            shadowColor: Colors.redAccent,
            margin: EdgeInsets.all(5),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              title: Text(user["title"].toString().toUpperCase(),style: GoogleFonts.acme(
                fontSize:30,color: Colors.blue[800]
              ),),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user['body'],style: GoogleFonts.slabo13px(
                    fontSize: 20,color: Colors.yellowAccent[900]
                  ),),
                  Row(
                    children: [
                      InkWell(
                        child: Chip(label: Text('Send your opinion')),
                        onTap: (){
                          showDialog(context: context,
                              builder: (context){
                                return opiniondialog(snapshot);
                              });
                        },
                      ),
                      SizedBox(width: 20,),
                      FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          future: FirebaseFirestore.instance.collection('Posts').doc(snapshot.id.toString()).collection('opinions').get(),
                          builder: (context,snapshot){
                            print(snapshot.data);
                            if(snapshot.hasData){
                              return Chip(label: Text('${snapshot.data!.docs.length} opinions'));
                            }else{
                              return Chip(label: SizedBox(child: CircularProgressIndicator(color: Colors.white70,),height: 20,width: 20,));;
                            }
                          }
                      ),
                    ],
                  ),
                ],
              ),
              //leading: Icon(Icons.add_circle,color: Colors.redAccent,),
              onTap: (){
                showDialog(context: context,
                    builder: (context){
                      return opiniondialog(snapshot);
                    });
              },
            ),
          );
        },

      ),
      );
  }
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signOut();
    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>Login()), (route) => false);
  }

  Future<void> uploadOpinion(var snapshot) async{
    setState(() {
      isloading=true;
    });
    final ndb=FirebaseFirestore.instance.collection("Posts").doc(snapshot.id.toString()).collection("opinions");
    Map<String,dynamic> opinion={'author':FirebaseAuth.instance.currentUser!.displayName,'opinion':openioncontroller.text,'showname':_value.name};
    if(_formkey.currentState!.validate()){
      openioncontroller.clear();
      await ndb.add(opinion).then((value) => {
        Fluttertoast.showToast(
          msg: "Opinion upload successful",),
      Navigator.of(context).pop()
      }).catchError((e){
        Fluttertoast.showToast(msg: e!.message);
      });
    }

    setState(() {

      isloading=false;
    });
  }
}
