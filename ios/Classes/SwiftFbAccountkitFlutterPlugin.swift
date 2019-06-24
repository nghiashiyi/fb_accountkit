import Flutter
import UIKit
import AccountKit

public class SwiftFbAccountkitFlutterPlugin: NSObject, FlutterPlugin, AKFViewControllerDelegate {
    let METHOD_NAME = "open_facebook_activity"
    var mResult:FlutterResult?
    var accountKit: AccountKit?
    var myViewController:UIViewController?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "fb_accountkit_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftFbAccountkitFlutterPlugin()
        instance.myViewController = (UIApplication.shared.delegate?.window??.rootViewController)!
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == METHOD_NAME {
            mResult = result
            if let arguments = call.arguments, let args = arguments as? [String: String] {
                let phone = args["phone"]
                let countryCodeIso = args["country_code_iso"]
                let countryCode = args["country_code"]
                let defaultCountryCode = args["default_country_code"]

                openFacebookAuthentication(phone: phone, defaultCountryCode: defaultCountryCode!, countryCode: countryCode!, countryISO: countryCodeIso!)
                
            }
        } else {
            print("Flutter: Null Method \(call.method)")
            result("1")
        }
    }
    
    public func openFacebookAuthentication(phone:String?, defaultCountryCode:String, countryCode:String, countryISO: String) {
        if accountKit == nil {
            accountKit = AccountKit(responseType: .accessToken)
        }
        let inputState = UUID().uuidString
        let afPhone = PhoneNumber(countryCode: countryCode, countryISO: countryISO, phoneNumber: phone ?? "")
        let vc = (accountKit?.viewControllerForPhoneLogin(with: afPhone, state: inputState))!
        vc.isSendToFacebookEnabled = true
        vc.delegate = self
        vc.defaultCountryCode = defaultCountryCode
        
        self.prepareLoginViewController(loginViewController: vc)
        myViewController?.present(vc as UIViewController, animated: true, completion: nil)
    }
    
    func prepareLoginViewController(loginViewController: AKFViewController) {
        loginViewController.delegate = self
        //UI Theming - Optional
        loginViewController.uiManager = SkinManager(skinType: .classic, primaryColor: UIColor.blue)
    }
    
    public func viewController(_ viewController: UIViewController & AKFViewController, didCompleteLoginWith accessToken: AccessToken, state: String) {
    
        let accountKit = AccountKit(responseType: .accessToken)
        accountKit.requestAccount({ (account, error) in
            if let error = error {
                print(error)
                self.mResult?("1")
                return
            }
            if let account = account, let phoneNumber = account.phoneNumber {
                let dict = [
                    "phone": phoneNumber.phoneNumber,
                    "email": account.emailAddress ?? "",
                    "id": account.accountID
                            ]
                if let jsonData = try? JSONSerialization.data(
                    withJSONObject: dict,
                    options: []) {
                    let returnedJsonString = String(data: jsonData,
                                             encoding: .ascii)
                    self.mResult?(returnedJsonString)
                }
            }
        })
    }
   
}
