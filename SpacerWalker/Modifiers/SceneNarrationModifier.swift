//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct SceneNarrationModifier: ViewModifier {
    let narration: Narration
    var delay: Double = 0
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if delay > 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        AudioService.shared.playNarration(narration)
                    }
                } else {
                    AudioService.shared.playNarration(narration)
                }
            }
    }
}

extension View {
    func autoNarration(
        _ narration: Narration,
        delay: Double = 0
    ) -> some View {
        modifier(SceneNarrationModifier(narration: narration, delay: delay))
    }
}
