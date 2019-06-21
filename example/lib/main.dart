import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:fb_accountkit_flutter/fb_accountkit_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Result _loginResult = Result();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('Result:  ${_loginResult.message}\n'),
              FlatButton(
                  onPressed: () {
                    openFacebookActivity();
                  },
                  child: Text("Open Account Kit Activity"))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> openFacebookActivity() async {
    Result result;

    try {
      // required
      FbAccountkitFlutter.defaultCountryCode = "YOUR_DEFAULT_COUNTRY_CODE";
      FbAccountkitFlutter.codeIso = "YOUR_CODE_ISO";
      FbAccountkitFlutter.countryCode = "YOUR_COUNTRY_CODE";

      // optional
      FbAccountkitFlutter.phone = "YOUR_INITIAL_PHONE";

      // request open accountkit
      result = await FbAccountkitFlutter.startAuthentication();

    } on PlatformException catch(e) {
      print(e);
      result = null;
    }

    setState(() {
      _loginResult = result;
    });
  }
}
