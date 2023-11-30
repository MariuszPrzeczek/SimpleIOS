//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import Foundation

class TaskForm_ViewModel: ObservableObject {
    // ======================================================================
    // MARK: Variables
    // ======================================================================

	// state variables
	@Published var taskTitle: String = ""
	@Published var taskAdditionalNotes: String = ""
	@Published var addDeadline: Bool = false
	@Published var taskDeadlineDate: Date = Date()
	@Published var addReminder: Bool = false
	@Published var taskReminderDate: Date = Date()
	@Published var selectedPriority = "3 - normal"
	@Published var priorityOptions = ["1 - highest", "2 - high", "3 - normal", "4 - low"]
	@Published var isTaskHidden = false

    // Error/Success text placeholder
	@Published var errorText: String? = nil
	@Published var successText: String? = nil
    
    // State variable for some of the button text that's changing
    // depending on whether or not it's a new task or existing one
	@Published var buttonText: String = ""
	@Published var isTaskNew = true

	// Variables for task that's being edited
	private var editedTasksID: Int64? = nil
    private var editedTasksCreationDate: Date = Date()
    
    // ======================================================================
    // MARK: Init
    // ======================================================================

	init() {}
    
    // ======================================================================
    // MARK: Functions
    // ======================================================================

    // MARK: fillFormIfNotNil
    // Function that if receives ToDoTask object fills so it can be edited
	func fillFormIfNotNil(_ task: ToDoTask?) {
		guard task != nil else {
			buttonText = "Save task"
			return
		}

        // Fill data of the task that's being edited
		buttonText = "Update task"
		isTaskNew = false

        editedTasksID = task!.id
		taskTitle = task!.title
		taskAdditionalNotes = task!.description
        editedTasksCreationDate = Date(timeIntervalSince1970: task!.creationDate)
		if task!.deadlineDate != nil && task!.deadlineDate != 0.0 {
			addDeadline = true
			taskDeadlineDate = Date(timeIntervalSince1970: task!.deadlineDate!)
		}
		if task!.reminderDate != nil && task!.reminderDate != 0.0 {
			addReminder = true
			taskReminderDate = Date(timeIntervalSince1970: task!.reminderDate!)
		}
		selectedPriority = task!.selectedPriority
		isTaskHidden = task!.isHidden
	}
    
    /***********************************************************************/

    // MARK: func saveOrUpdateTaskButtonAction
    // Saves new or updates existing task
	func saveOrUpdateTaskButtonAction() {

        // Check if inputs are valid
		guard checkInputs() else { return }
        
        // Create variable with current DateTime for new task or
        // copy edited task's creation date
        let creationDate: TimeInterval = (isTaskNew ?
                Date() : editedTasksCreationDate).timeIntervalSince1970

        // Create ToDoTask object
		let task = ToDoTask(
			id: editedTasksID,
			title: taskTitle,
			description: taskAdditionalNotes,
            creationDate: creationDate,
			deadlineDate: addDeadline ?
                taskDeadlineDate.timeIntervalSince1970 : nil,
			reminderDate: addReminder ? 
                taskReminderDate.timeIntervalSince1970 : nil,
			selectedPriority: selectedPriority,
			isHidden: isTaskHidden,
			isCompleted: false
		)

		if task.id == nil {
            // Save new task if id is 'nil'
			guard DataStore.shared.addTask(task) else {
				errorText = "Encountered problem during save. Please try again!"
				return
			}

			successText = "Task created."

            setNotification(creationDateAsID: creationDate)

			restoreDefaultValues()
		}
		else {
            // Update existing task if id isn't 'nil'
			guard DataStore.shared.updateTask(task.id!, task) else {
				errorText =
					"Encountered problem while accessing the database. Please try again!"
				return
			}

			successText = "Changes saved."

            // To avoid multiple notifications for the same task
            // cancel old notification
			NotificationManager.shared.cancelNotification(id: creationDate)

            setNotification(creationDateAsID: creationDate)
		}
	}
    
    /***********************************************************************/

    // MARK: func setNotification
    // If app has to permission to create push notificantion and
    // user opted to turn on reminder for this task send request
    // to NotificationManager to schedule it
    func setNotification(creationDateAsID: TimeInterval) {
		if NotificationManager.shared.notificationPermissionGranted && addReminder {
			NotificationManager.shared.scheduleNotification(
				id: creationDateAsID,
				title: taskTitle,
				description: taskAdditionalNotes,
				date: taskReminderDate
			)
		}
	}
    
    /***********************************************************************/

    // MARK: func checkInputs
    // Function that validates inputs
	func checkInputs() -> Bool {
        // Set default values for error/success notification
		errorText = nil
		successText = nil

        // Trim title from white spaces
		taskTitle = taskTitle.trimmingCharacters(in: .whitespaces)
        
        // Make sure title isn't empty
		guard !taskTitle.isEmpty else {
			errorText = "Title cannot be empty!"
			return false
		}

        // Trim additional notes
		taskAdditionalNotes = taskAdditionalNotes.trimmingCharacters(in: .whitespaces)

        // If user opted to add a deadline make sure it's in the future
		if addDeadline {
            // -86400 seconds = -24 hours
            // Added to avoid problems with timezones
			guard taskDeadlineDate >= Date().addingTimeInterval(-86400) else {
				errorText = "Deadline has to be set in the future!"
				return false
			}
		}

        // If user selected to add reminder make sure it's in the future
		if addReminder {
			guard taskReminderDate >= Date().addingTimeInterval(-86400) else {
				errorText = "Reminder has to be set in the future!"
				return false
			}
		}

		return true
	}

    // MARK: func restoreDefaultValues
	func restoreDefaultValues() {
		taskTitle = ""
		taskAdditionalNotes = ""
		addDeadline = false
		taskDeadlineDate = Date()
		addReminder = false
		taskReminderDate = Date()
		selectedPriority = "3 - normal"
		isTaskHidden = false
		errorText = nil
	}
    
    /***********************************************************************/
}
