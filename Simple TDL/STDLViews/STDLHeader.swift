//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import SwiftUI

struct STDLHeader: View {
	let heatderText: String

	var body: some View {

		ZStack {
            Ellipse().fill(DefaultSettings.shared.appMainColor).frame(width: 1000, height: 400)
				.offset(y: -150)

			Text(heatderText).font(.system(size: 40)).bold()
				.foregroundStyle(Color.white).offset(y: 20)
		}
		.frame(height: 60).offset(y: -30)
	}
}

#Preview { STDLHeader(heatderText: "Example Text") }
