//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene14View: View {
    @Binding var path: [Route]

    var body: some View {
        NavigationLink(destination: Scene15View(path: $path)) {
            Text("다음")
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    Scene14View(path: .constant([.story]))
}
