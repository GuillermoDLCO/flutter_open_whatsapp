import Flutter
import UIKit

public class SwiftFlutterOpenWhatsappPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_open_whatsapp", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterOpenWhatsappPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method == "getPlatformVersion"){
            result("iOS " + UIDevice.current.systemVersion)
        } else if(call.method == "sendSingleMessage"){
            DispatchQueue.main.async{
                guard let args = call.arguments else {
                    return
                }
                if let myArgs = args as? [String: Any],
                    let mobileNo = myArgs["mobileNo"] as? String,
                    let message = myArgs["message"] as? String {
                    let url: String = ("https://wa.me/" + mobileNo + "?text=" + (message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
                    if let whatsAppUrl = URL(string: url) {
                        if UIApplication.shared.canOpenURL(whatsAppUrl) {
                            UIApplication.shared.openURL(whatsAppUrl)
                        }else {
                            result("Please, install whatsapp")
                        }
                    } else {
                        result("Something happened")
                    }
                }
            }
        }
    }
    
}