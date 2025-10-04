//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene4View: View {
    @Binding var path: [Route]
    
    var body: some View {
        NavigationLink(destination: Scene5View(path: $path)) {
            Text("다음")
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    Scene4View(path: .constant([.story]))
}
