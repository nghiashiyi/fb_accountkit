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
          title: const Text('Account Kit Flutter example app'),
          backgroundColor: Colors.redAccent,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                  onPressed: () {
                    openFacebookActivity();
                  },
                  child: Text("Open Account Kit SMS Authenation")),
              Text('Result:  ${_loginResult.message == null ? "Ready to Process" : _loginResult.message}\n'),
              _getOptionalInformation()
            ],
          ),
        ),
      ),
    );
  }

  Future<void> openFacebookActivity() async {
    Result result;

    try {

      FbAccountkitFlutter.defaultCountryCode = "[YOUR DEFAULT COUNTRY CODE]"; // Ex:  US, AL etc.
      // Find more here : https://developers.facebook.com/docs/accountkit/countrycodes/

      FbAccountkitFlutter.codeIso = "[YOUR ISO CODE]"; // Ex: 93, 355 etc.
      // Find Dialing Code here : https://developers.facebook.com/docs/accountkit/countrycodes/

      FbAccountkitFlutter.countryCode = "[YOUR COUNTRY CODE]";
      // Find A 3 in here : http://kirste.userpage.fu-berlin.de/diverse/doc/ISO_3166.html

      // Optional
      FbAccountkitFlutter.phone = "[INITIAL PHONE]";

      // Request open accountkit
      result = await FbAccountkitFlutter.startAuthentication();

    } on PlatformException catch(e) {
      print(e);
      result = null;
    }

    setState(() {
      _loginResult = result;
    });
  }

  Widget _getOptionalInformation() {
    var phone = _loginResult.phone == null ? "Phone Null" : _loginResult.phone;
    var email = _loginResult.email == null ? "Email Null" : _loginResult.email;
    var userId = _loginResult.userId == null ? "User Id Null" : _loginResult.userId;
    if (_loginResult.status == FbAccountkitFlutter.SUCCEED) {
      return Text("Optional Info: \n Phone -> $phone \n Email -> $email \n UserId -> $userId");
    }
    return Container();
  }
}
