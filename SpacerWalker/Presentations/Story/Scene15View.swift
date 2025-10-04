//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene15View: View {
    @Binding var path: [Route]

    var body: some View {
        Button {
            path = []
        } label: {
            Text("인트로로 돌아가기")
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    Scene15View(path: .constant([.story]))
}
