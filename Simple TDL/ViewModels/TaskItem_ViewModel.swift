//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import Foundation
import SwiftUI

class TaskItem_ViewModel: ObservableObject {
    
    // ======================================================================
    // MARK: Init
    // ======================================================================

	init() {}
    
    // ======================================================================
    // MARK: Functions
    // ======================================================================

	// MARK: func returnPriorityColor
	// Function that takes String that represents priority of the task
	// and returns Color accordingly
	func returnPriorityColor(_ priority: String, _ isCompleted: Bool) -> Color {
		if isCompleted {
			return DefaultSettings.shared.darkGreenColor
		}
		else {
			let prioAsInt: Int = Int(String(priority.first!)) ?? 0

			switch prioAsInt {
                case 1: return DefaultSettings.shared.darkPinkColor
                case 2: return DefaultSettings.shared.darkOrangeColor
                case 3: return DefaultSettings.shared.darkYellowColor
                case 4: return DefaultSettings.shared.darkBlueColor
                default: return .clear
			}
		}
	}
    
    /***********************************************************************/

	// MARK: func returnFormattedTitle
	// Function that takes String containing task's name/title
	// checks it lenght and returns shorter version if needed
	func returnFormattedTitle(_ title: String) -> String {
		if title.count <= 20 {
			return title
		}
		else {
			return title.prefix(17) + "..."
		}
	}
    
    /***********************************************************************/

	// MARK: func returnFormattedDeadline
	// Function that takes TimeInterval with task's scheduled deadline
	// and returns it as formatted string
	func returnFormattedDeadline(_ deadline: TimeInterval?) -> String {
		if deadline != nil && deadline != 0.0 {
			// convert time interval to date
			let deadlineDate = Date(timeIntervalSince1970: deadline!)

			// format date
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "EEE, dd.MM.yyyy - HH:mm"

			// asign formated date to string
			let formattedDeadline = dateFormatter.string(from: deadlineDate)

			// calculate remaining time and convert it to string
			let currentDate = Date()
			let remainingTimeInterval = max(
				deadline! - currentDate.timeIntervalSince1970,
				0
			)

			// calculate remaining days and weeks
			let remainingDays = Int(remainingTimeInterval / (24 * 3600))
			let remainingWeeks = Int(remainingDays / 7)

			// format string with time remaining based on weeks/days/hours remaining
			var remainingTime = ""

			if remainingDays >= 7 {
				// display remaining weeks
				remainingTime =
					"\(remainingWeeks) week\(remainingWeeks == 1 ? "" : "s")"
			}
			else if remainingDays >= 1 {
				// display remaining days
				remainingTime =
					"\(remainingDays) day\(remainingDays == 1 ? "" : "s")"
			}
			else {
				// display hours and minutes if the time remaining is shorter than 1 day
				let remainingHours = Int(remainingTimeInterval / 3600)
				let remainingMinutes = Int((Int(remainingTimeInterval) % 3600) / 60)

				if remainingHours >= 1 {
					remainingTime =
						"\(remainingHours) hour\(remainingHours == 1 ? "" : "s") and "
				}

				remainingTime +=
					"\(remainingMinutes) minute\(remainingMinutes == 1 ? "" : "s")"
			}

			// return as "Deadline: hh:mm dd/MM/YYYY\n(X weeks/days/hours and minutes remaining)"
			return "Deadline: \(formattedDeadline)\n(\(remainingTime) remaining)"
		}
		else {
			return "No deadline"
		}
	}
    
    /***********************************************************************/
}
