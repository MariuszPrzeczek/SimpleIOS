//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import SwiftUI

struct NewTask_View: View {

	var body: some View {
		NavigationView {
			VStack {

				// header
				STDLHeader(heatderText: "New Task")

				// Call empty form view
				TaskForm_View(task: nil)
			}
		}
	}
}
