import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

late _AliyunVerifyMobile AliyunVerifyMobile = _AliyunVerifyMobile._();

class AliyunVerifyMobileResult {
  final String? token;
  final String msg;
  final AliyunVerifyMobileResultCode code;
  final String data;

  AliyunVerifyMobileResult(this.data, this.code, this.msg, {this.token});
}

//https://help.aliyun.com/zh/pnvs/developer-reference/error-code-5?spm=a2c4g.11186623.help-menu-75010.d_5_2_3_5.35222e86cYZg9g
class AliyunVerifyMobileResultCode {
  static String SUCCESS = "600000";
  static String TERMINAL_NOT_SECURE = "600005";
  static String SIM_CARD_NOT_DETECTED = "600007";
  static String NETWORK_NOT_TURNED_ON = "600008";
  static String UNKNOWN_ERROR = "600010";
  static String GET_TOKEN_FAIL = "600011";
  static String TIMEOUT = "600015";

  final String code;

  const AliyunVerifyMobileResultCode(this.code);
}

class _AliyunVerifyMobile {
  final MethodChannel _channel = MethodChannel('com.shingo.aliyun_verify_mobile');

  Completer<String>? _verifyComplete;

  AliyunVerifyMobileResult? _lastResult;

  AliyunVerifyMobileResult? get lastResult => _lastResult;

  _AliyunVerifyMobile._() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    if (call.method == "onTokenResult") {
      String data = call.arguments;
      if (_verifyComplete?.isCompleted == false) {
        _verifyComplete?.complete(data);
      }
    }
  }

  // MCYant+8SGLuOJBCiJMvBC812GjnqzYH1gaNCrtl/KNebYaXSlCQbSYzSu/yfkTtbOPUx3kORNKrlrnH271IqkJTm/yxeXNMNN9EiuGedKqxViRcqt/H3iAKnm9G+9iNrFL3CVPQrSd0jOaGuO1v+xaTc44fg6snDzzSzzrFaWgGTNKMbfRc7y5RLeTyKIXi/iqyltVH5v+utN+AKr0bJaq1P2G8ZW9m52jRemszIRo2h3qhEmeexgJsN053B14eexe9k6TG5yGQwmvQNQEds/77w+MKtmXJrcvXli9LZq4=
  Future<void> setAuthSDKInfo(String secretInfo) async {
    await _channel.invokeMethod("setAuthSDKInfo", {"secretInfo": secretInfo});
  }

  Future<AliyunVerifyMobileResult> getVerifyToken({int timeout = 5000}) async {
    if (_verifyComplete == null) {
      _verifyComplete = Completer();
    }
    await _channel.invokeMethod("getVerifyToken", {"totalTimeout": timeout});
    String result = await _verifyComplete!.future;
    _verifyComplete = null;
    Map json = jsonDecode(result);
    String? token = json["token"];
    if (token?.trim().isEmpty == true) {
      token = null;
    }
    _lastResult = AliyunVerifyMobileResult(
      result,
      AliyunVerifyMobileResultCode(json["code"] ?? json["resultCode"]),
      json["msg"] ?? "",
      token: token,
    );
    return _lastResult!;
  }

  Future<void> accelerateVerify({int overdueTimeMills = 5000}) async {
    await _channel.invokeMethod("accelerateVerify", {"overdueTimeMills": overdueTimeMills});
  }
}
