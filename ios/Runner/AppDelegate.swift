import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(Config.GOOGLE_MAP_KEY)
        GeneratedPluginRegistrant.register(with: self)
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
