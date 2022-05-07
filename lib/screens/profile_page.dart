import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance
      .collection("Posts")
      .where('authorid', isEqualTo: FirebaseAuth.instance.currentUser!.uid);
  int count = 0;

  @override
  Widget build(BuildContext context) {

    showopinons(var snapshot){
      return Dialog(
        child: Container(
          height: 400,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text("Opinions for \n${snapshot.data()['title']}",textAlign: TextAlign.center,style: GoogleFonts.play(fontSize: 20,color: Colors.lightBlue[800],fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Expanded(
                  child: FirestoreListView<Map<String, dynamic>>(
                  query: FirebaseFirestore.instance.collection('Posts').doc(snapshot.id.toString()).collection('opinions'),
                  itemBuilder: (context, snapshot) {
                    Map<String, dynamic> opinion = snapshot.data();
                    return Card(
                      elevation: 4,
                      child: ListTile(
                        title: opinion['showname']=='yes'?Text(opinion['author'].toString().toUpperCase(),):Text('anonymous'.toUpperCase()),
                        subtitle: Text(opinion['opinion']),
                      ),
                    );
                  }
                  ),
                ),
              ],
            ),
          ),
        ),
      );}

    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[800],
        title: Center(child: Text("HIT TALKS",style: GoogleFonts.play(),),),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Card(
              elevation: 20,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          user!.photoURL.toString(),
                          height: 70,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        user!.displayName.toString().toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.play(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.lightBlue[900])),
                      ),
                    ),
                    Center(
                      child: Text(
                        user!.email.toString(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                        child: Text(
                          'Total post',
                          style: TextStyle(fontSize: 20),
                        )),
                    FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        future: db.get(),
                        builder: (context, snapshot) {
                          print(snapshot.data);
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data!.docs.length.toString(),
                              style: TextStyle(fontSize: 20),
                            );
                          } else {
                            return Text("Loading..");
                          }
                        }),
                  ],
                ),
              ),
            ),


            FirestoreListView<Map<String, dynamic>>(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                query: db,
                itemBuilder: (context, snapshot) {
                  Map<String, dynamic> user = snapshot.data();
                  return Card(
                    elevation: 10,
                    shadowColor: Colors.redAccent,
                    margin: EdgeInsets.all(5),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      title: Text(
                        user["title"].toString().toUpperCase(),
                        style: GoogleFonts.acme(
                            fontSize: 30, color: Colors.lightBlue[800]),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user['body'],style: GoogleFonts.slabo13px(
                              fontSize: 20,color: Colors.yellowAccent[900]
                          ),),
                          Row(
                            children: [
                              InkWell(
                                child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                    future: FirebaseFirestore.instance.collection('Posts').doc(snapshot.id.toString()).collection('opinions').get(),
                                    builder: (context,snapshot){
                                      print(snapshot.data);
                                      if(snapshot.hasData){
                                        return Chip(label: Text('Show ${snapshot.data!.docs.length} opinions'));
                                      }else{
                                        return Chip(label: SizedBox(child: CircularProgressIndicator(color: Colors.white70,),height: 20,width: 20,));;
                                      }
                                    }
                                ),
                                onTap: (){
                                  showDialog(context: context,
                                      builder: (context){
                                        return showopinons(snapshot);
                                  });
                                },
                              ),
                              IconButton(onPressed: (){
                                showDialog(context: context,
                                    builder: (context){
                                      return  AlertDialog(
                                        title: Text("Delete",style: TextStyle(color: Colors.redAccent),),
                                        content: Text("Do you want to continue?"),
                                        actions: [
                                          FlatButton(
                                            child: Text("Cancle",style: TextStyle(color: Colors.blue),),
                                            onPressed:  () {
                                              Navigator.of(context).pop(); // dismiss dialog
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("Yes",style: TextStyle(color: Colors.blue),),
                                            onPressed:  () {
                                              deletePost(snapshot);
                                              Navigator.of(context).pop();
                                              setState(() {

                                              });// dismiss dialog
                                            },
                                          )
                                          //continueButton,
                                        ],
                                      );;
                                    });

                              }, icon: Icon(Icons.delete_forever,color: Colors.redAccent,size: 30,))
                            ],
                          ),
                        ],
                      ),

                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
  Future<void>deletePost(var snapshot)async {
    FirebaseFirestore.instance.collection("Posts").doc(snapshot.id).delete().then((value) => {
      Fluttertoast.showToast(msg: "Post deleted successfully")
    }).catchError((e){
      Fluttertoast.showToast(msg: e!.message);
    });
  }
}
