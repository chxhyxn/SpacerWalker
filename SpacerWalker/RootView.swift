//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct RootView: View {
    @State private var path: [Route] = []

    var body: some View {
        NavigationStack(path: $path) {
            IntroView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .intro:
                        IntroView()
                    case .story:
                        StoryView(path: $path)
                    }
                }
        }
    }
}

#Preview {
    RootView()
}
