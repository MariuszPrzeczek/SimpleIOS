//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import SwiftUI

struct TaskForm_View: View {

	@StateObject var viewModel = TaskForm_ViewModel()
	@StateObject var notificationPermManager = NotificationManager.shared

	let task: ToDoTask?

	var body: some View {

		VStack {
			formView

			Spacer()

			btnAndErrView
		}
		.onAppear(perform: { viewModel.fillFormIfNotNil(task) })
	}

    // MARK: Form View
	@ViewBuilder var formView: some View {
		ScrollView {
			VStack(alignment: .leading) {

                // MARK: task name
				STDLTextField(
					headerText: "Task name:",
					tooltipText: "(Required) Task name...",
					inputVar: $viewModel.taskTitle,
					lineLimit: nil
				)

				Divider().frame(height: 2).foregroundStyle(.gray)

                // MARK: notes
				STDLTextField(
					headerText: "Additional notes:",
					tooltipText: "(Optional) Write your notes here...",
					inputVar: $viewModel.taskAdditionalNotes,
					lineLimit: nil
				)

				Divider().frame(height: 2).foregroundStyle(.gray)

				deadlineAndReminderView

				Divider().frame(height: 2).foregroundStyle(.gray)

                // MARK: Priority picker
				STDLPickerMenu(
					txt: "Select priority:",
					selectedItem: $viewModel.selectedPriority,
					selectOptions: viewModel.priorityOptions
				)

				Divider().frame(height: 2).foregroundStyle(.gray)

                // MARK: Hide task
				// confirm if user wants to set task as hidden
				if UserDefaults.standard.string(forKey: "userPassword") == nil
					|| UserDefaults.standard.string(forKey: "userPassword")!
						.isEmpty
				{

					Text(
						"To be able to set tasks as hidden you need to "
							+ "create a user password first."
					)
					.foregroundStyle(Color.gray)
					.opacity( /*@START_MENU_TOKEN@*/0.8 /*@END_MENU_TOKEN@*/)
					.multilineTextAlignment(.center)

				}
				else {
					Toggle(isOn: $viewModel.isTaskHidden) { Text("Set as hidden") }
						.toggleStyle(STDLCheckboxStyle())
				}
			}
			.padding()
		}
		.padding(.bottom, -7)
	}

	@ViewBuilder var deadlineAndReminderView: some View {

        // MARK: Deadline
		// confirm if user wants to set a deadline
		Toggle(isOn: $viewModel.addDeadline) { Text("Set deadline") }
			.toggleStyle(STDLCheckboxStyle())

		if viewModel.addDeadline {
			// date picker for deadline
			DatePicker("", selection: $viewModel.taskDeadlineDate)
				.datePickerStyle(GraphicalDatePickerStyle())
		}

		Divider().frame(height: 2).foregroundStyle(.gray)

        // MARK: Reminder
		if !notificationPermManager.notificationPermissionGranted {

			Text(
				"To be able to send you reminder notifications we require \"Push notifications permissions\"."
			)
			.foregroundStyle(Color.gray)
			.opacity( /*@START_MENU_TOKEN@*/0.8 /*@END_MENU_TOKEN@*/)
			.multilineTextAlignment(.center)

			STDLButton(
				title: "Grant permissions",
				bgColor: DefaultSettings.shared.darkBlueColor,
				action: {
					if UserDefaults.standard.bool(
						forKey: "permissionsDaniedPreviously"
					) {
						if UIApplication.shared.canOpenURL(
							URL(
								string: UIApplication
									.openSettingsURLString
							)!
						) {
							UIApplication.shared.open(
								URL(
									string: UIApplication
										.openSettingsURLString
								)!,
								options: [:],
								completionHandler: nil
							)
						}
					}
					else {
						NotificationManager.shared.requestNotificationPermissions()
						UserDefaults.standard.set(
							true,
							forKey: "permissionsDaniedPreviously"
						)
					}
				}
			)

		}
		else {

			// confirm if user wants to set a reminder
			Toggle(isOn: $viewModel.addReminder) { Text("Set reminder") }
				.toggleStyle(STDLCheckboxStyle())

			if viewModel.addReminder {
				// date picker for reminder
				DatePicker("", selection: $viewModel.taskReminderDate)
					.datePickerStyle(GraphicalDatePickerStyle())
			}
		}
	}

    // MARK: Save task button and error/success display
	@ViewBuilder var btnAndErrView: some View {
		ZStack(alignment: .bottom) {
			Rectangle().frame(height: /*@START_MENU_TOKEN@*/ 100 /*@END_MENU_TOKEN@*/)
				.foregroundColor(Color(UIColor.systemBackground))
				.shadow(color: .gray, radius: 20, x: 0, y: -5).opacity(0.33)

			VStack {

				if viewModel.errorText != nil {
					Text(viewModel.errorText!).foregroundStyle(DefaultSettings.shared.darkRedColor)
						.multilineTextAlignment(.center).bold().padding(0)
						.offset(y: 20)
				}
				else if viewModel.successText != nil {
					Text(viewModel.successText!).foregroundStyle(DefaultSettings.shared.darkGreenColor)
						.multilineTextAlignment(.center).bold().padding(0)
						.offset(y: 20)
				}

				STDLButton(
					title: viewModel.buttonText,
                    bgColor: DefaultSettings.shared.darkGreenColor,
					action: viewModel.saveOrUpdateTaskButtonAction
				)
				.padding(.vertical)

			}
		}
		.padding(0)
	}
}
