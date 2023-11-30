//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import SwiftUI

struct Settings_View: View {
	@StateObject var viewModel = Settings_ViewModel()
	@StateObject var notificationPermManager = NotificationManager.shared

	var body: some View {
		NavigationView {
			VStack {

                // Header
				STDLHeader(heatderText: "Settings")

				ScrollView {
                    // MARK: Password change
					Text("Password:").font(.title).bold().padding(.top, 20)

					if viewModel.userPassExists {

						STDLSecuredField(
							headerText: "Old password:",
							tooltipText: "Enter old password here",
							inputVar: $viewModel.oldPassword)

						Divider().frame(height: 2).foregroundStyle(.gray)

					}

					STDLSecuredField(
						headerText: "New password:",
						tooltipText: "Enter new password here",
						inputVar: $viewModel.newPassword)

					Divider().frame(height: 2).foregroundStyle(.gray)

					STDLSecuredField(
						headerText: "Confirm password:",
						tooltipText: "Confirm new password here",
						inputVar: $viewModel.confirmPassword)

					Divider().frame(height: 2).foregroundStyle(.gray)

                    // Error/Success notification
					if viewModel.passErrTxt != nil {
						Text(viewModel.passErrTxt!).foregroundStyle(
							DefaultSettings.shared.darkRedColor
						).multilineTextAlignment(.center).bold().padding(0)
					} else if viewModel.passSuccessText != nil {
						Text(viewModel.passSuccessText!).foregroundStyle(
							DefaultSettings.shared.darkGreenColor
						).multilineTextAlignment(.center).bold().padding(0)
					}

					STDLButton(
						title: "Save password",
						bgColor: DefaultSettings.shared.darkBlueColor,
						action: { viewModel.passBtnAction() })

					Text(
						"Password has to be 6-32 characters long "
							+ "and cannot contain spaces."
					).foregroundStyle(.gray).font(.system(size: 12))
						.multilineTextAlignment(.center).opacity(0.5)

					Spacer()

					Text("Other:").font(.title).bold().padding(.top, 20)

                    // MARK: Soring method selector
					STDLPickerMenu(
						txt: "Sort tasks by:",
						selectedItem: $viewModel.selectedSort,
						selectOptions: viewModel.sortOptions)

					Divider().frame(height: 2).foregroundStyle(.gray)

                    // MARK: Push notification permissions
					if !notificationPermManager.notificationPermissionGranted {

						Text(
							"To be able to send you reminder notifications we require \"Push notifications permissions\"."
						).foregroundStyle(Color.gray).opacity(0.8)
							.multilineTextAlignment(.center)

						STDLButton(
							title: "Grant permissions",
							bgColor: DefaultSettings.shared
								.darkBlueColor,
							action: {
								if UserDefaults.standard.bool(
									forKey:
										"permissionsAskedPreviously"
								) {
									if UIApplication.shared
										.canOpenURL(
											URL(
												string:
													UIApplication
													.openSettingsURLString
											)!)
									{
										UIApplication.shared
											.open(
												URL(
													string:
														UIApplication
														.openSettingsURLString
												)!,
												options: [:],
												completionHandler:
													nil
											)
									}
								} else {
									NotificationManager.shared
										.requestNotificationPermissions()
									UserDefaults.standard.set(
										true,
										forKey:
											"permissionsAskedPreviously"
									)
								}
							})

						Divider().frame(height: 2).foregroundStyle(.gray)

					}

					if viewModel.userPassExists {

                        // MARK: Show/Hide hidden tasks
						STDLSecuredField(
							headerText:
								"To \(viewModel.hiddenTasksTxt.lowercased()) hidden tasks enter the password:",
							tooltipText: "Enter password...",
							inputVar: $viewModel.hiddenTasksPass)

						if viewModel.hiddenTasksErrTxt != nil {
							Text(viewModel.hiddenTasksErrTxt!)
								.foregroundStyle(
									DefaultSettings.shared
										.darkRedColor
								).multilineTextAlignment(.center)
								.bold().padding(0)
						} else if viewModel.hiddenTasksSuccessTxt != nil {
							Text(viewModel.hiddenTasksSuccessTxt!)
								.foregroundStyle(
									DefaultSettings.shared
										.darkGreenColor
								).multilineTextAlignment(.center)
								.bold().padding(0)
						}

						STDLButton(
							title: "\(viewModel.hiddenTasksTxt) tasks",
							bgColor: DefaultSettings.shared
								.darkBlueColor,
							action: {
								viewModel.changeStatusBtnAction()
							})
					} else {

						Text(
							"To use \"Hidden Tasks\" function you need to "
								+ "create a user password first."
						).foregroundStyle(Color.gray).opacity(0.8)
							.multilineTextAlignment(.center)

					}

				}.padding(.horizontal).onChange(
					of: viewModel.selectedSort, { viewModel.updateSortMethod() }
				)

				Spacer()
			}
		}
	}
}
