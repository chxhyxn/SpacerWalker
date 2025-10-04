//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene1View: View {
    @Binding var path: [Route]
    let narration: [String] = [
        "Hi there! I’m HERMES.",
        "I’m a little fairy who observes space weather.",
        "Today, I’d like to tell you a fun story about the Sun and its three best friends."
    ]

    var body: some View {
        SubtitleView(
            sentences: narration,
            typingSpeeds: [0.11, 0.08, 0.06],
            holdDurations: [0.8, 0.3]
        )
        NavigationLink(destination: Scene2View(path: $path)) {
            Text("다음")
        }
        .navigationBarBackButtonHidden()
        .autoNarration(.scene1)
    }
}

#Preview {
    Scene1View(path: .constant([.story]))
}
