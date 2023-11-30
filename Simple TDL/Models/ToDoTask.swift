//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import Foundation

struct ToDoTask: Codable, Identifiable {
	let id: Int64?
	var title: String
	var description: String
	var creationDate: TimeInterval
	var deadlineDate: TimeInterval?
	var reminderDate: TimeInterval?
	var selectedPriority: String
	var isHidden: Bool
	var isCompleted: Bool
}
