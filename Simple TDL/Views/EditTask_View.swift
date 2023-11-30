//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import SwiftUI

struct EditTask_View: View {
	let task: ToDoTask

	@Environment(\.dismiss) var dismiss

	var body: some View {
		NavigationView {
			VStack {

				// MARK: Header
				STDLHeader(heatderText: "Edit Task").padding(.top, 10)

				// MARK: Task form call
				TaskForm_View(task: task)

				// MARK: Close sheet button
				STDLButton(title: "Close", bgColor: .gray, action: { dismiss() })
					.padding(.vertical)

				Spacer()
			}
		}
	}
}
