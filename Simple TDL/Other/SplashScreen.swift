//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import SwiftUI

struct SplashScreen: View {
	@State var isActive: Bool = false
	@State private var size = 0.8
	@State private var opacity = 0.5

	var body: some View {
		if isActive {
			Main_View()
		}
		else {
			ZStack {
                DefaultSettings.shared.appMainColor.ignoresSafeArea()
				VStack {
					Image(uiImage: UIImage(named: "AppIcon")!).resizable()
						.frame(maxWidth: 200, maxHeight: 200)

					Text("Simple TDL").font(.system(size: 30)).bold()
						.foregroundStyle(Color.white)
				}
				.scaleEffect(size).opacity(opacity)
				.onAppear {
					withAnimation(.easeIn(duration: 1.3)) {
						self.size = 1.0
						self.opacity = 1.0
					}

				}
			}
			.onAppear {
				DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
					withAnimation {
						self.opacity = 0.0
						DispatchQueue.main.asyncAfter(
							deadline: .now() + 0.5
						) { withAnimation { self.isActive = true } }
					}
				}
			}
		}
	}
}

#Preview { SplashScreen() }
