package fb.accountkit.fb_accountkit_flutter;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import com.facebook.accountkit.Account;
import com.facebook.accountkit.AccountKit;
import com.facebook.accountkit.AccountKitCallback;
import com.facebook.accountkit.AccountKitError;
import com.facebook.accountkit.AccountKitLoginResult;
import com.facebook.accountkit.PhoneNumber;
import com.facebook.accountkit.ui.AccountKitActivity;
import com.facebook.accountkit.ui.AccountKitConfiguration;
import com.facebook.accountkit.ui.LoginType;

import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import static android.app.Activity.RESULT_OK;

/** FbAccountkitFlutterPlugin */
public class FbAccountkitFlutterPlugin implements MethodCallHandler, PluginRegistry.ActivityResultListener {
  private final Activity activity;
  private static final int FACEBOOK_LOGIN_REQUEST_CODE = 123;
  private static final String FAILED = "1";
  private static final String CHANNEL_NAME = "fb_accountkit_flutter";
  private static final String METHOD_NAME = "open_facebook_activity";
  private static final String PHONE_ARGUMENT= "phone";
  private static final String DEFAULT_COUNTRY_CODE_ARGUMENT= "default_country_code";
  private static final String COUNTRY_CODE_ISO_ARGUMENT= "country_code_iso";
  private static final String COUNTRY_CODE_ARGUMENT= "country_code";
  private MethodChannel.Result mResult;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL_NAME);
    FbAccountkitFlutterPlugin flutterPlugin = new FbAccountkitFlutterPlugin(registrar.activity());
    registrar.addActivityResultListener(flutterPlugin);
    channel.setMethodCallHandler(flutterPlugin);
  }

  public FbAccountkitFlutterPlugin(Activity activity) {
    this.activity = activity;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    mResult = result;
    switch (call.method) {
      case METHOD_NAME:
        String phone = call.argument(PHONE_ARGUMENT);
        String defaultCountryCode = call.argument(DEFAULT_COUNTRY_CODE_ARGUMENT);
        String countryCodeIso = call.argument(COUNTRY_CODE_ISO_ARGUMENT);
        String countryCode = call.argument(COUNTRY_CODE_ARGUMENT);
        openFacebookAccountKitActivity(phone, defaultCountryCode, countryCodeIso, countryCode);
        break;
      default:
        result.notImplemented();
    }
  }

  private void openFacebookAccountKitActivity(String phone, String defaultContryCode, String countryCodeIso, String countryCode) {
    Intent intent = new Intent(activity, AccountKitActivity.class);
    AccountKitConfiguration.AccountKitConfigurationBuilder configurationBuilder = new AccountKitConfiguration.AccountKitConfigurationBuilder(
            LoginType.PHONE, AccountKitActivity.ResponseType.TOKEN);
    if (defaultContryCode != null)
      configurationBuilder.setDefaultCountryCode(defaultContryCode);
    configurationBuilder.setReadPhoneStateEnabled(false);
    if (phone != null)
      configurationBuilder.setInitialPhoneNumber(new PhoneNumber(countryCodeIso, phone.substring(1), countryCode));
    intent.putExtra(AccountKitActivity.ACCOUNT_KIT_ACTIVITY_CONFIGURATION, configurationBuilder.build());
    activity.startActivityForResult(intent, FACEBOOK_LOGIN_REQUEST_CODE);

  }


  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    if (requestCode == FACEBOOK_LOGIN_REQUEST_CODE && resultCode == RESULT_OK) {
      AccountKitLoginResult loginResult;
      if (data != null) {
        loginResult = data.getParcelableExtra(AccountKitLoginResult.RESULT_KEY);
        if (loginResult.getAccessToken() != null) {
          AccountKit.getCurrentAccount(new AccountKitCallback<Account>() {
            @Override
            public void onSuccess(Account account) {
              if (mResult != null) {
                ReturnedResult returnedResult = new ReturnedResult(account.getId(), account.getPhoneNumber().getPhoneNumber(), account.getEmail());
                mResult.success(returnedResult.toJson());
              }
            }

            @Override
            public void onError(AccountKitError accountKitError) {
              if (mResult != null) {
                mResult.error(FAILED, null, null);
              }
            }
          });
        }
      }
    }
    return false;
  }

  private class ReturnedResult {
    String id;
    String phone;
    String email;

    ReturnedResult(String id, String phone, String email) {
      this.id = id;
      this.phone = phone;
      this.email = email;
    }

    String toJson() {
      JSONObject object = new JSONObject();
      try {
        object.put("phone", phone);
        if (email != null) {
          object.put("email", email);
        }
        if (id != null) {
          object.put("id", id);
        }
      } catch (JSONException e) {
        e.printStackTrace();
      }
      return object.toString();
    }
  }
}
