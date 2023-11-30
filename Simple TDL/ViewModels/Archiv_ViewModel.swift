//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import Foundation
import SwiftUI

class Archiv_ViewModel: ObservableObject {
    // ======================================================================
    // MARK: Variables
    // ======================================================================
    
    // Array for all displayed in ArchivView ToDoTasks
	@Published var tasks: [ToDoTask] = []
    
    // Was one of the items tapped and is a SheetView with it's
    // details showing?
    @Published var detailsSheetShowing = false
    
    // ======================================================================
    // MARK: Init
    // ======================================================================

	init() {}
    
    // ======================================================================
    // MARK: Functions
    // ======================================================================

    // MARK: func deleteTask
    // Request DataStore to delete task based on ID
    func deleteTask(id: Int64) -> Bool {
        return DataStore.shared.deleteTask(id: id)
    }
    
    /***********************************************************************/

    // MARK: func getCompletedTasks
    // Request completed tasks from the DataStore
    func getCompletedTasks() {
        tasks = DataStore.shared.getTasks(isCompleted: true)
    }
    
    /***********************************************************************/
}
