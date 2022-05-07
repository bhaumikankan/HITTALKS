import 'package:flutter/material.dart';
import 'package:impulse/screens/home_page.dart';
import 'package:impulse/screens/post_page.dart';
import 'package:impulse/screens/profile_page.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({Key? key}) : super(key: key);

  @override
  _BottomnavState createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  int currentpageIndex=0;
  @override
  Widget build(BuildContext context) {

    final screens=[
      Home(),
      Post(),
      Profile()
    ];
    return Scaffold(
      body: IndexedStack(
        index: currentpageIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentpageIndex,
        onTap: (index){
          FocusScopeNode currentFocus=FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }
          setState(() {
            currentpageIndex=index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: false,
        backgroundColor: Colors.lightBlue[800],
      ),
    );
  }
}
