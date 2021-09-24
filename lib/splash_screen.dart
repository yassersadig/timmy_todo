import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:to_done/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String quote = '';
  String quoteAuthor = '';

  @override
  void initState() {
    getQuote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icon/app_icon.png', height: 128, width: 128),
            SizedBox(
              height: 24,
            ),
            Text(
              'Welcome back, Baby!',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.all(32.0),
              child: quote == ''
                  ? CircularProgressIndicator(
                      color: Colors.grey,
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '"$quote"',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          quoteAuthor,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
          child: Text(
            'Copyright © 2021 Baby\'s App',
            textAlign: TextAlign.center,
          )),
    );
  }

  getQuote() async {
    final url = Uri.parse('https://quotes.rest/qod');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        quote = jsonDecode(response.body)['contents']['quotes'][0]['quote'];
        quoteAuthor =
            jsonDecode(response.body)['contents']['quotes'][0]['author'];
      });

      await Future.delayed(Duration(seconds: 5));
      navigateToHome();
    } else
      navigateToHome();
  }

  void navigateToHome() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
        (route) => false);
  }
}
