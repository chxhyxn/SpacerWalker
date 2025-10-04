//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct NextButton<Destination: View>: View {
    var destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            ZStack {
                Circle()
                    .foregroundColor(.blue)
                    .frame(width: 60, height: 60)
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .bold))
            }
        }
    }
}
