// ignore_for_file: prefer_const_constructors, unused_import, unused_local_variable

import 'package:expenses_tracker/Pages/account_detail_page.dart';
import 'package:expenses_tracker/Pages/add_account.dart';
import 'package:expenses_tracker/Pages/add_transaction.dart';
import 'package:expenses_tracker/Pages/authentication/forgot_password.dart';
import 'package:expenses_tracker/Pages/edit_user_detail.dart';
import 'package:expenses_tracker/Pages/expenses_page.dart';
import 'package:expenses_tracker/Pages/income_page.dart';
import 'package:expenses_tracker/Pages/splash_screen.dart';
import 'package:expenses_tracker/Pages/to_pay_page.dart';
import 'package:expenses_tracker/Pages/to_receive_page.dart';
import 'package:expenses_tracker/Pages/authentication/add_user_data_entry_page.dart';
import 'package:expenses_tracker/constant.dart';
import 'package:expenses_tracker/Pages/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'Componet/bottom_navigation_bar.dart';
import 'Pages/check_page.dart';
import 'Pages/authentication/signIn_signOut_page.dart';
import 'Pages/show_user_detail.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: kBackgroundColor,
          textTheme: TextTheme(
            bodyLarge: TextStyle(
              color: Colors.white,
            ),
          )),
      initialRoute: Splash_Page.id, //ShowUserDetailPage.id, // //LogInSignUpPage.id, //  Dashboard.id, //AccountDetailPage.id,
      //TranasctionDetailPage.id, // //AddTransaction.id,
      routes: {
        Dashboard.id: (context) => const Dashboard(),
        IncomePage.id: (context) => const IncomePage(),
        ExpensePage.id: (context) => const ExpensePage(),
        ToPayPage.id: (context) => const ToPayPage(),
        ToReceivePage.id: (context) => const ToReceivePage(),
        AddTransaction.id: (context) => AddTransaction(),
        AddAccount.id: (context) => AddAccount(),
        UserDataEntryPage.id: (context) => UserDataEntryPage(),
        Splash_Page.id: (context) => Splash_Page(),
        CheckPage.id: (context) => CheckPage(),
        LogInSignUpPage.id: (context) => LogInSignUpPage(),
        ForgotPassword.id: (context) => ForgotPassword(),
        EditUserDetail.id: (context) => EditUserDetail(),
        ShowUserDetailPage.id: (context) => ShowUserDetailPage(),
        BottomNavigationBars.id: (context) => BottomNavigationBars()
        // AccountDetailPage.id: (context) => AccountDetailPage(),
        // EditTransaction.id: (context) => EditTransaction(),
        // TranasctionDetailPage.id: (context) => TranasctionDetailPage(),
      },
      // home: const dashBoard()
    );
  }
}
