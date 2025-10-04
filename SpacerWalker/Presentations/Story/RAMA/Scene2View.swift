//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene2View: View {
    @Binding var path: [Route]

    var body: some View {
        ZStack {
            GeometryReader { geo in
                Image("spaceBackground")
                    .resizable()
                
                Image("sunWithSpot1")
                    .position(x: geo.size.width / 2 + 30, y: geo.size.height)
                
                Image("family").resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.white)
                    .frame(width: 500)
                    .position(x: geo.size.width / 2, y: geo.size.height - 400)
                
                NextButton(destination: Scene4View(path: $path))
                    .position(x: geo.size.width - 60, y: geo.size.height / 2)
            }

        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
//        .autoNarration(.scene2)
    }
}

#Preview {
    Scene2View(path: .constant([.story]))
}
