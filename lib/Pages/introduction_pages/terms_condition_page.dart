// ignore_for_file: prefer_const_constructors
import 'package:expenses_tracker/constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  static String id = "TermsAndConditionsScreen";

  const TermsAndConditionsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColorAppBar,
        title: Text(
          'Terms & Conditions',
          style: kwhiteboldTextStyle,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mainText('Terms & Conditions'),
              SizedBox(height: 16.0),
              longText(
                '''
By downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. You’re not allowed to copy or modify the app, any part of the app, or our trademarks in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages or make derivative versions. The app itself, and all the trademarks, copyright, database rights, and other intellectual property rights related to it, still belong to Prashant Manandhar.\n\nPrashant Manandhar is committed to ensuring that the app is as useful and efficient as possible.For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for.The Remind Wallet app stores and processes personal data that you have provided to us, to provide my Service. It’s your responsibility to keep your phone and access to the app secure. We therefore recommend that you do not jailbreak or root your phone, which is the process of removing software restrictions and limitations imposed by the official operating system of your device. It could make your phone vulnerable to malware/viruses/malicious programs, compromise your phone’s security features and it could mean that the Remind Wallet app won’t work properly or at all.The app does use third-party services that declare their Terms and Conditions.''',
              ),
              SizedBox(height: 16.0),
              // Link to third-party Terms and Conditions
              GestureDetector(
                onTap: () {
                  _launchURL(Uri(scheme: 'https', host: 'policies.google.com', path: '/terms'));
                },
                child: linkText(
                  'Link to Terms and Conditions of third-party service providers used by the app',
                ),
              ),
              SizedBox(height: 16.0),
              longText(
                '''You should be aware that there are certain things that Prashant Manandhar will not take responsibility for. Certain functions of the app will require the app to have an active internet connection. The connection can be Wi-Fi or provided by your mobile network provider, but Prashant Manandhar cannot take responsibility for the app not working at full functionality if you don’t have access to Wi-Fi, and you don’t have any of your data allowance left.\nIf you’re using the app outside of an area with Wi-Fi, you should remember that the terms of the agreement with your mobile network provider will still apply. As a result, you may be charged by your mobile provider for the cost of data for the duration of the connection while accessing the app, or other third-party charges. In using the app, you’re accepting responsibility for any such charges, including roaming data charges if you use the app outside of your home territory (i.e. region or country) without turning off data roaming. If you are not the bill payer for the device on which you’re using the app, please be aware that we assume that you have received permission from the bill payer for using the app.

Along the same lines, Prashant Manandhar cannot always take responsibility for the way you use the app i.e. You need to make sure that your device stays charged – if it runs out of battery and you can’t turn it on to avail the Service, Prashant Manandhar cannot accept responsibility.\nWith respect to Prashant Manandhar’s responsibility for your use of the app, when you’re using the app, it’s important to bear in mind that although we endeavor to ensure that it is updated and correct at all times, we do rely on third parties to provide information to us so that we can make it available to you. Prashant Manandhar accepts no liability for any loss, direct or indirect, you experience as a result of relying wholly on this functionality of the app.\n''',
              ),

              SizedBox(height: 16.0),
              mainText(
                '''Changes to This Terms and Conditions''',
              ),
              SizedBox(height: 16.0),
              longText(
                  '''I may update our Terms and Conditions from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Terms and Conditions on this page.

These terms and conditions are effective as of 2023-08-10'''),
              SizedBox(height: 16.0),
              mainText(
                'Contact Us',
              ),
              SizedBox(height: 16.0),
              longText(
                '''If you have any questions or suggestions about my Terms and Conditions, do not hesitate to contact me at prashantmanandhar2002@gmail.com.'''
                '',
              ),
              SizedBox(height: 16.0),
              // Add more content as needed
            ],
          ),
        ),
      ),
    );
  }

  Text mainText(String text) {
    return Text(text,
        style: kwhiteTextStyle.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          decoration: TextDecoration.underline,
        ));
  }

  Text longText(String text) {
    return Text(
      text,
      style: kwhiteTextStyle,
    );
  }

  Text linkText(String text) {
    return Text(
      text,
      style: kwhiteTextStyle.copyWith(
        color: Colors.blue,
        decoration: TextDecoration.underline,
      ),
    );
  }

  // Function to open URLs in the default browser
  _launchURL(Uri uri) async {
    if (await launchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }
}
