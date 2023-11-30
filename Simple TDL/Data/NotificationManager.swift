//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    // ======================================================================
    // MARK: Variables
    // ======================================================================
    
    // Singleton pattern
	static let shared = NotificationManager()

    // Does the application have push notification permissions?
	@Published var notificationPermissionGranted = false
    
    // ======================================================================
    // MARK: Init
    // ======================================================================

    init() { 
        // Check if required permissions were granted
        checkNotificationPermissions()
    }
    
    // ======================================================================
    // MARK: Functions
    // ======================================================================

    // MARK: func requestPermissions
    // Function that request permissions needed to send notifications
    // to the user
	func requestNotificationPermissions() {
        // Specify which options will be needed:
        // .aler: sending notifications, includes title and description
        // .sound: allows sound notification
        // .badge: allows AppIcon (or any other selected icon) in
        // notification area
		let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        // Request authorization for selected options
		UNUserNotificationCenter.current().requestAuthorization(options: options) {
			(success, error) in
            
            // Handle Error
			if let error = error {
				print("Error: \(error)")
                DispatchQueue.main.async {
                    self.notificationPermissionGranted = false
                }
			}
            
            // handle Success
            if success {
                DispatchQueue.main.async {
                    self.notificationPermissionGranted = true
                }
            }
		}
	}
    
    /***********************************************************************/

    // MARK: func checkNotificationPermissions
    // Confirm whether or not user has allowed push notifications
	func checkNotificationPermissions() {

		UNUserNotificationCenter.current().getNotificationSettings { 
            settings in

			if settings.authorizationStatus == .authorized {
                // Permissions are granted
                DispatchQueue.main.async {
                    self.notificationPermissionGranted = true
                }
			} else {
                // Permissions are NOT granted
                DispatchQueue.main.async {
                    self.notificationPermissionGranted = false
                }
			}
		}
	}
    
    /***********************************************************************/

    // MARK: func scheduleNotification
    // Function that schedules push notification based on received variable:
    // id: Double - in case of this app timeIntervalSince1970 of the date of creation
    // title: String - bigger text shown in notification
    // description: String - smaller text
    // date: Date - when user should receive the notification
    // IMPORTANT: User can only receive notification when the app is not in focus
	func scheduleNotification(id: Double, title: String, description: String, date: Date) {
        // Prepare notification content
		let content = UNMutableNotificationContent()
		content.title = title
		content.subtitle = description
        // Default notifications sound
		content.sound = .default
        // Select AppIcon as the badge
		content.badge = 1

		// Split Date into DateComponents
		let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute]
		let dateComponents: DateComponents = Calendar.current.dateComponents(
			components, from: date)

        // Schedule notification trigger based on DateComponens and do not repeat
		let trigger = UNCalendarNotificationTrigger(
			dateMatching: dateComponents, repeats: false)

        // Prepare request
		let request = UNNotificationRequest(
			identifier: "STDL\(id)", content: content, trigger: trigger)

        // Send notification request to the system
		UNUserNotificationCenter.current().add(request)
	}
    
    /***********************************************************************/

    // MARK: func cancelNotification
    // Cancel scheduled notification based on id: Double, which
    // in case of this app is timeIntervalSince1970 of the date of creation.
	func cancelNotification(id: Double) {
        // Get pending notifications from the system
		UNUserNotificationCenter.current().getPendingNotificationRequests {
			(notificationRequests) in
			var identifiers: [String] = []
            
            // Check all pending notifications for match
			for notification: UNNotificationRequest in notificationRequests {
                // If match is found add it to identifiers array
				if notification.identifier == "STDL\(id)" {
					identifiers.append(notification.identifier)
				}
			}
            
            // remove all pending notifications with matching identifiers is array
			UNUserNotificationCenter.current().removePendingNotificationRequests(
				withIdentifiers: identifiers)
		}
	}
    
    /***********************************************************************/

}
