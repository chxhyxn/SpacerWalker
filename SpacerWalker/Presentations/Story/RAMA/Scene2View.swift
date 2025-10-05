//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene2View: View {
    @Binding var path: [Route]

    @State private var isNarrationEnd = false

    private let narration: [String] = [
        "A Long Long time ago, There were the three playful friends on sun.",
        "Their names were Flare, Radi, and CME",
    ]

    var body: some View {
        ZStack {
            GeometryReader { geo in
                Image("spaceBackground")
                    .resizable()
                    .scaledToFill()

                Image("sunWithSpot1")
                    .position(x: geo.size.width / 2 + 30, y: geo.size.height)
                    .animFadeIn(order: 1)

                Image("family").resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.white)
                    .frame(width: 500)
                    .position(x: geo.size.width / 2, y: geo.size.height - 400)
                    .animFadeIn(order: 1)

                NextButton(destination: Scene3View(path: $path))
                    .position(x: geo.size.width - 60, y: geo.size.height / 2)
                    .animFadeIn(visible: $isNarrationEnd)
            }

            VStack {
                Spacer()

                SubtitleView(
                    sentences: narration,
                    typingSpeeds: [0.07, 0.07],
                    holdDurations: [0.7],
                    onComplete: {
                        isNarrationEnd = true
                    }
                )
                .padding(.horizontal, 40)
                .padding(.bottom, 43)
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .autoNarration(.scene2)
    }
}

#Preview {
    Scene2View(path: .constant([.story]))
}
