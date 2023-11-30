//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import Foundation

class Introduction_ViewModel: ObservableObject {
    // ======================================================================
    // MARK: Variables
    // ======================================================================
    
    // Password exists?
    @Published var userPassExists: Bool = false
    
    // Password field variables
    @Published var newPassField1: String = ""
    @Published var newPassField2: String = ""
    
    // Error text
    @Published var errTxt: String = " "
    
    // ======================================================================
    // MARK: Init
    // ======================================================================
    
    init () {
        // Check if valid password already exists in UserDefaults
        userPassExists = checkIfUserPassExists()
    }
    
    // ======================================================================
    // MARK: Functions
    // ======================================================================
    
    // MARK: savePasswordButtonAction
    // "Save Password" button action
    func savePasswordButtonAction() {
        // Reset Error and Success values to default
        errTxt = " "
        
        // Validate password and stoped the function from progressing
        // if the 'validatePassword' function returns anything but 'nil'
        if let passErrTxt = validatePassword(password1: newPassField1, password2: newPassField2) {
            errTxt = passErrTxt
            return
        }
        
        // Save password in UserDefaults
        setPassword(password: newPassField1)
        
        // Update Published variables
        userPassExists = checkIfUserPassExists()
    }
    
    /***********************************************************************/
    
}
