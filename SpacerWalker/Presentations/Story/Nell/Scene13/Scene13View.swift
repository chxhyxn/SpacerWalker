//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene13View: View {
    @Binding var path: [Route]
    @State var viewModel: Scene13ViewModel = .init()

    var body: some View {
        ZStack {
            backgroundVideo
        }
        .navigationBarBackButtonHidden()
    }
    
    var backgroundVideo: some View {
        VideoPlayer(path: "CosmicRaysHeliopause")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
    }
}

#Preview {
    Scene13View(path: .constant([.story]))
}
