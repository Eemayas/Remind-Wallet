// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:expenses_tracker/Pages/terms_condition_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../Componet/custom_alert_dialog.dart';
import '../../constant.dart';
import '../starting_pages/check_page.dart';
import 'pages_list.dart';

class IntroductionPages extends StatefulWidget {
  static String id = "IntroductionPages";
  const IntroductionPages({super.key});

  @override
  State<IntroductionPages> createState() => _IntroductionPagesState();
}

class _IntroductionPagesState extends State<IntroductionPages> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    int pageindex;
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          PageView(
              controller: _pageController,
              onPageChanged: (int index) {
                setState(() {
                  _currentIndex = index; // Update the current index
                });
              },
              children: pagesList),
          Container(
            alignment: Alignment(0, 0.8),
            child: ProgressButton.icon(
                textStyle: kwhiteTextStyle,
                height: 40.00,
                maxWidth: 200.00,
                iconedButtons: {
                  ButtonState.idle: IconedButton(
                    text: "Next",
                    icon: Icon(Icons.arrow_forward_ios_sharp, color: Colors.white),
                    color: Colors.deepPurple.shade500,
                  ),
                  ButtonState.loading: IconedButton(text: "Loading", color: Colors.deepPurple.shade700),
                  ButtonState.fail: IconedButton(text: "Failed", icon: Icon(Icons.cancel, color: Colors.white), color: Colors.red.shade300),
                  ButtonState.success: IconedButton(
                      text: "Success",
                      icon: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      ),
                      color: Colors.green.shade400)
                },
                onPressed: () => {
                      pageindex = _currentIndex + 1,
                      if ((pageindex) != pagesList.length)
                        {
                          _pageController.animateToPage(
                            _currentIndex + 1,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                          )
                        },
                      if ((pageindex) == pagesList.length)
                        {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    "Terms and Conditions",
                                    textAlign: TextAlign.center,
                                    style: kwhiteTextStyle.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  content: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Before we proceed, it\'s essential to ensure that we\'re aligned on the ',
                                          ),
                                          buildTermsLink(context),
                                          TextSpan(
                                            text:
                                                '. Could you kindly review and confirm your agreement with our terms? Your understanding and acceptance are crucial to our mutual success. Thank you!',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: Text(
                                        "Cancel",
                                        style: kwhiteTextStyle.copyWith(color: Colors.white),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pushReplacement(PageTransition(
                                          type: PageTransitionType.fade, duration: Duration(seconds: 1), child: CheckSignin_outPage())),
                                      child: Text(
                                        "Agree",
                                        style: kwhiteTextStyle.copyWith(color: Colors.blue),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        },
                    },
                state: ButtonState.idle),
          ),

          //dot indicatore
          Container(
            alignment: Alignment(0, 0.9),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: pagesList.length,
            ),
          )
        ]),
      ),
    );
  }
}

TextSpan buildTermsLink(BuildContext context) {
  return TextSpan(
      text: 'Terms and Conditions',
      style: TextStyle(
        color: Colors.blue,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          // Navigate to a different page when terms are clicked
          Navigator.pushNamed(context, TermsAndConditionsScreen.id);
        });
}
