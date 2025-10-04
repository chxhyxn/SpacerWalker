//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene13View: View {
    @Binding var path: [Route]
    @State var isNextButton: Bool = true

    var body: some View {
        ZStack(alignment: .trailing) {
            // MARK: Background
            backgroundVideo

            // MARK: Next button
            nextButton
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .autoNarration(.scene13)
    }

    var backgroundVideo: some View {
        VideoPlayer(path: "CosmicRaysHeliopause")
    }

    var nextButton: some View {
        NextButton(destination: Scene14View())
            .animFadeIn(order: 10, visible: $isNextButton)
            .padding(16)
    }
}

#Preview {
    Scene13View(path: .constant([.story]))
}
