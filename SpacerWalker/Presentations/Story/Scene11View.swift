//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene11View: View {
    @Binding var path: [Route]

    var body: some View {
        NavigationLink(destination: Scene12View(path: $path)) {
            Text("다음")
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    Scene11View(path: .constant([.story]))
}
