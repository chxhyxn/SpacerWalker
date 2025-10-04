//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene1View: View {
    @Binding var path: [Route]

    var body: some View {
        NavigationLink(destination: Scene2View(path: $path)) {
            Text("다음")
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    Scene1View(path: .constant([.story]))
}
