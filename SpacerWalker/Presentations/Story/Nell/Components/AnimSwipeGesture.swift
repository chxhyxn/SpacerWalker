//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct AnimSwipeGestureView: View {
    @State private var offsetX: CGFloat = 0
    private let lineWidth: CGFloat = 80
    private var lineScale: CGFloat {
        Double(min(1, max(0, abs(offsetX) / 100)))
    }

    private let animation = Animation.easeInOut(duration: 0.8)
        .repeatForever(autoreverses: true)

    var body: some View {
        ZStack(alignment: .trailing) {
            // MARK: Line
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white, Color.white.opacity(0),
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(
                    width: lineWidth * lineScale,
                    height: 4
                )
                .padding(.bottom, 34)
                .offset(x: -45)

            // MARK: Hand
            Image(systemName: "hand.tap")
                .resizable()
                .scaledToFit()
                .bold()
                .frame(width: 52, height: 52)
                .foregroundColor(.white)
                .offset(x: offsetX)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeOut(duration: 0.8)) {
                    offsetX = -lineWidth
                }
            }
        }
    }
}
