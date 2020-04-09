import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:oddoma/colors.dart';
import 'package:oddoma/main.dart';
import 'package:oddoma/pages/loading_page.dart';

class OdDoma extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics = FirebaseAnalytics();

    return MaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      navigatorKey: navigatorKey,
      title: 'OdDoma',
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              textTheme: TextTheme(
                  headline6: TextStyle(color: Colors.white, fontSize: 17))),
          canvasColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.white,
          backgroundColor: black,
          //primaryColor: primaryColor,
          primarySwatch: primaryColor,
          buttonColor: primaryColor,
          accentColor: primaryColor,
          /* primaryTextTheme: TextTheme(
          button: TextStyle(color: Colors.white)
        ),
        accentTextTheme: TextTheme(
          button: TextStyle(color: Colors.white)
        ), */
          buttonTheme: ButtonThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              side: BorderSide(color: Colors.transparent, width: 0),
            ),
            buttonColor: primaryColor,
            textTheme: ButtonTextTheme.primary,
          ),
          textTheme: TextTheme(
              overline: TextStyle(color: primaryColor),
              bodyText1: TextStyle(color: lightGray))),
      home: LoadingPage(),
    );
  }
}
