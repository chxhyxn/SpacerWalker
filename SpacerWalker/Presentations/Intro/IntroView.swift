//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct IntroView: View {
    @State private var showCharacters = false
    @State private var isFadeInAnimation = false
    @State private var isZoomEffectAnimation = false

    var body: some View {
        ZStack {
            ZStack {
                Image(.introSpaceBackground)
                    .resizable()
                    .scaledToFill()
                    .opacity(showCharacters ? 0 : 1)

                Image(.afterSpaceBackground)
                    .resizable()
                    .scaledToFill()
                    .opacity(showCharacters ? 1 : 0)
                    .scaleEffect(isZoomEffectAnimation ? 1.0 : 1.2)
            }
            .animation(.easeInOut(duration: 1.0), value: showCharacters)
            .animation(.easeInOut(duration: 5.0), value: isZoomEffectAnimation)

            VStack {
                VStack(spacing: 4) {
                    Text("The Three Solar Rascals")
                        .font(.oneMobile64)
                        .foregroundStyle(.white)
                        .scaleEffect(isFadeInAnimation ? 1.0 : 0.9)
                        .opacity(isFadeInAnimation ? 1 : 0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.2), value: isFadeInAnimation)

                    Text("A Sun and Space Weather Story Told by HERMES")
                        .font(.oneMobile32)
                        .foregroundStyle(.white.opacity(0.9))
                        .scaleEffect(isFadeInAnimation ? 1.0 : 0.95)
                        .opacity(isFadeInAnimation ? 1 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: isFadeInAnimation)
                }

                Spacer()

                NavigationLink(value: Route.story) {
                    RoundedRectangle(cornerRadius: 70)
                        .fill(.white)
                        .frame(width: 230, height: 82)
                        .overlay {
                            Text("START!")
                                .font(.oneMobile40)
                                .foregroundStyle(.black)
                        }
                        .scaleEffect(isFadeInAnimation ? 1 : 0.8)
                        .opacity(isFadeInAnimation ? 1 : 0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(1.0), value: isFadeInAnimation)
                }
                .padding(.bottom, 52)

                HStack {
                    Spacer()
                    Text("2025 NASA Space Apps Challenge © SPACEWALK")
                        .font(.system(size: 14, weight: .light))
                        .foregroundStyle(.white.opacity(0.8))
                }
                .padding(.trailing, 30)
            }
            .padding(.top, 80)
            .padding(.bottom, 24)
        }
        .onAppear {
            isFadeInAnimation = true
            isZoomEffectAnimation = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                showCharacters = true
            }
        }
        .background(.black)
        .autoNarration(.scene0, delay: 1.0)
    }
}

#Preview {
    IntroView()
}
