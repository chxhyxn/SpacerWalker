//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene1View: View {
    @Binding var path: [Route]
    let narration: [String] = [
        "Hi there! I’m HERMES.",
        "I’m a little fairy who observes space weather.",
        "Today, I’d like to tell you a fun story about the Sun and its three best friends.",
    ]

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack {
                NavigationLink(destination: Scene2View(path: $path)) {
                    Text("다음")
                        .font(.oneMobile100)
                        .foregroundStyle(.white)
                }

                SubtitleView(
                    sentences: narration,
                    typingSpeeds: [0.11, 0.07, 0.06],
                    holdDurations: [0.8, 0.6]
                )
            }
        }
        .navigationBarBackButtonHidden()
        .autoNarration(.scene1)
    }
}

#Preview {
    Scene1View(path: .constant([.story]))
}
