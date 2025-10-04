//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene13View: View {
    @Binding var path: [Route]
    @State var isNextButton: Bool = true

    var body: some View {
        ZStack(alignment: .trailing) {
            // MARK: Background
            backgroundVideo

            // MARK: Characters
            characters

            // MARK: Next button
            nextButton
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
    }

    var characters: some View {
        let startIndex = 0
        return VStack {
            Spacer()
            HStack(alignment: .bottom) {
                Rectangle()
                    .frame(width: 100, height: 150)
                    .foregroundColor(.orange)
                    .animFadeIn(order: startIndex + 1)
                Rectangle()
                    .frame(width: 100, height: 300)
                    .foregroundColor(.yellow)
                    .animFadeIn(order: startIndex + 2)
                Rectangle()
                    .frame(width: 100, height: 200)
                    .foregroundColor(.pink)
                    .animFadeIn(order: startIndex + 3)
            }
        }
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
