//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene1View: View {
    @Binding var path: [Route]

    private let narration: [String] = [
        "Hi there! I’m HERMES.",
        "I’m a little fairy who observes space weather.",
        "Today, I’d like to tell you a fun story about the Sun and its three best friends. (Touch Hermes!)",
    ]

    @State private var rocketOffsetY: CGFloat = 1200
    @State private var hermesOffsetY: CGFloat = 1200
    @State private var rocketScale: CGFloat = 0.8
    @State private var hermesScale: CGFloat = 0.8
    @State private var touchScale: CGFloat = 0.8
    @State private var startNarration: Bool = false
    @State private var currentHermesIndex: Int = 0
    @State private var isNarrationEnd = false
    @State private var isPopUpPresented = false
    
    private let hermesSpeakingImages = [
        "hermesMovingMouth2",
        "hermesMovingMouth1",
        "hermesMovingMouth3"
    ]
    private let hermesTouchImages = [
        "hermesTouch1",
        "hermesTouch2",
        "hermesTouch3"
    ]

    private let animationInterval: TimeInterval = 0.3
    
    private let riseDuration: Double = 2.5
    private let holdAtCenter: Double = 1.0
    private let rocketExitDuration: Double = 1.0

    var body: some View {
        ZStack {
            Image(.spaceBackground)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            Image(.rocketonloy)
                .offset(y: rocketOffsetY)
                .scaleEffect(rocketScale)
            
            Image(hermesSpeakingImages[currentHermesIndex])
                .offset(y: hermesOffsetY)
                .scaleEffect(hermesScale)
            
            if isNarrationEnd {
                Image(hermesTouchImages[currentHermesIndex])
                    .offset(y: hermesOffsetY)
                    .onTapGesture {
                        isPopUpPresented = true
                    }
                
                HStack {
                    Spacer()
                    NextButton(destination: Scene2View(path: $path))
                        .padding(.trailing, 40)
                }
            }
            
            VStack {
                Spacer()
                
                if startNarration {
                    SubtitleView(
                        sentences: narration,
                        typingSpeeds: [0.1, 0.07, 0.06],
                        holdDurations: [0.8, 0.6],
                        onComplete: {
                            isNarrationEnd = true
                        }
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 83)
                }
            }
            .ignoresSafeArea(edges: .bottom)
            
            if isPopUpPresented {
                HermesIntroducingView(isPresented: $isPopUpPresented)
                    .transition(.opacity)
            }
        }
        .navigationBarBackButtonHidden()
        .autoNarration(.scene1, delay: riseDuration + holdAtCenter)
        .onAppear {
            Task { await runAnimationSequence() }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                startHermesAnimation()
            }
        }
    }
    
    private func startHermesAnimation() {
        Timer.scheduledTimer(withTimeInterval: animationInterval, repeats: true) { _ in
                currentHermesIndex = (currentHermesIndex + 1) % hermesSpeakingImages.count
        }
    }

    private func runAnimationSequence() async {
        try? await Task.sleep(for: .seconds(0.5))

        withAnimation(.interpolatingSpring(stiffness: 180, damping: 20).speed(0.15)) {
            rocketOffsetY = 0
            hermesOffsetY = 0
            rocketScale = 1.0
            hermesScale = 1.0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + riseDuration + holdAtCenter) {
            withAnimation(.easeInOut(duration: rocketExitDuration)) {
                rocketOffsetY = -1200
                rocketScale = 0.6
            }
            startNarration = true
        }
    }
}

#Preview {
    Scene1View(path: .constant([.story]))
}
