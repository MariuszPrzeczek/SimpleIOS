//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import Foundation
import UIKit

class Main_ViewModel: ObservableObject {
    // ======================================================================
    // MARK: Variables
    // ======================================================================
    
    // Selected view from TabView
	@Published var tabViewSelect = 2
    
    // Skip introduction if it has been shown already
    @Published var skipIntro: Bool = UserDefaults.standard.bool(forKey: "skipIntro")
    
    // ======================================================================
    // MARK: Init
    // ======================================================================

	init() {
        // Check if userPassword variable was already created in
        // UserDefaults and create it if it's not found
		if let _ = UserDefaults.standard.string(forKey: "userPassword") {
			print("Password already exists in UserDefaults.")
		}
		else {
            UserDefaults.standard.set("", forKey: "userPassword")
			print("Default password created.")
		}

        // Check if sortBy variable,to which current sorting method is saved,
        // was already created in UserDefaults and create it if it's not found
		if let sortBy = UserDefaults.standard.string(forKey: "sortBy") {
			print("Sort method found in UserDefaults: \(sortBy)")
		}
		else {
            UserDefaults.standard.set("CREATION_DATE", forKey: "sortBy")
			print("Default sort method set.")
		}

	}
}
