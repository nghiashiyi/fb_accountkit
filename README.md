# Welcome to Facebook Account Kit Flutter Version!
### What's that?
As you all know, Facebook Account Kit - powered by Facebook - lets you quickly register for and login to your app by using just user's phone number. It's reliable and easy to integrate. Now it's is available in **Flutter**.

## Let's prepare some your own Facebook Developer information !!!
- Access Facebook Developer : [https://developers.facebook.com](https://developers.facebook.com/)
- Create new app
![Create new app](https://sanvay.herokuapp.com/images/screenshot_1.png)
- Add AccountKit to your Facebook Developer project
![Add AccountKit to your Facebook Developer project](https://sanvay.herokuapp.com/images/screenshot_2.png)
#### Note: If your project just provide for only 1 platform. You can skip the other part.
#### *** For Android Configuration:
- Open your project, create `strings.xml` file at this path: `\android\app\src\main\res`
- Add 2 variables like below:

```
<?xml version="1.0" encoding="utf-8"?>  
<resources>  
    <string name="FACEBOOK_APP_ID" translatable="false">[YOUR_FACEBOOK_APP_ID]</string>  
    <string name="ACCOUNT_KIT_CLIENT_TOKEN" translatable="false">[ACCOUNT_KIT_CLIENT_TOKEN]</string>  
</resources>
```

*About the Facebook App ID and Account Kit Client Token, please keep reading*

- Set up your AndroidManifest.xml in `/android/app/src/main`. Full code here.

#### *** For iOS Configuration:
- Open `ios\Runner\Info.plist` by right click -> open by source code
- Copy and paste this inside the space between **\<dict>\</dict>** tag.

```
	<key>FacebookAppID</key>
    <string>[YOUR_FACEBOOK_APP_ID]</string>
    <key>AccountKitClientToken</key>
    <string>[ACCOUNT_KIT_CLIENT_TOKEN]</string>
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>ak[YOUR_FACEBOOK_APP_ID]</string>
            </array>
        </dict>
    </array>
```

#### About Facebook App Id and Account Kit Client Token:
*YOUR_FACEBOOK_APP_ID: you can get it in picture below and simply press to copy*
![YOUR_FACEBOOK_APP_ID](https://sanvay.herokuapp.com/images/screenshot_3.png)
*ACCOUNT_KIT_CLIENT_TOKEN:*
![ACCOUNT_KIT_CLIENT_TOKEN](https://sanvay.herokuapp.com/images/screenshot_4.png)

...
It's done for configuration !! Let's go back to Flutter **main.dart**

## How to use?
It's very easy !!!
### 1. Add dependency to your pubspec.yaml file:

    dependencies:  
	    fb_accountkit_flutter: ^0.0.2

And do not forget to call `flutter get` to get the dependency in **pub.dev**

### 2. Import to your code:

    import 'package:fb_accountkit_flutter/fb_accountkit_flutter.dart';


### 3. Call open AccountKit whenever you want:

    Result result = await FbAccountkitFlutter.startAuthentication()

## Example Function
```
import 'dart:async';  
import 'package:flutter/services.dart';  
import 'package:fb_accountkit_flutter/fb_accountkit_flutter.dart';

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
  
}
```

You can read the full code in the example package also.


### Happy Coding !