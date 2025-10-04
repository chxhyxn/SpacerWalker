//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene6View: View {
    @Binding var path: [Route]

    var body: some View {
        NavigationLink(destination: Scene7View(path: $path)) {
            Text("다음")
        }
        .navigationBarBackButtonHidden()
        .autoNarration(.scene6)
    }
}

#Preview {
    Scene6View(path: .constant([.story]))
}
