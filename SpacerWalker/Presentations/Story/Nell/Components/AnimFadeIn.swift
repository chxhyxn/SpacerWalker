//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct AnimFadeInModifier: ViewModifier {
    let duration: Double
    let offsetY: CGFloat
    let delay: Double
    @State private var appear: Bool = false
    @Binding private var visible: Bool

    init(
        duration: Double,
        offsetY: CGFloat,
        delay: Double,
        visible: Binding<Bool>
    ) {
        self.duration = duration
        self.offsetY = offsetY
        self.delay = delay
        _visible = visible
    }

    func body(content: Content) -> some View {
        content
            .opacity(appear ? 1 : 0)
            .offset(y: appear ? 0 : offsetY)
            .animation(.easeInOut(duration: duration), value: appear)
            .onAppear {
                if !visible { return }
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
            .onChange(of: visible) { _, visible in
                if visible {
                    appear = true
                } else {
                    appear = false
                }
            }
    }
}

extension View {
    func animFadeIn(
        duration: Double = 0.25,
        offsetY: CGFloat = 10,
        order: Int = 0,
        visible: Binding<Bool> = Binding.constant(true)
    ) -> some View {
        self.modifier(
            AnimFadeInModifier(
                duration: duration,
                offsetY: offsetY,
                delay: Double(order) * 0.1,
                visible: visible
            )
        )
    }
}
