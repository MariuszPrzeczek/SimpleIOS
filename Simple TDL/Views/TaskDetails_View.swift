//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import SwiftUI

struct TaskDetails_View: View {
	@StateObject var viewModel = TaskDetails_ViewModel()
	@State var showingEditView = false
	@State var showingConfirmDelete = false

	@Environment(\.dismiss) var dismiss

	let taskId: Int64

	var body: some View {
		VStack {

			// MARK: Header
			STDLHeader(heatderText: "Task details").padding(.top, 10)

			// MARK: List of values
			ScrollView {
				STDLDetailedItem(category: "Id:", value: String(viewModel.id))

				STDLDetailedItem(category: "Task:", value: viewModel.title)

				STDLDetailedItem(category: "Notes:", value: viewModel.description)

				STDLDetailedItem(
					category: "Created:", value: viewModel.creationDate)

				STDLDetailedItem(
					category: "Deadline:", value: viewModel.deadlineDate)

				STDLDetailedItem(
					category: "Reminder:", value: viewModel.reminderDate)

				STDLDetailedItem(
					category: "Priority:", value: viewModel.selectedPriority)

				STDLDetailedItem(category: "Hidden:", value: viewModel.isHidden)

				STDLDetailedItem(
					category: "Completed:", value: viewModel.isCompleted)
			}

			Spacer()

			// MARK: Delete button
			STDLButton(
				title: "Delete permanently",
				bgColor: DefaultSettings.shared.darkRedColor,
				action: { showingConfirmDelete = true }
			).frame(width: UIScreen.main.bounds.size.width).confirmationDialog(
				"Do you want to delete this task?",
				isPresented: $showingConfirmDelete
			) {
				Button("Delete", role: .destructive) {
					if viewModel.deleteTask() { dismiss() }
				}
			} message: {
				Text("This action cannot be undone")
			}

			if viewModel.showEditAndCompleteButtons {

				// MARK: Mark as complete button
				STDLButton(
					title: "Mark as completed",
					bgColor: DefaultSettings.shared.darkGreenColor,
					action: { if viewModel.completeTask() { dismiss() } }
				).frame(width: UIScreen.main.bounds.size.width)

				// MARK: Edit button
				STDLButton(
					title: "Edit", bgColor: DefaultSettings.shared.appMainColor,
					action: { showingEditView = true }
				).frame(width: UIScreen.main.bounds.size.width)

			}

			// MARK: Close button
			STDLButton(title: "Close", bgColor: .gray, action: { dismiss() }).frame(
				width: UIScreen.main.bounds.size.width)

		}.onAppear(perform: { viewModel.getAndFillData(taskId: taskId) }).sheet(
			isPresented: $showingEditView,
			onDismiss: {
				showingEditView = false
				viewModel.getAndFillData(taskId: taskId)
			}, content: { EditTask_View(task: viewModel.task!) })
	}
}
