//
//  AppDelegate.swift
//  MapExplorer
//
//  Created by Ilya on 15.05.2022.
//

import UIKit
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
#if DEBUG
        GMSServices.provideAPIKey("AIzaSyD8QBUyAchibx7cVk2x79-658RZndVPxS8")
#else
        // TODO: Make API Call for get key
        GMSServices.provideAPIKey("release key")
#endif
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else {
                print("Разрешение не получено")
                return
            }
            self.sendNotificatioRequest(content: self.makeNotificationContent(),
                                        trigger: self.makeIntervalNotificatioTrigger())
        }
		
		center.getNotificationSettings { settings in
			switch settings.authorizationStatus {
			case .authorized:
				print("Разрешение есть")
			case .denied:
				print("Разрешения нет")
			case .notDetermined:
				print("Неясно, есть или нет разрешение")
			default:
				break
			}
		}
		
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
    
    func makeNotificationContent() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Заходи не бойся"
        content.body = "Пора вершить великие дела"
        return content
    }
    
    func makeIntervalNotificatioTrigger() -> UNNotificationTrigger {
		// 1800 секунд - 30 минут
        return UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
    }
    
    func sendNotificatioRequest(content: UNNotificationContent, trigger: UNNotificationTrigger) {
        // Создаём запрос на показ уведомления
		let request = UNNotificationRequest(identifier: "alaram",
											content: content,
											trigger: trigger)
		
		let center = UNUserNotificationCenter.current() // Добавляем запрос в центр уведомлений
        center.add(request) { error in
            // Если не получилось добавить запрос,
            // показываем ошибку, которая при этом возникла
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }


}

