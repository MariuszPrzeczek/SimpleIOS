//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import Foundation
import SQLite3

class DataStore {
	// ======================================================================
	// MARK: Variables
	// ======================================================================

	// Singleton instance
	static let shared = DataStore()

	// Constants
	private let STORE_NAME = "STDL.db"
	private let TABLE_NAME = "TASKS"

	// Opaque Pointer for the database
	private var databaseOpaquePointer: OpaquePointer?
    
    // ======================================================================
    // MARK: Init
    // ======================================================================

	init() {
        // Get Database path in default directory
		let dbURL = try! FileManager.default.url(
			for: .documentDirectory, in: .userDomainMask, appropriateFor: nil,
			create: false
		).appending(path: STORE_NAME, directoryHint: .inferFromPath)

        // Print path
		print(dbURL)

        // Open connection to the database
		if sqlite3_open(dbURL.path(), &databaseOpaquePointer) == SQLITE_OK {
			print("Success: SQLite connection with \"\(STORE_NAME)\" established")
            
            // Call function creating the table if it doesn't exists yet
			createTable()
		} else {
			print("Failure: couldn't establish connection with \"\(STORE_NAME)\"")
		}
	}
    
    // ======================================================================
    // MARK: Functions
    // ======================================================================
    
    // MARK: func deleteTask
    // Delete entry in the table based on ID
    // Return confirmation whether or not operation was successful
	func deleteTask(id: Int64) -> Bool {
		let sqlQuery = "DELETE FROM \(TABLE_NAME) WHERE ID = ?;"

		var statement: OpaquePointer?

		if sqlite3_prepare_v2(databaseOpaquePointer, sqlQuery, -1, &statement, nil)
			== SQLITE_OK
		{
			sqlite3_bind_int64(statement, 1, id)

			if sqlite3_step(statement) == SQLITE_DONE {
				sqlite3_finalize(statement)

				return true
			}
		}

		sqlite3_finalize(statement)

		return false
	}
    
    /***********************************************************************/

    // MARK: func updateTask
    // Updates entry in the table based on ID
    // Return confirmation whether or not operation was successful
	func updateTask(_ id: Int64, _ task: ToDoTask) -> Bool {
		let sqlQuery =
			"UPDATE \(TABLE_NAME) SET "
			+ "TITLE = ?, DESCRIPTION = ?, CREATION_DATE = ?, "
			+ "DEADLINE_DATE = ?, REMINDER_DATE = ?, PRIORITY = ?, "
			+ "IS_HIDDEN = ? WHERE ID = \(id);"

		var statement: OpaquePointer?

		if sqlite3_prepare_v2(databaseOpaquePointer, sqlQuery, -1, &statement, nil)
			== SQLITE_OK
		{
			let SQLITE_TRANSIENT = unsafeBitCast(
				OpaquePointer(bitPattern: -1), to: sqlite3_destructor_type.self)

			sqlite3_bind_text(statement, 1, task.title, -1, SQLITE_TRANSIENT)
			sqlite3_bind_text(statement, 2, task.description, -1, SQLITE_TRANSIENT)
			sqlite3_bind_double(statement, 3, task.creationDate)

			if let dateTime = task.deadlineDate {
				sqlite3_bind_double(statement, 4, dateTime)
			} else {
				sqlite3_bind_null(statement, 4)
			}

			if let dateTime = task.reminderDate {
				sqlite3_bind_double(statement, 5, dateTime)
			} else {
				sqlite3_bind_null(statement, 5)
			}

			sqlite3_bind_text(statement, 6, task.selectedPriority, -1, SQLITE_TRANSIENT)
			sqlite3_bind_int(statement, 7, task.isHidden ? 1 : 0)

			let returnValue = sqlite3_step(statement) == SQLITE_DONE

			sqlite3_finalize(statement)

			return returnValue
		}

		sqlite3_finalize(statement)

		return false
	}
    
    /***********************************************************************/

    // MARK: func completeTask
    // Updates task's complition status on ID
    // Return confirmation whether or not operation was successful
	func completeTask(id: Int64) -> Bool {
		let sqlQuery = "UPDATE \(TABLE_NAME) SET IS_COMPLETED = 1 WHERE ID = \(id);"

		var statement: OpaquePointer?

		if sqlite3_prepare_v2(databaseOpaquePointer, sqlQuery, -1, &statement, nil)
			== SQLITE_OK
		{
			if sqlite3_step(statement) == SQLITE_DONE {
				sqlite3_finalize(statement)

				return true
			}
		}

		sqlite3_finalize(statement)

		return false
	}
    
    /***********************************************************************/

    // MARK: func getTasks
    // Get all tasks matching completion requirement
    // Returns array of ToDoTask items
	func getTasks(isCompleted: Bool) -> [ToDoTask] {
		let showHidden = DefaultSettings.shared.showHiddenTasks
		var sortBy = ""

		if let sortMethod = UserDefaults.standard.string(forKey: "sortBy") {
			sortBy = " ORDER BY \(sortMethod) ASC"
		}

		let completed = isCompleted ? 1 : 0

		let sqlQuery =
			"SELECT * FROM \(TABLE_NAME) WHERE \(showHidden ? "": "IS_HIDDEN = 0 AND ")"
			+ "IS_COMPLETED = \(completed)\(sortBy);"

		var statement: OpaquePointer?

		if sqlite3_prepare_v2(databaseOpaquePointer, sqlQuery, -1, &statement, nil)
			== SQLITE_OK
		{
			var tasks: [ToDoTask] = []
			while sqlite3_step(statement) == SQLITE_ROW {
				tasks.append(
					ToDoTask(
						id: sqlite3_column_int64(statement, 0),
						title: String(
							cString: sqlite3_column_text(statement, 1)),
						description: String(
							cString: sqlite3_column_text(statement, 2)),
						creationDate: sqlite3_column_double(statement, 3),
						deadlineDate: sqlite3_column_double(statement, 4),
						reminderDate: sqlite3_column_double(statement, 5),
						selectedPriority: String(
							cString: sqlite3_column_text(statement, 6)),
						isHidden: sqlite3_column_int(statement, 7) == 1
							? true : false,
						isCompleted: sqlite3_column_int(statement, 8) == 1
							? true : false))
			}

			sqlite3_finalize(statement)

			return tasks
		}

		sqlite3_finalize(statement)

		return []
	}
    
    /***********************************************************************/

    // MARK: func getTaskByID
    // Get single task based on ID
    // Returns ToDoTask item or 'nil'
	func getTaskByID(id: Int64) -> ToDoTask? {
		let sqlQuery = "SELECT * FROM \(TABLE_NAME) WHERE ID = \(id);"

		var statement: OpaquePointer?

		if sqlite3_prepare_v2(databaseOpaquePointer, sqlQuery, -1, &statement, nil)
			== SQLITE_OK
		{
			sqlite3_step(statement)

			let task = ToDoTask(
				id: sqlite3_column_int64(statement, 0),
				title: String(cString: sqlite3_column_text(statement, 1)),
				description: String(cString: sqlite3_column_text(statement, 2)),
				creationDate: sqlite3_column_double(statement, 3),
				deadlineDate: sqlite3_column_double(statement, 4),
				reminderDate: sqlite3_column_double(statement, 5),
				selectedPriority: String(
					cString: sqlite3_column_text(statement, 6)),
				isHidden: sqlite3_column_int(statement, 7) == 1 ? true : false,
				isCompleted: sqlite3_column_int(statement, 8) == 1 ? true : false)

			sqlite3_finalize(statement)

			return task
		}

		sqlite3_finalize(statement)

		return nil

	}
    
    /***********************************************************************/

    // MARK: func addTask
    // Saves new task into the table
    // Return confirmation whether or not operation was successful
	func addTask(_ task: ToDoTask) -> Bool {
		let sqlQuery =
			"INSERT INTO \(TABLE_NAME) ("
			+ "TITLE, DESCRIPTION, CREATION_DATE, DEADLINE_DATE, "
			+ "REMINDER_DATE, PRIORITY, IS_HIDDEN, IS_COMPLETED"
			+ ") VALUES (?, ?, ?, ?, ?, ?, ?, ?)"

		var statement: OpaquePointer?

		if sqlite3_prepare_v2(databaseOpaquePointer, sqlQuery, -1, &statement, nil)
			== SQLITE_OK
		{
			let SQLITE_TRANSIENT = unsafeBitCast(
				OpaquePointer(bitPattern: -1), to: sqlite3_destructor_type.self)

			sqlite3_bind_text(statement, 1, task.title, -1, SQLITE_TRANSIENT)
			sqlite3_bind_text(statement, 2, task.description, -1, SQLITE_TRANSIENT)
			sqlite3_bind_double(statement, 3, task.creationDate)

			if let dateTime = task.deadlineDate {
				sqlite3_bind_double(statement, 4, dateTime)
			} else {
				sqlite3_bind_null(statement, 4)
			}

			if let dateTime = task.reminderDate {
				sqlite3_bind_double(statement, 5, dateTime)
			} else {
				sqlite3_bind_null(statement, 5)
			}

			sqlite3_bind_text(statement, 6, task.selectedPriority, -1, SQLITE_TRANSIENT)
			sqlite3_bind_int(statement, 7, task.isHidden ? 1 : 0)
			sqlite3_bind_int(statement, 8, task.isCompleted ? 1 : 0)

			let returnValue = sqlite3_step(statement) == SQLITE_DONE

			sqlite3_finalize(statement)

			return returnValue
		}

		sqlite3_finalize(statement)

		return false
	}
    
    /***********************************************************************/

    // MARK: func execSQL
    // Executes SQL Query
    // Return confirmation whether or not operation was successful
    // WARNING: Unsafe solution, susceptible to sql injection,
    // use only in fully controlled cases
	func execSql(_ sql: String) -> Bool {
		let execResult = sqlite3_exec(databaseOpaquePointer, sql, nil, nil, nil)

		if execResult == SQLITE_OK {
			print("Success: \"\(sql)\" executed")
			return true
		} else {
			print("Failure: couldn't execute \"\(sql)\"")
			return false
		}
	}
    
    /***********************************************************************/

    // MARK: func createTable
    // Creates table and columns
	private func createTable() {
		let sql =
			"CREATE TABLE IF NOT EXISTS \(TABLE_NAME) ("
			+ "ID INTEGER PRIMARY KEY AUTOINCREMENT, " + "TITLE TEXT NOT NULL, "
			+ "DESCRIPTION TEXT NOT NULL, " + "CREATION_DATE DATETIME NOT NULL, "
			+ "DEADLINE_DATE DATETIME, " + "REMINDER_DATE DATETIME, "
			+ "PRIORITY TEXT NOT NULL, " + "IS_HIDDEN BOOLEAN NOT NULL, "
			+ "IS_COMPLETED BOOLEAN NOT NULL" + ")"

		_ = execSql(sql)
	}
    
    /***********************************************************************/

}
