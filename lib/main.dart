// ignore_for_file: prefer_const_constructors, unused_import, unused_local_variable

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:remind_wallet/Pages/add_account.dart';
import 'package:remind_wallet/Pages/add_transaction.dart';
import 'package:remind_wallet/modules/transactions/presentation/add_transaction_screen.dart';
import 'package:remind_wallet/Pages/authentication/add_user_data_entry_page.dart';
import 'package:remind_wallet/Pages/authentication/forgot_password.dart';
import 'package:remind_wallet/Pages/edit_user_detail.dart';
import 'package:remind_wallet/Pages/home_pages/dashboard.dart';
import 'package:remind_wallet/Pages/introduction_pages/introduction_pages.dart';
import 'package:remind_wallet/Pages/introduction_pages/terms_condition_page.dart';
import 'package:remind_wallet/Pages/show_expenses_page.dart';
import 'package:remind_wallet/Pages/show_income_page.dart';
import 'package:remind_wallet/Pages/show_to_pay_page.dart';
import 'package:remind_wallet/Pages/show_to_receive_page.dart';
import 'package:remind_wallet/Pages/starting_pages/splash_screen.dart';
import 'package:remind_wallet/bloc/expense_bloc.dart';
import 'package:remind_wallet/bloc/expense_event.dart';
import 'package:remind_wallet/constant.dart';
import 'package:remind_wallet/extras/firebase_all_options.dart';
import 'package:remind_wallet/modules/account/presentation/account_list_screen.dart';
import 'package:remind_wallet/theme/theme.dart';

import 'Pages/authentication/signIn_signOut_page.dart';
import 'Pages/home_pages/bottom_navigation_bar.dart';
import 'Pages/home_pages/show_user_detail.dart';
import 'Pages/starting_pages/check_page.dart';
import 'Provider/provider.dart';
import 'di/injection_container.dart' as di;
import 'firebase_options.dart';

Future<void> main() async {
  //Firebase Initialization
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();

  var box = await Hive.openBox("expenses_tracker");
  var boxNew = await Hive.openBox("expenses_tracker_new");

  await di.init();

  //Provider Initialization
  runApp(MultiProvider(
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
      title: 'Remind Wallet',
      theme: AppTheme.darkTheme(),
      home: BlocProvider(
        create: (context) => di.sl<ExpenseBloc>()..add(LoadExpenseDataEvent()),
        child: AccountListScreen(),
      ),

      // initialRoute: Splash_Page.id,
      routes: {
        Dashboard.id: (context) => const Dashboard(),
        IncomePage.id: (context) => const IncomePage(),
        ExpensePage.id: (context) => const ExpensePage(),
        ToPayPage.id: (context) => const ToPayPage(),
        ToReceivePage.id: (context) => const ToReceivePage(),
        AddTransactionScreen.id: (context) => AddTransactionScreen(),
        AddAccountScreen.id: (context) => AddAccountScreen(),
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
    ..maskColor = Colors.blue.withAlpha((0.5 * 255).round())
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
