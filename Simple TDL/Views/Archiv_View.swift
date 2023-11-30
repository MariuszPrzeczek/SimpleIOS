//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import SwiftUI

struct Archiv_View: View {
	@StateObject var viewModel = Archiv_ViewModel()

	var body: some View {
		NavigationView {
			VStack {

				// MARK: Header
				STDLHeader(heatderText: "Archiv")

				if viewModel.tasks.isEmpty {

					// MARK: Empty List
					Text("There are no tasks to show.").foregroundStyle(
						Color.gray
					).opacity(0.8)

				} else {

					// MARK: Displayed List
					List(viewModel.tasks) { task in
						SingleTaskListItem_View(task: task).padding(.vertical, 1)
							.listRowInsets(EdgeInsets()).sheet(
								isPresented: $viewModel
									.detailsSheetShowing,
								onDismiss: {
									viewModel.getCompletedTasks()
								},
								content: {
									TaskDetails_View(
										taskId: task.id!)
								}
							).onTapGesture {
								viewModel.detailsSheetShowing = true
							}.swipeActions(
								edge: .trailing,
								allowsFullSwipe: true
							) {
								Button("Delete") {
									if viewModel.deleteTask(
										id: task.id!)
									{
										viewModel
											.getCompletedTasks()
									}
								}.tint(
									DefaultSettings.shared
										.darkRedColor)
							}
					}.padding(.vertical, -10).listStyle(.plain)

				}

				Spacer()
			}.onAppear(perform: { viewModel.getCompletedTasks() })
		}
	}
}
