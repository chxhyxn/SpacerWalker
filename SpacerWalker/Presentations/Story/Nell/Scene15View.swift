//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene15View: View {
    private let narration: [String] = [
        "We call these three friends “Space Weather.”",
        "Even though they sometimes cause trouble,",
        "they also paint the sky with beautiful auroras,",
        "and remind us how deeply connected we are to our Sun.",
        "The Sun’s warmth, its breath, and even its storms all of them work together to keep our planet alive and full of light.",
        "So we keep learning how to live together with our Sun’s friends every day.",
    ]

    var body: some View {
        ZStack {
            background

            subtitle
        }
        .autoNarration(.scene15)
        .ignoresSafeArea()
    }

    var background: some View {
        Image("spaceBackground")
            .resizable()
            .scaledToFill()
    }

    var subtitle: some View {
        VStack {
            Spacer()
            SubtitleView(
                sentences: narration,
                typingSpeeds: [0.06, 0.06, 0.06, 0.06, 0.06, 0.06],
                holdDurations: [0.9, 0.9, 0.9, 0.8, 1.5, 0.8]
            )
            .padding(.horizontal, 40)
            .padding(.bottom, 43)
        }
    }
}

#Preview {
    Scene15View()
}
