//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Hermes: View {
    @State private var isAtFinalPosition = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(systemName: "airplane.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .position(
                        x: isAtFinalPosition ? 50 : geometry.size.width - 50,
                        y: isAtFinalPosition ? geometry.size.height - 50 : 50
                    )
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeInOut(duration: 2.5)) {
                                isAtFinalPosition = true
                            }
                        }
                    }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea()
    }
}
