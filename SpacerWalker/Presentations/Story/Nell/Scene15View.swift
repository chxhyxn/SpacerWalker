//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene15View: View {
    var body: some View {
        Button {
            
        } label: {
            Text("인트로로 돌아가기")
        }
        .navigationBarBackButtonHidden()
        .autoNarration(.scene15)
    }
}

#Preview {
    Scene15View()
}
