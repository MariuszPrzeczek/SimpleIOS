//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import SwiftUI

struct Main_View: View {

	@StateObject var viewModel = Main_ViewModel()

	var body: some View {
        
        // Check if intro has been shown
		if viewModel.skipIntro {
            
            // MARK: Main TabView
			TabView(selection: $viewModel.tabViewSelect) {

				Archiv_View().tabItem {
					Label("Archiv", systemImage: "archivebox.fill")
				}.tag(1).toolbarBackground(.visible, for: .tabBar)
					.toolbarBackground(
						DefaultSettings.shared.appMainColor, for: .tabBar
					).toolbarColorScheme(.dark, for: .tabBar)

				ToDoList_View().tabItem {
					Label(
						"ToDo list",
						systemImage: "list.bullet.clipboard.fill")
				}.tag(2).toolbarBackground(.visible, for: .tabBar)
					.toolbarBackground(
						DefaultSettings.shared.appMainColor, for: .tabBar
					).toolbarColorScheme(.dark, for: .tabBar)

				NewTask_View().tabItem {
					Label("Add Task", systemImage: "plus.square.fill")
				}.tag(3).toolbarBackground(.visible, for: .tabBar)
					.toolbarBackground(
						DefaultSettings.shared.appMainColor, for: .tabBar
					).toolbarColorScheme(.dark, for: .tabBar)

				Settings_View().tabItem {
					Label("Settings", systemImage: "gearshape.fill")
				}.tag(4).toolbarBackground(.visible, for: .tabBar)
					.toolbarBackground(
						DefaultSettings.shared.appMainColor, for: .tabBar
					).toolbarColorScheme(.dark, for: .tabBar)
			}.onAppear(perform: {
				UNUserNotificationCenter.current().setBadgeCount(
					0, withCompletionHandler: nil)
			})
		} else {
            // MARK: IntroductionView call
			Introduction_View(skipIntro: $viewModel.skipIntro)
		}
	}
}
