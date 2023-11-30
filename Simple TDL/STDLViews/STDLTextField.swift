//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import SwiftUI

struct STDLTextField: View {
	let headerText: String
	let tooltipText: String
	@Binding var inputVar: String
	let lineLimit: Int?

	var body: some View {
		ZStack(alignment: .topLeading) {
			Text(headerText).font(.system(size: 11)).foregroundStyle(.gray)
				.offset(x: 1, y: -12)
			TextField(tooltipText, text: $inputVar, axis: .vertical)
				.lineLimit(lineLimit)
		}
		.padding(.top, 10)
	}
}

