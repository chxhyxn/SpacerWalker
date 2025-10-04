//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene3View: View {
    @Binding var path: [Route]

    var body: some View {
        NavigationLink(destination: Scene4View(path: $path)) {
            Text("다음")
        }
        .navigationBarBackButtonHidden()
        .autoNarration(.scene3)
    }
}

#Preview {
    Scene3View(path: .constant([.story]))
}
