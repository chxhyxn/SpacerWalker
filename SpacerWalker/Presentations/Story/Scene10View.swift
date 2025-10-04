//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene10View: View {
    @Binding var path: [Route]

    var body: some View {
        NavigationLink(destination: Scene11View(path: $path)) {
            Text("다음")
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    Scene10View(path: .constant([.story]))
}
