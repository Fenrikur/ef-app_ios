//
//  AppDelegate.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import EurofurenceModel

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

	var window: UIWindow? = UIWindow()
    var app: EurofurenceSession!
    private var director: ApplicationDirector?

	func application(_ application: UIApplication,
	                 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ScreenshotAssistant.prepare()
        FirebaseApp.configure()
        installDebugModuleIntoWindow()
        Theme.apply()
        UNUserNotificationCenter.current().delegate = self

        let services = SharedModel.instance.services
        let director = DirectorBuilder(linkLookupService: services.contentLinks, notificationHandling: services.notifications).build()
        services.contentLinks.setExternalContentHandler(director)

        self.director = director

        window?.makeKeyAndVisible()
        ReviewPromptController.initialize()

		return true
	}

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        SharedModel.instance.services.notifications.storeRemoteNotificationsToken(deviceToken)
    }

	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        SharedModel.instance.notificationFetchResultAdapter.handleRemoteNotification(userInfo, completionHandler: completionHandler)
	}

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        director?.openNotification(response.notification.request.content.userInfo, completionHandler: completionHandler)
    }

}

// MARK: - Debug Window

extension AppDelegate {

    private func installDebugModuleIntoWindow() {
        guard let window = window else { return }

        let complicatedGesture = UITapGestureRecognizer(target: self, action: #selector(showDebugMenu))
        complicatedGesture.numberOfTouchesRequired = 2
        complicatedGesture.numberOfTapsRequired = 5
        window.addGestureRecognizer(complicatedGesture)
    }

    @objc private func showDebugMenu(_ sender: UIGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Debug", bundle: .main)
        guard let viewController = storyboard.instantiateInitialViewController() else { return }

        let host = UINavigationController(rootViewController: viewController)
        host.modalPresentationStyle = .formSheet
        window?.rootViewController?.present(host, animated: true)
    }

}
