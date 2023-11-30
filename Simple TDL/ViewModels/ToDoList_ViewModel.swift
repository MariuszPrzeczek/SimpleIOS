//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import Foundation
import SwiftUI

class ToDoList_ViewModel: ObservableObject {
    // ======================================================================
    // MARK: Variables
    // ======================================================================
    
    // Array with tasks to show
	@Published var tasks: [ToDoTask] = []
    
    // State of SheetView with detailed info for a selected task
    @Published var detailsSheetShowing = false
    
    // ======================================================================
    // MARK: Init
    // ======================================================================

	init() {}
    
    // ======================================================================
    // MARK: Functions
    // ======================================================================

    // MARK: func completeTask
    // Request DataStore to task as completed
    func completeTask(id: Int64) -> Bool {
        return DataStore.shared.completeTask(id: id)
    }
    
    /***********************************************************************/
    
    // MARK: func deleteTask
    // Request DataStore to delete task based on ID
    func deleteTask(id: Int64) -> Bool {
        return DataStore.shared.deleteTask(id: id)
    }
    
    /***********************************************************************/

    // MARK: func getNotCompeltedTasks
    // Request net completed tasks from the DataStore
    func getNotCompeltedTasks() {
        tasks = DataStore.shared.getTasks(isCompleted: false)
    }
    
    /***********************************************************************/
    
}
