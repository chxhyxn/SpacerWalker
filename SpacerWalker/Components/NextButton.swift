//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct NextButton<Destination: View>: View {
    var destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            NextButtonLabel()
        }
    }
}

struct NextButtonLabel: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(.buttonBackground)
                .overlay(
                    Circle()
                        .stroke(Color.buttonStroke, lineWidth: 1)
                )

            Image(systemName: "chevron.right")
                .font(.system(size: 50, weight: .bold))
                .foregroundStyle(.white)
        }
        .frame(width: 100, height: 100)
    }
}

#Preview {
    NextButton(destination: IntroView())
}
