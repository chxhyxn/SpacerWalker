//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct AnimFadeInModifier: ViewModifier {
    let duration: Double
    let offsetY: CGFloat
    let delay: Double
    @State private var appear = false

    func body(content: Content) -> some View {
        content
            .opacity(appear ? 1 : 0)
            .offset(y: appear ? 0 : offsetY)
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
    func animFadeIn(
        duration: Double = 0.25,
        offsetY: CGFloat = 10,
        order: Int = 0,
    ) -> some View {
        self.modifier(
            AnimFadeInModifier(
                duration: duration,
                offsetY: offsetY,
                delay: Double(order) * 0.1
            )
        )
    }
}
