import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fb_accountkit_flutter/fb_accountkit_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('fb_accountkit_flutter');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FbAccountkitFlutter.platformVersion, '42');
  });
}
