//
//  UserNotificationsScheduler.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 05/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import UserNotifications

struct UserNotificationsScheduler: NotificationScheduler {

    func scheduleNotification(forEvent identifier: EventIdentifier,
                              at date: Date,
                              title: String,
                              body: String,
                              userInfo: [ApplicationNotificationKey: String]) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.userInfo = userInfo

        let desiredComponents: Set<Calendar.Component> = Set([.year, .month, .day, .hour, .minute])
        let components = Calendar.current.dateComponents(desiredComponents, from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(identifier: identifier.rawValue, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Failed to add notification with error: \(error)")
            }
        }
    }

    func cancelNotification(forEvent identifier: EventIdentifier) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier.rawValue])
    }

}
