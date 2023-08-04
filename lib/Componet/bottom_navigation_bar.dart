// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:expenses_tracker/Pages/dashboard.dart';
import 'package:expenses_tracker/Pages/firebasetry.dart';
import 'package:expenses_tracker/Pages/show_user_detail.dart';
import 'package:expenses_tracker/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class BottomNavigationBars extends StatefulWidget {
  static String id = "bottomNavigationBars";
  const BottomNavigationBars({super.key});

  @override
  State<BottomNavigationBars> createState() => _BottomNavigationBarsState();
}

class _BottomNavigationBarsState extends State<BottomNavigationBars> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  final List<Widget> _pages = [Dashboard(), Tryyy(), ShowUserDetailPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) {
          if (details.primaryVelocity! < 0) {
            // Swiped to the left, move to the next page
            _pageController.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          } else if (details.primaryVelocity! > 0) {
            // Swiped to the right, move to the previous page
            _pageController.previousPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          }
        },
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: _pages,
        ),
      ),
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
          selectedIndex: _currentIndex,
          onTabChange: (index) {
            setState(() {
              _currentIndex = index;
            });
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          }, // navigation bar padding
          tabs: [
            GButton(
              icon: LineIcons.home,
              text: 'Home',
            ),
            GButton(
              icon: LineIcons.home,
              text: 'Home',
            ),
            GButton(
              icon: LineIcons.user,
              text: 'Profile',
            )
          ]),
    );
  }
}
