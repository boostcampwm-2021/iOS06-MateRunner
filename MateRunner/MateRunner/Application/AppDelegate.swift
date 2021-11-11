//
//  AppDelegate.swift
//  MateRunner
//
//  Created by 이정원 on 2021/10/29.
//

import CoreData
import UIKit
import UserNotifications

import Firebase
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions:[UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
            
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter
          .current()
          .requestAuthorization(
            options: authOptions,completionHandler: { (_, _) in }
          )
        application.registerForRemoteNotifications()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MateRunner")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        let ref: DatabaseReference = Database.database().reference()
        print("파이어베이스 토큰: \(fcmToken)")
        
        // TODO: userId 받아와서 jk 대체
        
        ref.child("fcmToken/\(User.mate.rawValue)").setValue(fcmToken) { error, _ in
            print(error as Any)
        }
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,didReceive response: UNNotificationResponse,withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        guard let sessionId = userInfo["sessionId"] as? String,
              let host = userInfo["host"] as? String,
              let inviteTime = userInfo["inviteTime"] as? String,
              let modeString = userInfo["mode"] as? String,
              let mode = RunningMode.init(rawValue: modeString),
              let targetDistanceString = userInfo["targetDistance"] as? String,
              let targetDistance = Double(targetDistanceString),
              let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController
        else {
            return
        }
        
        let invitation: Invitation = Invitation(sessionId: sessionId, host: host, inviteTime: inviteTime, mode: mode, targetDistance: targetDistance)
        dump(invitation)
        
        // TODO: 초대장 VC에 invitation 넘겨주기
        
        let viewController = InvitationViewController(mate: invitation.host, mode: invitation.mode, distance: invitation.targetDistance)
        viewController.modalPresentationStyle = .fullScreen
        rootViewController.present(viewController, animated: false, completion: nil)
        completionHandler()
    }
}
