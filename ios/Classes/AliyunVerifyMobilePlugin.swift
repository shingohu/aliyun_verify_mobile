import Flutter
import UIKit
import ATAuthSDK

public class AliyunVerifyMobilePlugin: NSObject, FlutterPlugin {
    
    
    var channel:FlutterMethodChannel?
    
    
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.shingo.aliyun_verify_mobile", binaryMessenger: registrar.messenger())
    let instance = AliyunVerifyMobilePlugin()
    instance.channel = channel
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      let method = call.method
      
      if(method == "setAuthSDKInfo"){
          let secretInfo = (call.arguments as! Dictionary<String, Any>)["secretInfo"] as! String
          TXCommonHandler.sharedInstance().setAuthSDKInfo(secretInfo)
          result(true)
      }else if(method == "getVerifyToken"){
          let totalTimeout = (call.arguments as! Dictionary<String, Any>)["totalTimeout"] as! Int
          TXCommonHandler.sharedInstance().getVerifyToken(withTimeout: TimeInterval(totalTimeout),complete: {result in
              if(self.channel != nil){
                  self.channel?.invokeMethod("onTokenResult", arguments: self.toJsonString(dic: result as! Dictionary<String, Any>))
              }
          })
          result(true)
      }else if(method == "accelerateVerify"){
          let overdueTimeMills = (call.arguments as! Dictionary<String, Any>)["overdueTimeMills"] as! Int
          TXCommonHandler.sharedInstance().accelerateVerify(withTimeout: TimeInterval(overdueTimeMills))
          result(true)
          
      }else if(method == "checkEnvAvailable"){
          let serviceType = (call.arguments as! Dictionary<String, Any>)["serviceType"] as! Int
          TXCommonHandler.sharedInstance().checkEnvAvailable(with: PNSAuthType.init(rawValue: serviceType)!)
          result(true)
      }
      
      
  }
    func toJsonString(dic:Dictionary<String, Any>) -> String? {
            guard let data = try? JSONSerialization.data(withJSONObject: dic) else {
                return nil
            }
            return String(data: data, encoding: .utf8)
        }
    
}
