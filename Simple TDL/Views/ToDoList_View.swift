//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import SwiftUI

struct ToDoList_View: View {
	@StateObject var viewModel = ToDoList_ViewModel()

	var body: some View {
		NavigationView {
			VStack {
                // Header
				STDLHeader(heatderText: "To Do List")

				if viewModel.tasks.isEmpty {

                    // Empty list
					Text("There are no tasks to show.")
						.foregroundStyle(Color.gray)
						.opacity(0.8)

				}
				else {

                    // Show list
					List(viewModel.tasks) { task in
						SingleTaskListItem_View(
							task: task)
						.padding(.vertical, 1).listRowInsets(EdgeInsets())
                        .sheet(
                            isPresented: $viewModel.detailsSheetShowing,
                            onDismiss: { viewModel.getNotCompeltedTasks() },
                            content: {
                                TaskDetails_View(taskId: task.id!)
                            }
                        )
                        .onTapGesture { viewModel.detailsSheetShowing = true }
						.swipeActions(edge: .leading, allowsFullSwipe: true)
						{
							Button("Complete") {
								if viewModel.completeTask(
									id: task.id!
								) {
									viewModel.getNotCompeltedTasks()
								}
							}
							.tint(DefaultSettings.shared.darkGreenColor)
						}
						.swipeActions(
							edge: .trailing,
							allowsFullSwipe: true
						) {
							Button("Delete") {
								if viewModel.deleteTask(
									id: task.id!
								) {
									viewModel.getNotCompeltedTasks()
								}
							}
							.tint(DefaultSettings.shared.darkRedColor)
						}
					}
					.padding(.vertical, -10).listStyle(.plain)

				}

				Spacer()
			}
			.onAppear(perform: { viewModel.getNotCompeltedTasks() })
		}
	}
}
