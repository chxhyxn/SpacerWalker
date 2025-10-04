//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct IntroView: View {
    var body: some View {
        VStack {
            NavigationLink(value: Route.story) {
                Text("시작하기")
            }
        }
    }
}

#Preview {
    IntroView()
}
