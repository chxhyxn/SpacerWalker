//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct AuroraPlayerView: View {
    @Binding var progress: Double

    var currentImageName: String {
        let index = (Int(progress * 305.0) + 1).clamped(to: 0...306)
        return "Aurora\(index)"
    }

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            Image(currentImageName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .frame(width: width, height: height)
        }
    }
}
