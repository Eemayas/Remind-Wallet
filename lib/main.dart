// ignore_for_file: prefer_const_constructors, unused_import, unused_local_variable

import 'package:expenses_tracker/Pages/add_account.dart';
import 'package:expenses_tracker/Pages/add_transaction.dart';
import 'package:expenses_tracker/Pages/authentication/forgot_password.dart';
import 'package:expenses_tracker/Pages/edit_user_detail.dart';
import 'package:expenses_tracker/Pages/introduction_pages/terms_condition_page.dart';
import 'package:expenses_tracker/extras/firebase_all_options.dart';
import 'package:expenses_tracker/Pages/show_expenses_page.dart';
import 'package:expenses_tracker/Pages/show_income_page.dart';
import 'package:expenses_tracker/Pages/starting_pages/splash_screen.dart';
import 'package:expenses_tracker/Pages/show_to_receive_page.dart';
import 'package:expenses_tracker/Pages/show_to_pay_page.dart';
import 'package:expenses_tracker/Pages/authentication/add_user_data_entry_page.dart';
import 'package:expenses_tracker/Pages/introduction_pages/introduction_pages.dart';
import 'package:expenses_tracker/constant.dart';
import 'package:expenses_tracker/Pages/home_pages/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'Pages/home_pages/bottom_navigation_bar.dart';
import 'Pages/starting_pages/check_page.dart';
import 'Pages/authentication/signIn_signOut_page.dart';
import 'Pages/home_pages/show_user_detail.dart';
import 'Provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  //Firebase Initialization
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //* initialize hive
  await Hive.initFlutter();

  //open the box
  var box = await Hive.openBox("expenses_tracker");

  //Provider Initialization
  runApp(MultiProvider(
    //List of Provider used in the app
    providers: [ChangeNotifierProvider(create: (_) => ChangedMsg())],
    child: const MyApp(),
  ));
  configLoading();
}

final navigatorkey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final box = Hive.box("expenses_tracker");

    // Check if data is present in the box

    return MaterialApp(
      navigatorKey: navigatorkey,
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      title: 'Flutter Demo',
      theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: kBackgroundColor,
          textTheme: TextTheme(
            bodyLarge: TextStyle(
              color: Colors.white,
            ),
          )),
      initialRoute: Splash_Page.id, //TermsAndConditionsScreen.id, //IntroductionPages.id, //
      // Dashboard.id,  Tryyy.id,//ShowUserDetailPage.id,  //LogInSignUpPage.id, //  Dashboard.id, //AccountDetailPage.id,
      //TranasctionDetailPage.id,
      routes: {
        Dashboard.id: (context) => const Dashboard(),
        IncomePage.id: (context) => const IncomePage(),
        ExpensePage.id: (context) => const ExpensePage(),
        ToPayPage.id: (context) => const ToPayPage(),
        ToReceivePage.id: (context) => const ToReceivePage(),
        AddTransaction.id: (context) => AddTransaction(),
        AddAccount.id: (context) => AddAccount(),
        AddUserDataPage.id: (context) => AddUserDataPage(),
        Splash_Page.id: (context) => Splash_Page(),
        CheckSignin_outPage.id: (context) => CheckSignin_outPage(),
        FirebaseAllOptions.id: (context) => FirebaseAllOptions(),
        // CheckPage.id: (context) => CheckPage(),
        TermsAndConditionsScreen.id: (context) => TermsAndConditionsScreen(),
        LogInSignUpPage.id: (context) => LogInSignUpPage(),
        ForgotPassword.id: (context) => ForgotPassword(),
        EditUserDetail.id: (context) => EditUserDetail(),
        ShowUserDetailPage.id: (context) => ShowUserDetailPage(),
        BottomNavigationBars.id: (context) => BottomNavigationBars(),
        IntroductionPages.id: (context) => IntroductionPages(),
        // AccountDetailPage.id: (context) => AccountDetailPage(),
        // EditTransaction.id: (context) => EditTransaction(),
        // TranasctionDetailPage.id: (context) => TranasctionDetailPage(),
      },
      // home: const dashBoard()
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.squareCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..textStyle = kwhiteTextStyle
    ..customAnimation = CustomAnimation();
}

class CustomAnimation extends EasyLoadingAnimation {
  CustomAnimation();

  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    return Opacity(
      opacity: controller.value,
      child: RotationTransition(
        turns: controller,
        child: child,
      ),
    );
  }
}
