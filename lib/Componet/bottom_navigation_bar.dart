// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:expenses_tracker/API/database.dart';
import 'package:expenses_tracker/Pages/dashboard.dart';
import 'package:expenses_tracker/Pages/show_user_detail.dart';
import 'package:expenses_tracker/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class BottomNavigationBars extends StatefulWidget {
  static String id = "bottomNavigationBars";
  const BottomNavigationBars({super.key});

  @override
  State<BottomNavigationBars> createState() => _BottomNavigationBarsState();
}

class _BottomNavigationBarsState extends State<BottomNavigationBars> {
  final screen = [
    Dashboard(),
    ShowUserDetailPage(),
  ];
  int _page = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GNav(
          duration: Duration(milliseconds: 500),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          rippleColor: Colors.grey[300]!,
          hoverColor: Colors.grey[100]!,
          // gap: 8,
          activeColor: Colors.black,
          iconSize: 24,
          backgroundColor: kBackgroundColorCard,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          // duration: Duration(milliseconds: 400),
          tabBackgroundColor: Colors.white,
          textStyle: kwhiteTextStyle.copyWith(color: Colors.black),
          color: Colors.white,
          curve: Curves.easeInOutCubicEmphasized,
          selectedIndex: _page,
          onTabChange: (index) {
            setState(() {
              _page = index;
            });
          }, // navigation bar padding
          tabs: [
            GButton(
              icon: LineIcons.home,
              text: 'Home',
            ),
            // GButton(
            //   icon: LineIcons.user,
            //   text: 'Likes',
            // ),
            // GButton(
            //   icon: LineIcons.search,
            //   text: 'Search',
            // ),
            GButton(
              icon: LineIcons.user,
              text: 'Profile',
            )
          ]),
      body: screen[_page],
    );
  }
}

  // GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         extendBody: true,
//         bottomNavigationBar:
//             OrientationBuilder(builder: (context, orientation) {
//           if (orientation == Orientation.portrait) {
//             return CurvedNavigationBar(
//               height: ratio_height(context, 60), //60
//               color: Colors.orangeAccent,
//               buttonBackgroundColor: Colors.amberAccent,
//               key: _bottomNavigationKey,
//               backgroundColor: Colors.transparent,
//               items: <Widget>[
//                 Icon(
//                   Icons.home,
//                   size: ratio_height(context, 24),
//                 ),
//                 Icon(
//                   Icons.favorite,
//                   size: ratio_height(context, 24),
//                 ), //24,),
//                 Icon(
//                   Icons.person,
//                   size: ratio_height(context, 24),
//                 ) //24,),
//               ],
//               onTap: (index) {
//                 setState(() {
//                   _page = index;
//                 });
//               },
//             );
//           } else {
//             return CurvedNavigationBar(
//               height: 60, //60
//               color: Colors.orangeAccent,
//               buttonBackgroundColor: Colors.amberAccent,
//               key: _bottomNavigationKey,
//               backgroundColor: Colors.transparent,
//               items: <Widget>[
//                 Icon(
//                   Icons.home,
//                   size: ratio_height(context, 45),
//                 ),
//                 Icon(
//                   Icons.favorite,
//                   size: ratio_height(context, 45),
//                 ), //24,),
//                 Icon(
//                   Icons.person,
//                   size: ratio_height(context, 45),
//                 ) //24,),
//               ],
//               onTap: (index) {
//                 setState(() {
//                   _page = index;
//                 });
//               },
//             );
//           }
//         }),
//         body: screen[_page]
//         // Container(
//         //   color: Colors.blueAccent,
//         //   child: Center(
//         //     child: Column(
//         //       children: <Widget>[
//         //         Text(_page.toString(), textScaleFactor: 10.0),
//         //         ElevatedButton(
//         //           child: Text('Go To Page of index 1'),
//         //           onPressed: () {
//         //             //Page change using state does the same as clicking index 1 navigation button
//         //             final CurvedNavigationBarState? navBarState =
//         //                 _bottomNavigationKey.currentState;
//         //             navBarState?.setPage(1);
//         //           },
//         //         )
//         //       ],
//         //     ),
//         //   ),
//         // )
//         );
//   }
// }
