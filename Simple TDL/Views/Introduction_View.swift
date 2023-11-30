//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import SwiftUI

struct Introduction_View: View {
	@StateObject var notificationPermManager = NotificationManager.shared
	@StateObject var viewModel = Introduction_ViewModel()
	@Binding var skipIntro: Bool

	var body: some View {
		ZStack {
			DefaultSettings.shared.appMainColor.ignoresSafeArea()

			// MARK: Introduction TabView
			TabView {

				page1_TapView.tabItem {}

				page2_SwipeLeftView.tabItem {}

				page3_SwipeRightView.tabItem {}

				page4_ReminderView.tabItem {}

				page5_PasswordView.tabItem {}

				page6_SummaryView.tabItem {}

			}.tabViewStyle(.page(indexDisplayMode: .always))
		}
	}

	// MARK: Introduction page 1: Tap to edit
	@ViewBuilder var page1_TapView: some View {
		VStack {
			Text("Quick introduction").font(.largeTitle.weight(.heavy)).foregroundStyle(
				Color.white
			).padding(.top, 60)

			Spacer()

			Image(uiImage: UIImage(named: "tap")!).resizable().frame(
				maxWidth: 300, maxHeight: 300)

			Spacer()

			Text("Tap on the task to see it's details or edit it.").font(
				.headline.weight(.heavy)
			).foregroundStyle(Color.white)

			Spacer()
		}
	}

	// MARK: Introduction page 2: Swipe left to delete
	@ViewBuilder var page2_SwipeLeftView: some View {
		VStack {
			Text("Quick introduction").font(.largeTitle.weight(.heavy)).foregroundStyle(
				Color.white
			).padding(.top, 60)

			Spacer()

			Image(uiImage: UIImage(named: "swipe_left")!).resizable().frame(
				maxWidth: 300, maxHeight: 300)

			Spacer()

			Text("Swipe left on task to delete it.").font(.headline.weight(.heavy))
				.foregroundStyle(Color.white)

			Spacer()
		}
	}

	// MARK: Introduction page 3: Swipe right to complete
	@ViewBuilder var page3_SwipeRightView: some View {
		VStack {
			Text("Quick introduction").font(.largeTitle.weight(.heavy)).foregroundStyle(
				Color.white
			).padding(.top, 60)

			Spacer()

			Image(uiImage: UIImage(named: "swipe_right")!).resizable().frame(
				maxWidth: 300, maxHeight: 300)

			Spacer()

			Text("Swipe right on task to mark it as completed.").font(
				.headline.weight(.heavy)
			).foregroundStyle(Color.white)

			Spacer()
		}
	}

	// MARK: Introduction page 4: Reminders
	@ViewBuilder var page4_ReminderView: some View {
		VStack {
			Text("Quick introduction").font(.largeTitle.weight(.heavy)).foregroundStyle(
				Color.white
			).padding(.top, 60)

			Spacer()

			Image(systemName: "bell").resizable().frame(maxWidth: 150, maxHeight: 150)
				.foregroundStyle(.white)

			Spacer()

			Text("You can set reminders for your tasks.").font(.headline.weight(.heavy))
				.foregroundStyle(Color.white)

			Divider().frame(height: 1).background(Color.white).padding(.vertical, 30)
				.padding(.horizontal)

			// MARK: Ask for permissions
			if notificationPermManager.notificationPermissionGranted {
				Image(systemName: "checkmark.circle.fill").font(.system(size: 50))
					.foregroundStyle(.white).padding(5)

				Text("Required permissions granted.").font(.headline.weight(.bold))
					.foregroundStyle(Color.white).multilineTextAlignment(
						.center)
			} else {
				Text(
					"To activate this function allow us to send you notifications:"
				).font(.headline.weight(.bold)).foregroundStyle(Color.white)
					.multilineTextAlignment(.center)

				STDLButton(
					title: "Allow push notifications", bgColor: .white,
					textColor: DefaultSettings.shared.appMainColor,
					action: {
						if UserDefaults.standard.bool(
							forKey: "permissionsAskedPreviously")
						{
							if UIApplication.shared.canOpenURL(
								URL(
									string: UIApplication
										.openSettingsURLString
								)!)
							{
								UIApplication.shared.open(
									URL(
										string:
											UIApplication
											.openSettingsURLString
									)!, options: [:],
									completionHandler: nil)
							}
						} else {
							NotificationManager.shared
								.requestNotificationPermissions()
							UserDefaults.standard.set(
								true,
								forKey: "permissionsAskedPreviously"
							)
						}
					}
				).padding(.vertical)
			}

			Spacer()
		}
	}

	// MARK: Introduction page 5: Password
	@ViewBuilder var page5_PasswordView: some View {
		VStack {
			Text("Quick introduction").font(.largeTitle.weight(.heavy)).foregroundStyle(
				Color.white
			).padding(.top, 60)

			Spacer()

			Image(systemName: "eye.slash").resizable().frame(
				maxWidth: 250, maxHeight: 150
			).foregroundStyle(.white)

			Spacer()

			Text("You can make your tasks hidden.").font(.headline.weight(.heavy))
				.foregroundStyle(Color.white)

			Divider().frame(height: 1).background(Color.white).padding(.vertical, 30)
				.padding(.horizontal)

			// MARK: Password setup
			if viewModel.userPassExists {
				Image(systemName: "checkmark.circle.fill").font(.system(size: 50))
					.foregroundStyle(.white).padding(5)

				Text("Password set successfully.").font(.headline.weight(.bold))
					.foregroundStyle(Color.white).multilineTextAlignment(
						.center)
			} else {

				Text(
					"To use this function you need to\ncreate user password first:"
				).font(.headline.weight(.bold)).foregroundStyle(Color.white)
					.multilineTextAlignment(.center).padding(.bottom, 8)

				ZStack {
					RoundedRectangle(cornerRadius: 10).foregroundStyle(
						Color.white
					).frame(height: 55)

					STDLSecuredField(
						headerText: "Set password:",
						tooltipText: "New password",
						inputVar: $viewModel.newPassField1
					).padding(.horizontal).offset(y: -5)
				}.padding(.horizontal)

				ZStack {
					RoundedRectangle(cornerRadius: 10).foregroundStyle(
						Color.white
					).frame(height: 55)

					STDLSecuredField(
						headerText: "Confirm password:",
						tooltipText: "Confirm password",
						inputVar: $viewModel.newPassField2
					).padding(.horizontal).offset(y: -5)
				}.padding(.horizontal)

				Text(viewModel.errTxt).foregroundStyle(
					DefaultSettings.shared.darkRedColor
				).multilineTextAlignment(.center).bold().padding(0)

				STDLButton(
					title: "Set password", bgColor: .white,
					textColor: DefaultSettings.shared.appMainColor,
					action: { viewModel.savePasswordButtonAction() })

			}

			Spacer()
		}
	}

	// MARK: Introduction page 6: Summary
	@ViewBuilder var page6_SummaryView: some View {
		VStack {
			Text("Setup summary:").font(.largeTitle.weight(.heavy)).foregroundStyle(
				Color.white
			).padding(.top, 60)

			Spacer()

			HStack {
				Image(systemName: "bell").font( /*@START_MENU_TOKEN@*/
					.title /*@END_MENU_TOKEN@*/
				).bold().foregroundStyle(.white).padding(.horizontal)

				Text("Notification:").font( /*@START_MENU_TOKEN@*/
					.title /*@END_MENU_TOKEN@*/
				).bold().foregroundStyle(.white)

				Spacer()

				if notificationPermManager.notificationPermissionGranted {
					Image(systemName: "checkmark").font( /*@START_MENU_TOKEN@*/
						.title /*@END_MENU_TOKEN@*/
					).bold().foregroundStyle(
						DefaultSettings.shared.darkGreenColor
					).padding(.horizontal)
				} else {
					Image(systemName: "xmark").font( /*@START_MENU_TOKEN@*/
						.title /*@END_MENU_TOKEN@*/
					).bold().foregroundStyle(
						DefaultSettings.shared.darkRedColor
					).padding(.horizontal)
				}
			}.padding()

			HStack {
				Image(systemName: "lock").font( /*@START_MENU_TOKEN@*/
					.title /*@END_MENU_TOKEN@*/
				).bold().foregroundStyle(.white).padding(.horizontal)

				Text("Password:").font( /*@START_MENU_TOKEN@*/
					.title /*@END_MENU_TOKEN@*/
				).bold().foregroundStyle(.white)

				Spacer()

				if viewModel.userPassExists {
					Image(systemName: "checkmark").font( /*@START_MENU_TOKEN@*/
						.title /*@END_MENU_TOKEN@*/
					).bold().foregroundStyle(
						DefaultSettings.shared.darkGreenColor
					).padding(.horizontal)
				} else {
					Image(systemName: "xmark").font( /*@START_MENU_TOKEN@*/
						.title /*@END_MENU_TOKEN@*/
					).bold().foregroundStyle(
						DefaultSettings.shared.darkRedColor
					).padding(.horizontal)
				}
			}.padding()

			Spacer()

			Text("All set!").font(.largeTitle.weight(.heavy)).foregroundStyle(
				Color.white
			).padding(.top, 60)

			Spacer()

			// MARK: Start program button
			STDLButton(
				title: "Start the program", bgColor: .white,
				textColor: DefaultSettings.shared.appMainColor,
				action: {
					withAnimation {
						UserDefaults.standard.set(true, forKey: "skipIntro")
						skipIntro = true
					}
				})

			Spacer()
		}
	}
}
