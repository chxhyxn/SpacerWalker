//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct SceneNarrationModifier: ViewModifier {
    let narration: Narration
    func body(content: Content) -> some View {
        content
            .onAppear { AudioService.shared.playNarration(narration) }
    }
}

extension View {
    func autoNarration(_ narration: Narration) -> some View {
        modifier(SceneNarrationModifier(narration: narration))
    }
}
