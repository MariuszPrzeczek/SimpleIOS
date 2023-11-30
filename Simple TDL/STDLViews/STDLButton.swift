//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import SwiftUI

struct STDLButton: View {
	let title: String
	let bgColor: Color
    var textColor: Color? = .white
	let action: () -> Void

	var body: some View {
		Button {
			action()
		} label: {
			ZStack {
				RoundedRectangle(cornerRadius: 10).foregroundColor(bgColor)

				Text(title).foregroundStyle(textColor!).bold()
			}
		}
		.frame(height: 50).padding(.vertical, 0).padding(.horizontal)
	}
}

#Preview { STDLButton(title: "Test", bgColor: DefaultSettings.shared.darkBlueColor, action: {}) }
