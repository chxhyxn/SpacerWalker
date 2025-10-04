//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene12View: View {
    @Binding var path: [Route]

    var body: some View {
        NavigationLink(destination: Scene13View(path: $path)) {
            Text("다음")
        }
        .navigationBarBackButtonHidden()
        .autoNarration(.scene12)
    }
}

#Preview {
    Scene12View(path: .constant([.story]))
}
