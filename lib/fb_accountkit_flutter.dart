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

    if (_defaultCountryCode == null) {
      result._status = FAILED;
      result._message = "Default Country Code can not be null";
      return result;
    }
    argument[_defaultCountryCodeArg] = _defaultCountryCode;

    if (_codeIso == null) {
      result._status = FAILED;
      result._message = "Code ISO can not be null";
      return result;
    }
    argument[_countryCodeIsoArg] = _codeIso;

    if (_countryCode == null) {
      result._status = FAILED;
      result._message = "Country Code can not be null";
      return result;
    }
    argument[_countryCodeArg] = _countryCode;

    if (_phone != null) {
      argument[_phoneArg] = _phone;
    }

    try {
      final String accountResult = await _channel.invokeMethod(
          _methodName, argument);
      if (accountResult == "1") {
        result._status = FAILED;
        result._message = "Facebook Authentication is Failed or Canceled";
        return result;
      }
      Result parsedAccountResult = Result.fromJson(accountResult);
      parsedAccountResult._status = SUCCEED;
      parsedAccountResult._message = "Phone Authentication Succeed !";
      return parsedAccountResult;
    } on PlatformException catch (e) {
      print(e);
      result._status = FAILED;
      result._message = e.toString();
    }
    return result;
  }

  static set phone(String value) {
    _phone = value;
  }

  static set defaultCountryCode(String value) {
    _defaultCountryCode = value;
  }

  static set codeIso(String value) {
    _codeIso = value;
  }

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

  Result();

  Result.fromJson(String jsonString) {
    Map parsedJson = json.decode(jsonString);
    this._phone = parsedJson["phone"];
    this._email = parsedJson["email"];
    this._userId = parsedJson["id"];
  }

  int get status => _status;

  String get message => _message;

  String get userId => _userId;

  String get phone => _phone;

  String get email => _email;
}
