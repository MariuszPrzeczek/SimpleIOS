//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import Foundation

// ======================================================================
// MARK: Password releated functions
// ======================================================================

// MARK: func checkIfUserPassExists
// Function that checks if there's a password saved in UserDefaults
func checkIfUserPassExists() -> Bool {
	if UserDefaults.standard.string(forKey: "userPassword") != nil
		&& !UserDefaults.standard.string(forKey: "userPassword")!.isEmpty
	{
		return true
	} else {
		return false
	}
}

/***********************************************************************/

// MARK: func validatePassword
// Function that validates new password
// 1. Make sure password doesn't contain 'space' character
// 2. Make sure password is 6 to 32 characters long
// 3. Check if passwords in both input fields match
// Return error description by failure or 'nil' by successful validation
func validatePassword(password1: String, password2: String) -> String? {
	guard !password1.contains(" ") else {
		return "Password cannot contain the space character."
	}

	guard password1.count >= 6 && password1.count <= 32 else {
		return "Password has to be between 6 and 32 characters long."
	}

	guard password1 == password2 else { return "Passwords don't match." }

	return nil
}

/***********************************************************************/

// MARK: func setPassword
// Save password to UserDefaults
func setPassword(password: String) {
    UserDefaults.standard.set(password, forKey: "userPassword")
}

/***********************************************************************/

// MARK: func checkPassword
// Check if password inputed by the user
// matches the one saved in UserDefaults
func checkPassword(password: String) -> Bool {
	return password == UserDefaults.standard.string(forKey: "userPassword")!
}

/***********************************************************************/

// ======================================================================
// ======================================================================
// ======================================================================
