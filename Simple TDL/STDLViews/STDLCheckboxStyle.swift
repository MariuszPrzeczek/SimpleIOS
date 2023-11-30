//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import Foundation
import SwiftUI

struct STDLCheckboxStyle: ToggleStyle {
	func makeBody(configuration: Configuration) -> some View {
		HStack {

			RoundedRectangle(cornerRadius: 5.0).stroke(lineWidth: 2)
				.frame(width: 25, height: 25).cornerRadius(5.0)
				.overlay {
					Image(
						systemName: configuration.isOn
							? "checkmark.square.fill" : ""
					)
				}
				.onTapGesture {
					withAnimation(.spring()) { configuration.isOn.toggle() }
				}

			configuration.label

		}
	}
}
