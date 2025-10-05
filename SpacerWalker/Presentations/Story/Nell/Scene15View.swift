//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

internal import Combine
import SwiftUI

private enum SceneState {
    case appear, sunglass, twingkle, theEnd

    var showEyes: Bool {
        self == .sunglass || self == .twingkle
    }
}

private enum RadiEyeState {
    case left, right, bottom
}

struct Scene15View: View {
    @Binding var path: [Route]
    @State private var screenSize: CGSize = .zero
    @State private var state: SceneState = .appear
    @State private var time: Double = 0  // time tracker
    @State private var radiEyeState: RadiEyeState = .left
    private let narration: [String] = [
        "We call these three friends “Space Weather.”",
        "Even though they sometimes cause trouble,",
        "they also paint the sky with beautiful auroras,",
        "and remind us how deeply connected we are to our Sun.",
        "The Sun’s warmth, its breath,",
        "and even its storms all of them work together to keep our planet alive and full of light.",
        "So we keep learning how to live together with our Sun’s friends every day.",
    ]

    var body: some View {
        GeometryReader { geo in
            initScreenSize(geo)
            ZStack(alignment: .center) {
                background

                Group {
                    friends
                    subtitle
                }.animFadeIn(
                    visible: Binding(
                        get: { state != .theEnd },
                        set: { _ in }
                    )
                )

                // MARK: The End
                Group {
                    sun
                    earth
                    bottomGradient
                    theEnd
                    restartButton
                }.animSlide(
                    offsetY: 100,
                    visible: Binding(
                        get: { state == .theEnd },
                        set: { _ in }
                    )
                )
            }
        }
        .onAppear {
            changeStateTimer()
        }
        .autoNarration(.scene15)
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
    }

    func changeStateTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeIn(duration: 0.5)) {
                state = .sunglass
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            withAnimation(.easeIn(duration: 0.2)) {
                state = .twingkle
            }
        }
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            withAnimation {
                switch radiEyeState {
                case .left:
                    radiEyeState = .right
                case .right:
                    radiEyeState = .bottom
                case .bottom:
                    radiEyeState = .left
                }
            }
        }
    }

    func circleX(radius: CGFloat, clockwise: Bool) -> CGFloat {
        let direction: CGFloat = clockwise ? 1 : -1
        return sin(time * direction) * radius
    }

    func circleY(radius: CGFloat, clockwise: Bool) -> CGFloat {
        let direction: CGFloat = clockwise ? 1 : -1
        return cos(time * direction) * radius
    }

    func initScreenSize(_ geo: GeometryProxy) -> some View {
        Color.clear
            .onAppear {
                self.screenSize = geo.size
            }
            .onChange(of: geo.size) { _, newSize in
                self.screenSize = newSize
            }
    }

    var restartButton: some View {
        VStack {
            Spacer()
            Button(action: {
                path = []
            }) {
                HStack(spacing: 16) {
                    Image("Refresh")

                    Text("RE-START")
                        .font(.oneMobile40)
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 42)
                .padding(.vertical, 16)
            }
            .background(
                RoundedRectangle(cornerRadius: 48)
                    .fill(Color.white)
            )
            .padding(.bottom, 82)
        }
    }

    var theEnd: some View {
        Text("THE END")
            .font(.oneMobile64)
            .foregroundColor(.white)
            .background {
                Ellipse()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(stops: [
                                .init(
                                    color: Color.black.opacity(1.0),
                                    location: 0.0
                                ),
                                .init(
                                    color: Color.black.opacity(0.5),
                                    location: 1.0
                                ),
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 384.5
                        )
                    )
                    .frame(
                        width: screenSize.width / 2,
                        height: screenSize.height / 2
                    )
                    .border(.blue)
                    .blur(radius: 74)

            }
            .offset(y: -50)
    }

    var friends: some View {
        ZStack(alignment: .center) {
            Group {
                Image("FinalFriends")
                    .resizable()
                    .scaledToFill()
                    .animFadeIn(
                        visible: Binding(
                            get: { state != .theEnd },
                            set: { _ in }
                        )
                    )

                Image("FinalEyes")
                    .resizable()
                    .scaledToFill()
                    .animFadeIn(
                        visible: Binding(
                            get: { state.showEyes },
                            set: { _ in }
                        )
                    )

                Image("FinalRadiLeftEyes")
                    .resizable()
                    .scaledToFill()
                    .offset(
                        x: radiEyeOffset(for: true).x,
                        y: radiEyeOffset(for: true).y
                    )

                Image("FinalRadiRightEyes")
                    .resizable()
                    .scaledToFill()
                    .offset(
                        x: radiEyeOffset(for: false).x,
                        y: radiEyeOffset(for: false).y
                    )

                Image("FinalSunglass")
                    .resizable()
                    .scaledToFill()
                    .offset(y: state == .appear ? 0 : 30)

                Image("FinalTwingkle")
                    .resizable()
                    .scaledToFill()
                    .animFadeIn(
                        visible: Binding(
                            get: { state == .twingkle },
                            set: { _ in }
                        )
                    )
            }
            .frame(
                width: screenSize.width,
                height: screenSize.height,
                alignment: .center
            )
        }
    }

    var sun: some View {
        // MARK: Sun
        Image("sunWithSpot4")
            .offset(
                x: -screenSize.width * 0.21,
                y: screenSize.height * 0.5
            )
    }

    var earth: some View {
        Image("earth")
            .resizable()
            .scaledToFit()
            .frame(width: 180)
            .offset(
                x: screenSize.width * 0.5,
                y: screenSize.height * 0.3
            )
    }

    var bottomGradient: some View {
        VStack {
            Spacer()
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(
                                    color: Color.black.opacity(0.0),
                                    location: 0.00
                                ),
                                .init(
                                    color: Color.black.opacity(0.49),
                                    location: 0.43
                                ),
                                .init(
                                    color: Color.black.opacity(0.57),
                                    location: 0.53
                                ),
                                .init(
                                    color: Color.black.opacity(0.63),
                                    location: 0.65
                                ),
                                .init(
                                    color: Color.black.opacity(0.70),
                                    location: 0.92
                                ),
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 313)

                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(
                                    color: Color.black.opacity(0.0),
                                    location: 0.00
                                ),
                                .init(
                                    color: Color.black.opacity(0.49),
                                    location: 0.43
                                ),
                                .init(
                                    color: Color.black.opacity(0.57),
                                    location: 0.53
                                ),
                                .init(
                                    color: Color.black.opacity(0.63),
                                    location: 0.65
                                ),
                                .init(
                                    color: Color.black.opacity(0.70),
                                    location: 0.92
                                ),
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(
                        width: screenSize.width,
                        height: 160
                    )
            }
        }
    }

    var background: some View {
        Image("spaceBackground")
            .resizable()
            .scaledToFill()
            .frame(
                width: screenSize.width,
                height: screenSize.height,
                alignment: .center
            )
            .clipped()
    }

    var subtitle: some View {
        VStack {
            Spacer()
            SubtitleView(
                sentences: narration,
                typingSpeeds: [0.06, 0.06, 0.06, 0.06, 0.06, 0.06, 0.06],
                holdDurations: [0.9, 0.9, 0.9, 0.8, 0.8, 0.8, 0.8]
            ) {
                state = .theEnd
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 43)
        }
    }

    fileprivate func radiEyeOffset(for isLeft: Bool) -> CGPoint {
        switch (radiEyeState, isLeft) {
        case (.left, true): return CGPoint(x: -10, y: -10)
        case (.right, true): return CGPoint(x: 5, y: 0)
        case (.bottom, true): return CGPoint(x: -12, y: 3)
        case (.left, false): return CGPoint(x: -10, y: 0)
        case (.right, false): return CGPoint(x: 10, y: 0)
        case (.bottom, false): return CGPoint(x: -15, y: 10)
        }
    }
}

#Preview {
    Scene15View(path: .constant([.story]))
}
