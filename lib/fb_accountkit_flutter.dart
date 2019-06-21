import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:convert';

class FbAccountkitFlutter {
  static const MethodChannel _channel = const MethodChannel('fb_accountkit_flutter');
  static const String _methodName = "open_facebook_activity";
  static const String _phoneArg = "phone";
  static const String _defaultCountryCodeArg = "default_country_code";
  static const String _countryCodeIsoArg = "country_code_iso";
  static const String _countryCodeArg = "country_code";
  static const int SUCCEED = 1;
  static const int FAILED = 0;

  static String _phone;
  static String _defaultCountryCode;
  static String _codeIso;
  static String _countryCode;

  static Future<Result> startAuthentication() async {
    Result result = Result();
    Map<String, dynamic> argument = Map();

    if (defaultCountryCode == null) {
      result.status = FAILED;
      result.message = "Default Country Code can not be null";
      return result;
    }
    argument[_defaultCountryCodeArg] = defaultCountryCode;

    if (codeIso == null) {
      result.status = FAILED;
      result.message = "Code ISO can not be null";
      return result;
    }
    argument[_countryCodeIsoArg] = codeIso;

    if (countryCode == null) {
      result.status = FAILED;
      result.message = "Country Code can not be null";
      return result;
    }
    argument[_countryCodeArg] = countryCode;

    if (phone != null) {
      argument[_phoneArg] = phone;
    }

    try {
      final String accountResult = await _channel.invokeMethod(_methodName, argument);
      if (accountResult == "1") {
        result.status = FAILED;
        result.message = "Facebook Authentication is Failed or Canceled";
        return result;
      }
      Result parsedAccountResult = Result.fromJson(accountResult);
      parsedAccountResult.status = SUCCEED;
      parsedAccountResult.message = "Phone Authentication Succeed !";
      return parsedAccountResult;
    } on PlatformException catch (e) {
      print(e);
      result.status = FAILED;
      result.message = e.toString();
    }
    return result;
  }

  static String get phone => _phone;

  static set phone(String value) {
    _phone = value;
  }

  static String get defaultCountryCode => _defaultCountryCode;

  static set defaultCountryCode(String value) {
    _defaultCountryCode = value;
  }

  static String get codeIso => _codeIso;

  static set codeIso(String value) {
    _codeIso = value;
  }

  static String get countryCode => _countryCode;

  static set countryCode(String value) {
    _countryCode = value;
  }
}

class Result {
  int _status;
  String _message;
  String _userId;
  String _email;
  String _phone;

  Result(){

  }

  Result.fromJson(String jsonString) {
    Map Json = json.decode(jsonString);
    this._phone = Json["phone"];
    this._email = Json["email"];
    this._userId = Json["id"];
  }

  int get status => _status;

  String get message => _message;

  String get userId => _userId;

  String get phone => _phone;

  String get email => _email;

  set userId(String value) {
    _userId = value;
  }

  set email(String value) {
    _email = value;
  }

  set phone(String value) {
    _phone = value;
  }

  set status(int value) {
    _status = value;
  }

  set message(String value) {
    _message = value;
  }
}
