//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import SwiftUI

struct STDLPickerMenu: View {
	let txt: String
	@Binding var selectedItem: String
	let selectOptions: [String]

	var body: some View {
		HStack {
			Text(txt)

			Spacer()

			Picker("", selection: $selectedItem) {
				ForEach(selectOptions, id: \.self) { Text($0) }.pickerStyle(.menu)
			}
		}
	}
}

/*#Preview {
    STDLPickerMenu()
}*/
