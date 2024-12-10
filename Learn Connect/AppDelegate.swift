//
//  AppDelegate.swift
//  Learn Connect
//
//  Created by Omer on 4.12.2024.
//

import UIKit
import Network

@main
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {


    let monitor = NWPathMonitor()
    let queue = DispatchQueue.global(qos: .background)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        monitor.pathUpdateHandler = { path in
            print(path.status)
            if path.status != .satisfied {
                DispatchQueue.main.async {
                    print("bağlantı yok")
                    guard let rootVC = UIApplication.shared.windows.first?.rootViewController else { return }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        ToastManager.shared.showToast(
                            message: "İnternet bağlantısı yok",
                            buttonTitle: "İndirilenlere gözat",
                            on: rootVC,
                            transitionTo: MyCourseViewController()
                        )
                    }
                }
            } else {
                print("var \(path.status)")
            }
        }

               
               monitor.start(queue: queue)
  // Override point for customization after application launch.
            UNUserNotificationCenter.current().delegate = self
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
         let identifier = response.notification.request.identifier
            
         

         completionHandler()
     }
    
   
    
      func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
          completionHandler([.alert, .sound])
          
      }

}

