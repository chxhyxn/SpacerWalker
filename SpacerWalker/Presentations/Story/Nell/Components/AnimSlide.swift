//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct AnimSlideModifier: ViewModifier {
    let duration: Double
    let offsetX: CGFloat
    let offsetY: CGFloat
    let delay: Double
    @State private var appear = false

    func body(content: Content) -> some View {
        content
            .offset(
                x: appear ? 0 : offsetX,
                y: appear ? 0 : offsetY
            )
            .animation(.easeInOut(duration: duration), value: appear)
            .onAppear {
                if delay > 0 {
                    DispatchQueue.main.asyncAfter(
                        deadline: .now() + delay
                    ) {
                        appear = true
                    }
                } else {
                    appear = true
                }
            }
    }
}

extension View {
    func animSlide(
        duration: Double = 0.25,
        offsetX: CGFloat = 0,
        offsetY: CGFloat = 0,
        order: Int = 0
    ) -> some View {
        modifier(
            AnimSlideModifier(
                duration: duration,
                offsetX: offsetX,
                offsetY: offsetY,
                delay: Double(order) * 0.1
            )
        )
    }
}
