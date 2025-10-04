//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene14View: View {
    @State private var viewModel: Scene14ViewModel = .init()

    var body: some View {
        ZStack {
            sky
            aurora
        }
        .ignoresSafeArea()
    }

    var sky: some View {
        Image("Aurora")
            .resizable()
            .scaledToFill()
            .frame(width: .infinity, height: .infinity)
    }

    var aurora: some View {
        VideoPlayer(path: "Aurora")
            .aspectRatio(contentMode: .fill)
            .frame(width: .infinity, height: .infinity)
            .ignoresSafeArea()
    }
}

#Preview {
    Scene14View()
}
