//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene2View: View {
    @Binding var path: [Route]

    var body: some View {
        NavigationLink(destination: Scene3View(path: $path)) {
            Text("다음")
        }
        .navigationBarBackButtonHidden()
        .autoNarration(.scene2)
    }
}

#Preview {
    Scene2View(path: .constant([.story]))
}
