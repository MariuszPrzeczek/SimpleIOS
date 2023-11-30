//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import SwiftUI

// The identity of the TextField and the SecureField
enum Field: Hashable {
	case showPasswordField
	case hidePasswordField
}

struct STDLSecuredField: View {
	let headerText: String
	let tooltipText: String
	@Binding var inputVar: String

	// Options for opacity of the fields
	enum Opacity: Double {

		case hide = 0.0
		case show = 1.0

		// Toggle opacity
		mutating func toggle() {
			switch self {
			case .hide: self = .show
			case .show: self = .hide
			}
		}
	}

	// The property wrapper type that can read and write
	// a value that SwiftUI updates as the placement of focus
	@FocusState private var focusedField: Field?

	// The show / hide state of the text
	@State private var isSecured: Bool = true

	// Opacity of the fields
	@State private var hidePasswordFieldOpacity = Opacity.show
	@State private var showPasswordFieldOpacity = Opacity.hide

	var body: some View {
		ZStack(alignment: .topLeading) {

			Text(headerText).font(.system(size: 11)).foregroundStyle(.gray)
				.offset(x: 1, y: -12)
			ZStack(alignment: .trailing) {
				securedTextField

				Button(
					action: { performToggle() },
					label: {
						Image(
							systemName: self.isSecured
								? "eye.slash" : "eye"
						)
						.tint(.gray)
					}
				)
			}
		}
		.padding(.top, 10)
	}

	var securedTextField: some View {
		Group {

			SecureField(tooltipText, text: $inputVar)
				.textInputAutocapitalization(.never).keyboardType(.asciiCapable)
				.autocorrectionDisabled(true)
				.focused($focusedField, equals: .hidePasswordField)
				.opacity(hidePasswordFieldOpacity.rawValue)

			TextField(tooltipText, text: $inputVar).textInputAutocapitalization(.never)
				.keyboardType(.asciiCapable).autocorrectionDisabled(true)
				.focused($focusedField, equals: .showPasswordField)
				.opacity(showPasswordFieldOpacity.rawValue)
		}
		.padding(.trailing, 32)
	}

	func performToggle() {

		isSecured.toggle()

		if isSecured {
			focusedField = .hidePasswordField
		}
		else {
			focusedField = .showPasswordField
		}

		hidePasswordFieldOpacity.toggle()
		showPasswordFieldOpacity.toggle()

	}
}
