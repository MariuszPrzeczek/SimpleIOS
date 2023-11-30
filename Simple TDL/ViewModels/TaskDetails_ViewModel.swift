//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import Foundation
import SwiftUI

class TaskDetails_ViewModel: ObservableObject {
    // ======================================================================
    // MARK: Variables
    // ======================================================================
    
    // State variables
	@Published var id: Int64 = 0
	@Published var title: String = ""
	@Published var description: String = ""
	@Published var creationDate: String = ""
	@Published var deadlineDate: String = ""
	@Published var reminderDate: String = ""
	@Published var selectedPriority: String = ""
	@Published var isHidden: String = ""
	@Published var isCompleted: String = ""
    
    // ToDoTask variable that's passed to edit view
	var task: ToDoTask? = nil

    // Show edit and complete buttons if task isn't completed 
	@Published var showEditAndCompleteButtons: Bool = false
    
    // ======================================================================
    // MARK: Init
    // ======================================================================

	init() {}
    
    // ======================================================================
    // MARK: Functions
    // ======================================================================

    // MARK: getAndFillData
    // Function that gets task from the DataStore and fills
    // Published variables
	func getAndFillData(taskId: Int64) {
        // Assign id passed from the View
		self.id = taskId
        
        // Get task from the DataStore
		task = DataStore.shared.getTaskByID(id: taskId)

        // Stop here if DataStore returns 'nil'
		guard task != nil else { return }

        // Display detailed info about the task
		self.title = task!.title
		self.description = formatDescriptionString(task!.description)
		self.creationDate = formatDateToString(task!.creationDate)
		self.deadlineDate = formatDateToString(task!.deadlineDate)
		self.reminderDate = formatDateToString(task!.reminderDate)
		self.selectedPriority = formatPriorityString(task!.selectedPriority)
		self.isHidden = formatBoolToString(task!.isHidden)
		self.isCompleted = formatBoolToString(task!.isCompleted)

        // Update buttons shown based on task complition status
		showEditAndCompleteButtons = !task!.isCompleted
	}
    
    /***********************************************************************/

    // MARK: func completeTask
    // Function that asks DataStore to mark task as completed
    func completeTask() -> Bool {
        // Send request to the DataStore
        return DataStore.shared.completeTask(id: self.id)
    }
    
    /***********************************************************************/

    // MARK: func deleteTask
    // Function that asks DataStore to delete this task
    func deleteTask() -> Bool {
        // Send request to the DataStore
        return DataStore.shared.deleteTask(id: self.id)
    }
    
    /***********************************************************************/

    // MARK: func formatBoolToString
    // Function that takes true or false and returns "yes" or "no" accordingly
    func formatBoolToString(_ value: Bool) -> String {
        return value ? "yes" : "no"
    }
    
    /***********************************************************************/

    // MARK: func formatPriorityString
    // Format priority string to trim some unneeded text
	func formatPriorityString(_ text: String) -> String {
		let index: String.Index = text.index(text.lastIndex(of: " ")!, offsetBy: 1)
		return String(text[index...])
	}
    
    /***********************************************************************/

    // MARK: func formatDescriptionString
    // Returns "-" if description is empty
    func formatDescriptionString(_ text: String) -> String {
        return text.isEmpty ? "-" : text
    }
    
    /***********************************************************************/

    // MARK: func deleteTask
    // Takes TimeInterval and returns it formatted String
    // Returns "-" if received 'nil' or TimeInterval is '0.0'
	func formatDateToString(_ date: TimeInterval?) -> String {
		if date == nil || date == 0.0 {
			return "-"
		}
		else {
			let datetime = Date(timeIntervalSince1970: date!)
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "EEE, dd.MM.yyyy - HH:mm"
			return "\(dateFormatter.string(from: datetime))"
		}
	}
    
    /***********************************************************************/

}
