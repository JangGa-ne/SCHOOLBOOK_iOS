//
//  AppDelegate.swift
//  BusanEduBook
//
//  Created by i-Mac on 2020/07/20.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let GCM_MESSAGE_ID_KEY = "gcm.message_id"

    var WINDOW: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    var STORYBOARD: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    var NEW_VERSION: String = "1.0.0"
    
    var INDIVIDUAL_CONTACT_API: [INDIVIDUAL_CONTACT_DATA] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure() // Firebase 등록
        Messaging.messaging().delegate = self
        
        if let USER_INFO = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any] {

            print("PUSH로 진입 확인", USER_INFO)
        } else {

            let VC = STORYBOARD.instantiateViewController(withIdentifier: "LOADING") as! LOADING
            VC.modalTransitionStyle = .crossDissolve
            VC.PUSH_YN = false
            WINDOW?.rootViewController = VC
            WINDOW?.makeKeyAndVisible()
        }
        
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {

            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {granted, error in
                
                if let error = error {
                    print("USERNOTIFICAIONS ERROR: \(error.localizedDescription)")
                }
            })
        } else {
            
            let SETTINGS: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(SETTINGS)
        }
        application.registerForRemoteNotifications()
        // [END register_for_notifications]
        
        return true
    }
}

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        // 토큰을 문자열로 변환
        print("APNs device token: \(deviceToken)")
        // Print it to console
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.sandbox)
        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.prod)
        
        // Persist it in your backend in case it's new
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 콘솔에 오류를 인쇄하십시오 (등록에 실패했음을 사용자에게 알려야합니다)
        
        // print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
        
    func applicationWillResignActive(_ application: UIApplication) {
        // 응용 프로그램이 활성 상태에서 비활성 상태로 이동하려고 할 때 전송됩니다. 이는 특정 유형의 일시적인 중단 (예 : 전화 또는 SMS 메시지 수신) 또는 사용자가 응용 프로그램을 종료하고 백그라운드 상태로 전환하기 시작할 때 발생할 수 있습니다.
        // 이 방법을 사용하여 진행중인 작업을 일시 중지하고 타이머를 비활성화하고 그래픽 렌더링 콜백을 무효화하십시오. 게임은이 방법을 사용하여 게임을 일시 중지해야합니다.
        print("applicationWillResignActive")
        FIREBASE_HANDLER()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // 이 방법을 사용하여 공유 리소스를 해제하고, 사용자 데이터를 저장하고, 타이머를 무효화하고, 애플리케이션이 나중에 종료 될 경우 애플리케이션을 현재 상태로 복원 할 수있는 충분한 애플리케이션 상태 정보를 저장하십시오.
        // 애플리케이션이 백그라운드 실행을 지원하는 경우 사용자가 종료 할 때 applicationWillTerminate: 대신이 메소드가 호출됩니다.
        print("applicationDidEnterBackground")
        FIREBASE_HANDLER()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // 응용 프로그램이 비활성화 된 동안 일시 중지되었거나 아직 시작되지 않은 작업을 다시 시작하십시오. 응용 프로그램이 이전에 백그라운드에 있었던 경우 선택적으로 사용자 인터페이스를 새로 고칩니다. :.
        print("applicationWillEnterForeground")
        FIREBASE_HANDLER()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // 응용 프로그램이 비활성화 된 동안 일시 중지되었거나 아직 시작되지 않은 작업을 다시 시작하십시오. 애플리케이션이 이전에 백그라운드에 있었던 경우 선택적으로 사용자 인터페이스를 새로 고칩니다.
        print("applicationDidBecomeActive")
        FIREBASE_HANDLER()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // 응용 프로그램이 종료 되려고 할 때 호출됩니다. 적절한 경우 데이터를 저장하십시오. applicationDidEnterBackground: 참조하십시오.
        print("applicationWillTerminate")
        FIREBASE_HANDLER()
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        print("applicationDidFinishLaunching")
        FIREBASE_HANDLER()
    }
    
    func FIREBASE_HANDLER() {
        
//        Messaging.messaging().shouldEstablishDirectChannel = true
        Messaging.messaging().isAutoInitEnabled = true // 자동 초기화 방지
    }
        
    // 알림 받음.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let USERINFO = notification.request.content.userInfo
        
        print("userNotificationCenter-UNNotificationPresentationOptions")
        // 스위 즐링을 사용하지 않도록 설정 한 경우 분석을 위해 메시지에 메시지를 알려야합니다.
        Messaging.messaging().appDidReceiveMessage(USERINFO)
        
        if let MESSAGE_ID = USERINFO[GCM_MESSAGE_ID_KEY] {
            print("알림 받음 Message ID: \(MESSAGE_ID)")
        }
        
        // 전체 메시지를 인쇄하십시오.
        print("알림 받음 userNotificationCenter", USERINFO)
        
//        UIApplication.shared.applicationIconBadgeNumber += 1
        
//        let BOARD_KEY = USERINFO["board_key"] as? String ?? ""
//        let BOARD_TYPE = USERINFO["board_type"] as? String ?? ""
//        let PUSH_TYPE = USERINFO["push_type"] as? String ?? ""
//
//        PUSH_BADGE(BOARD_TYPE: BOARD_TYPE)
//        HTTP_PUSH_COUNT(BOARD_KEY: BOARD_KEY, BOARD_TYPE: BOARD_TYPE, PUSH_TYPE: PUSH_TYPE)
        
        completionHandler([.alert, .sound, .badge])
    }
    
    // 알림 누름.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let USERINFO = response.notification.request.content.userInfo
        
        print("userNotificationCenter")
        // 스위 즐링을 사용하지 않도록 설정 한 경우 분석을 위해 메시지에 메시지를 알려야합니다.
        
        Messaging.messaging().appDidReceiveMessage(USERINFO)
        
        // 메시지 ID를 인쇄하십시오.
        if let MESSAGE_ID = USERINFO[GCM_MESSAGE_ID_KEY] {
            print("알림 누름 Message ID: \(MESSAGE_ID)")
        }
        
        // 전체 메시지를 인쇄하십시오.
        print("알림 누름 userNotificationCenter", USERINFO)
        
        let BOARD_KEY = USERINFO["board_key"] as? String ?? ""
        let BOARD_TYPE = USERINFO["board_type"] as? String ?? ""
        
        let VC = STORYBOARD.instantiateViewController(withIdentifier: "LOADING") as! LOADING
        VC.modalTransitionStyle = .crossDissolve
        VC.PUSH_YN = true
        VC.BOARD_KEY = BOARD_KEY
        VC.BOARD_TYPE = BOARD_TYPE
        WINDOW?.rootViewController = VC
        WINDOW?.makeKeyAndVisible()
        
        completionHandler()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        UIViewController.USER_DATA.set("\(fcmToken)", forKey: "gcm_id")
        UIViewController.USER_DATA.synchronize()

        let DATADICT: [String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: DATADICT)
        // TODO: 필요한 경우 토큰을 응용 프로그램 서버로 보냅니다.
        // Note: 이 콜백은 앱이 시작될 때마다 그리고 새 토큰이 생성 될 때마다 시작됩니다.
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let DATADICT: [String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: DATADICT)
        // TODO : 필요한 경우 애플리케이션 서버에 토큰을 보냅니다.
        // 참고 : 이 콜백은 앱이 시작될 때마다 그리고 새 토큰이 생성 될 때마다 시작됩니다.
    }
    
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print("Received data message: \(remoteMessage.appData)")
//        Messaging.messaging().shouldEstablishDirectChannel = true
//    }
}
