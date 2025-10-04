//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene13View: View {
    @Binding var path: [Route]

    var body: some View {
        NavigationLink(destination: Scene14View(path: $path)) {
            Text("다음")
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    Scene13View(path: .constant([.story]))
}
