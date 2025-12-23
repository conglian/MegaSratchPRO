import Flutter
import UIKit
import AdSupport
import AppTrackingTransparency

@main
@objc class AppDelegate: FlutterAppDelegate {

  private var enterDate : Date?

  private var idfaStr : String = ""
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

extension AppDelegate {

    override func applicationDidBecomeActive(_ application: UIApplication) {
        if let date = enterDate {

            if isDifferenceGreaterThanOrEqualThreeSeconds(date1: date, date2: Date()) {
                enterDate = nil
            }
        }
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                print("idfa \(ASIdentifierManager.shared().advertisingIdentifier)");
                self.idfaStr = "\(ASIdentifierManager.shared().advertisingIdentifier)";
            })
        } else {
            // Fallback on earlier versions
        }
    }


    override func applicationDidEnterBackground(_ application: UIApplication) {
        enterDate = Date();
    }

    func isDifferenceGreaterThanOrEqualThreeSeconds(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current

        let components = calendar.dateComponents([.second], from: date1, to: date2)

        if let seconds = components.second {
            return seconds >= 3
        } else {
            return false
        }
    }
}
