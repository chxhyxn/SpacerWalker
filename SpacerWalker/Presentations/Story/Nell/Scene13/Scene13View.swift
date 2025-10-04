//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene13View: View {
    @Binding var path: [Route]
    @State var viewModel: Scene13ViewModel = .init()

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack(alignment: .trailing) {
                // MARK: Background
                backgroundVideo
                    .frame(width: w, height: h)

                // MARK: Characters
                characters
                    .position(x: w - 200, y: h - 150)

                if viewModel.isNextButton {
                    // MARK: Next button
                    NextButton(destination: Scene14View())
                        .animFadeIn()
                        .padding(16)
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .onAppear {
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 1
            ) {
                viewModel.showNextButton()
            }
        }
    }

    var characters: some View {
        let startIndex = 0
        return HStack(alignment: .bottom) {
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

    var backgroundVideo: some View {
        VideoPlayer(path: "CosmicRaysHeliopause")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
    }
}

#Preview {
    Scene13View(path: .constant([.story]))
}
