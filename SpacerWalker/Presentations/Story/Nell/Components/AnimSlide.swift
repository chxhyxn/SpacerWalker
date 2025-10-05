//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct AnimSlideModifier: ViewModifier {
    let duration: Double
    let offsetX: CGFloat
    let offsetY: CGFloat
    let delay: Double
    @Binding var visible: Bool
    @State private var appear = false

    func body(content: Content) -> some View {
        content
            .opacity(appear ? 1 : 0)
            .offset(
                x: appear ? 0 : offsetX,
                y: appear ? 0 : offsetY
            )
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
    func animSlide(
        duration: Double = 0.25,
        offsetX: CGFloat = 0,
        offsetY: CGFloat = 0,
        order: Int = 0,
        visible: Binding<Bool> = Binding.constant(true)
    ) -> some View {
        modifier(
            AnimSlideModifier(
                duration: duration,
                offsetX: offsetX,
                offsetY: offsetY,
                delay: Double(order) * 0.1,
                visible: visible
            )
        )
    }
}
