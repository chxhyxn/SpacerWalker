//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct NextButton<Destination: View>: View {
    var destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            ZStack {
                Circle()
                    .fill(.buttonBackground)
                    .overlay(
                        Circle()
                            .stroke(Color.buttonStroke, lineWidth: 1)
                    )

                Image(systemName: "chevron.right")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.white)
            }
            .frame(width: 80, height: 80)
        }
    }
}

#Preview {
    NextButton(destination: IntroView())
}
