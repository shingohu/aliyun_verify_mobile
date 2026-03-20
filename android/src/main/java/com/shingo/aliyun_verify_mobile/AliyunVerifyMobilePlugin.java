package com.shingo.aliyun_verify_mobile;

import android.content.Context;

import androidx.annotation.NonNull;

import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
import com.mobile.auth.gatewayauth.PreLoginResultListener;
import com.mobile.auth.gatewayauth.TokenResultListener;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * AliyunVerifyMobilePlugin
 */
public class AliyunVerifyMobilePlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private PhoneNumberAuthHelper phoneNumberAuthHelper;
    private Context applicationContext;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        applicationContext = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.shingo.aliyun_verify_mobile");
        channel.setMethodCallHandler(this);

    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        initPhoneNumberAuthHelper();
        String method = call.method;
        if ("setAuthSDKInfo".equals(method)) {
            String secretInfo = call.argument("secretInfo");
            phoneNumberAuthHelper.setAuthSDKInfo(secretInfo);
            result.success(true);
        } else if ("getVerifyToken".equals(method)) {
            int totalTimeout = call.argument("totalTimeout");
            phoneNumberAuthHelper.getVerifyToken(totalTimeout);
            result.success(true);
        }else if("accelerateVerify".equals(method)){
            int overdueTimeMills = call.argument("overdueTimeMills");
            phoneNumberAuthHelper.accelerateVerify(overdueTimeMills, new PreLoginResultListener() {
                @Override
                public void onTokenSuccess(String s) {
                    result.success(true);
                }

                @Override
                public void onTokenFailed(String s, String s1) {
                    result.success(false);
                }
            });
        }else if("checkEnvAvailable".equals(method)){
            int serviceType = call.argument("serviceType");
            phoneNumberAuthHelper.checkEnvAvailable(serviceType);
            result.success(true);
        }

    }


    void initPhoneNumberAuthHelper() {
        if (phoneNumberAuthHelper == null && applicationContext != null) {
            phoneNumberAuthHelper = PhoneNumberAuthHelper.getInstance(applicationContext, new TokenResultListener() {
                @Override
                public void onTokenSuccess(String s) {
                    channel.invokeMethod("onTokenResult",s);
                }

                @Override
                public void onTokenFailed(String s) {
                    channel.invokeMethod("onTokenResult",s);
                }
            });
        }
    }


    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

}
