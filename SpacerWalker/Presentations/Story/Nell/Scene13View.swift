//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene13View: View {
    @Binding var path: [Route]
    @State var isNextButton: Bool = true
    private let narration: [String] = [
        "But guess what…",
        "The three friends are parts of the Sun’s powerful forces.",
        "They travel with the Sun’s breath, the solar wind, a stream of charged particles flowing through space.",
        "This breath makes a giant invisible bubble around all the planets the heliosphere,",
        "a shield that guards the solar system from space villains.",
    ]

    var body: some View {
        ZStack(alignment: .trailing) {
            backgroundVideo

            nextButton

            subtitle
            
            licenses
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .autoNarration(.scene13)
    }
    
    var licenses: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("Credit NASA")
                    .foregroundColor(.white)
                    .opacity(0.5)
                    .padding(16)
            }
        }
    }

    var subtitle: some View {
        VStack {
            Spacer()
            SubtitleView(
                sentences: narration,
                typingSpeeds: [0.06, 0.06, 0.06, 0.06, 0.06],
                holdDurations: [0.8, 1.1, 0.9, 0.8, 0.8]
            )
            .padding(.horizontal, 40)
            .padding(.bottom, 43)
        }
    }

    var backgroundVideo: some View {
        VideoPlayer(path: "CosmicRaysHeliopause")
    }

    var nextButton: some View {
        NextButton(destination: Scene14View(path: $path))
            .animFadeIn(order: 10, visible: $isNextButton)
            .padding(16)
    }
}

#Preview {
    Scene13View(path: .constant([.story]))
}
