//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import Foundation
import SwiftUI

class Settings_ViewModel: ObservableObject {
	// ======================================================================
	// MARK: Variables
	// ======================================================================

	// Sort method selection
	@Published var selectedSort: String = "creation date"
	@Published var sortOptions: [String] = ["creation date", "deadline", "priority"]

	// Password exists in UserDefaults and it's not empty
	@Published var userPassExists: Bool = false

	// Variables for Password SecureFields
	@Published var oldPassword: String = ""
	@Published var newPassword: String = ""
	@Published var confirmPassword: String = ""

	// Password error/success notification
	@Published var passErrTxt: String? = nil
	@Published var passSuccessText: String? = nil

	// Modifying text based on showHiddenTasks value
	@Published var hiddenTasksTxt: String =
		DefaultSettings.shared.showHiddenTasks ? "Hide" : "Show"

	// Show/Hide tasks password field variable
	@Published var hiddenTasksPass: String = ""

	// Show/Hide tasks error/success notification
	@Published var hiddenTasksErrTxt: String? = nil
	@Published var hiddenTasksSuccessTxt: String? = nil

	// ======================================================================
	// MARK: Init
	// ======================================================================

	init() {
		// Getting some initial values from UserDefaults
		userPassExists = checkIfUserPassExists()
		selectedSort = getSortMethod()
	}

	// ======================================================================
	// MARK: Functions
	// ======================================================================

	// MARK: func getSortMethod
	// Get sorting method from UserDefaults
	func getSortMethod() -> String {
		guard let sortBy = UserDefaults.standard.string(forKey: "sortBy") else {
			return "creation date"
		}

		switch sortBy {
		case "CREATION_DATE": 
            return "creation date"
		case "DEADLINE_DATE": 
            return "deadline"
		case "PRIORITY": 
            return "priority"
		default: 
            return "creation date"
		}
	}

	/***********************************************************************/

	// MARK: func updateSortMethod
	// Update sorting method in UserDefaults
	func updateSortMethod() {
		switch selectedSort {
		case "creation date":
			UserDefaults.standard.set("CREATION_DATE", forKey: "sortBy")
			break
		case "deadline":
			UserDefaults.standard.set("DEADLINE_DATE", forKey: "sortBy")
			break
		case "priority":
			UserDefaults.standard.set("PRIORITY", forKey: "sortBy")
			break
		default: 
            UserDefaults.standard.set("CREATION_DATE", forKey: "sortBy")
		}
	}

	/***********************************************************************/

	// MARK: func changeStatusBtnAction
	// "Show/Hide Tasks" button action
	func changeStatusBtnAction() {
		// Reset Error and Success values to default
		hiddenTasksErrTxt = nil
		hiddenTasksSuccessTxt = nil

		// Make sure password inputed by the user is correct
		guard checkPassword(password: hiddenTasksPass) else {
			hiddenTasksErrTxt = "Incorrect password."
			return
		}

		// Swap state of the variable responsible for showing
		// hidden tasks
		DefaultSettings.shared.toggleHiddenStatus()

		// Inform user about the success
		hiddenTasksSuccessTxt =
			"Hidden tasks are now "
			+ "\(DefaultSettings.shared.showHiddenTasks ? "shown" : "hidden")."

		// Update Published variables
		hiddenTasksTxt = DefaultSettings.shared.showHiddenTasks ? "Hide" : "Show"
		hiddenTasksPass = ""
	}

	/***********************************************************************/

	// MARK: func passBtnAction
	// "Save Password" button action
	func passBtnAction() {
		// Reset Error and Success values to default
		passErrTxt = nil
		passSuccessText = nil

		// First make sure password already exists in UserDefaults
		// and if it does check if password inputed by the user
		// is correct
		if userPassExists {
			guard checkPassword(password: oldPassword) else {
				passErrTxt = "Incorrect password."
				return
			}
		}

		// Validate password and stoped the function from progressing
		// if the 'validatePassword' function returns anything but 'nil'
		passErrTxt = validatePassword(password1: newPassword, password2: confirmPassword)
		if passErrTxt != nil { return }

		// Save password in UserDefaults
		setPassword(password: newPassword)

		// Inform user that the change was successful
		passSuccessText = "Password \(userPassExists ? "changed" : "set")."

		// Update Published variables
		userPassExists = checkIfUserPassExists()
		oldPassword = ""
		newPassword = ""
		confirmPassword = ""
	}

	/***********************************************************************/
}
