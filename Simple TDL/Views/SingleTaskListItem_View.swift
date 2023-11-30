//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import SwiftUI

struct SingleTaskListItem_View: View {
	@StateObject var viewModel = TaskItem_ViewModel()
	let task: ToDoTask

	var body: some View {

		ZStack {

            // Background rectangle with
            // priority based stroke
			Rectangle().stroke(
				viewModel.returnPriorityColor(
					task.selectedPriority, task.isCompleted), lineWidth: 3
			).frame(height: 80).padding(.trailing, 1).foregroundStyle(
				Color(UIColor.systemBackground)
			).opacity(1)

			HStack {
                // Rectangle on the left
                // Shows priority based color
				Rectangle().frame(width: 20).foregroundStyle(
					viewModel.returnPriorityColor(
						task.selectedPriority, task.isCompleted))

                // Text info
				VStack(alignment: .leading) {
                    // Task title
					Text(viewModel.returnFormattedTitle(task.title)).font(
						.system(size: 20, weight: .bold))

                    // Deadline for the task
					Text(viewModel.returnFormattedDeadline(task.deadlineDate))
						.opacity(0.5).font(.system(size: 13))
				}

				Spacer()

                // Icons on the right
				VStack {
					if task.isCompleted == true {
                        
                        // Show checkmark if compelted
						Image(systemName: "checkmark.circle.fill").font(
							.system(size: 20)
						).padding(1).foregroundStyle(
							DefaultSettings.shared.darkGreenColor
						).bold()
					} else if task.reminderDate != nil
						&& task.reminderDate != 0.0
					{
                        // Show bell if reminder is set
						Image(systemName: "bell").font(.system(size: 20))
							.padding(1)
					}

					if task.isHidden {
                        // Show shalshed eye if the task is hidden
						Image(systemName: "eye.slash").font(
							.system(size: 20)
						).padding(1)
					}
				}.padding()
			}.frame(height: 80).background(.clear).padding(0)

		}
	}
}

#Preview {
	SingleTaskListItem_View(
		task: .init(
			id: nil, title: "Very long test entry", description: "",
			creationDate: Date().timeIntervalSince1970,
			deadlineDate: Date().timeIntervalSince1970 + 61,
			reminderDate: Date().timeIntervalSince1970, selectedPriority: "3 - normal",
			isHidden: true, isCompleted: false))
}
