//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import Foundation
import SwiftUI

class DefaultSettings {
    // ======================================================================
    // MARK: Variables
    // ======================================================================
    
    // Singleton pattern
    static let shared = DefaultSettings()
    
    // Variable responsible for showing or hiding hidden tasks
    // in the entire App
    var showHiddenTasks: Bool = false
    
    let appMainColor: Color = Color(UIColor(named: "AppColor")!)
    let darkGreenColor: Color = Color(UIColor(named: "DarkGreen")!)
    let darkBlueColor: Color = Color(UIColor(named: "DarkBlue")!)
    let darkRedColor: Color = Color(UIColor(named: "DarkRed")!)
    let darkPinkColor: Color = Color(UIColor(named: "DarkPink")!)
    let darkOrangeColor: Color = Color(UIColor(named: "DarkOrange")!)
    let darkYellowColor: Color = Color(UIColor(named: "DarkYellow")!)
    
    
    // ======================================================================
    // MARK: Init
    // ======================================================================
    
    init() {}
    
    // ======================================================================
    // MARK: Functions
    // ======================================================================
    
    // MARK: toggleHiddenStatus
    // Function that swaps the value of showHiddenTasks
    func toggleHiddenStatus() {
        showHiddenTasks = showHiddenTasks ? false : true
    }
}
