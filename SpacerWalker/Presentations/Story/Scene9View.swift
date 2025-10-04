//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene9View: View {
    @Binding var path: [Route]

    var body: some View {
        NavigationLink(destination: Scene10View(path: $path)) {
            Text("다음")
        }
        .navigationBarBackButtonHidden()
        .autoNarration(.scene9)
    }
}

#Preview {
    Scene9View(path: .constant([.story]))
}
