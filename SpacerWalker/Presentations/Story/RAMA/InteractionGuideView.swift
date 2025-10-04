//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct InteractionGuideView: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Color.black.opacity(0.7)

            VStack(alignment: .leading, spacing: 0) {
                Spacer()

                Image(systemName: "hand.draw")
                    .font(.system(size: 71))
                    .foregroundColor(.white)

                Text("Drag the Earth to fast-forward 11 years.")
                    .font(.oneMobile38)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 209)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    InteractionGuideView()
}
