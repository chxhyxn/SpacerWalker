//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

internal import Combine
import SwiftUI

struct Scene4View: View {
    @Binding var path: [Route]

    private let motionManager = MotionManager()

    private let narration1: [String] = [
        "This friend’s name is Flare.",
        "He’s always in such a hurry that he can reach Earth in just 8 minutes, the fastest of the three.",
    ]

    private let narration2: [String] = [
        "But Flare is so fast, that every time he passes by, he disrupts Earth’s GPS satellites.",
        "A farmer grumbled, “Oh no, the GPS isn’t working! My field rows are all crooked.",
        "Flare must have come by again…”",
    ]

    @State private var phase: Int = 1
    @State private var showPhase1Button: Bool = false

    @State private var flareVelocity: CGVector = .zero
    @State private var flareTiltAccel: CGVector = .zero

    @State private var tiltTask: Task<Void, Never>? = nil
    @State private var physicsTask: Task<Void, Never>? = nil

    private let screenWidth: CGFloat = 1210
    private let screenHeight: CGFloat = 835

    @State private var cameraState: CameraState = .left
    private var backgroundX: CGFloat {
        if cameraState == .left {
            return screenWidth
        } else if cameraState == .right {
            return 0
        } else {
            return screenWidth / 2
        }
    }

    @State var flareWidth: CGFloat = 200
    private var computedFlareWidth: CGFloat {
        if cameraState == .whole {
            return flareWidth / 2
        } else {
            return flareWidth
        }
    }

    @State var flareX: CGFloat = 100
    private var computedFlareX: CGFloat {
        if cameraState == .whole {
            return flareX / 2
        } else {
            return flareX
        }
    }

    var body: some View {
        ZStack {
            // Background Layer
            HStack(spacing: 0) {
                // 왼쪽
                VStack(spacing: 0) {
                    Spacer()
                }
                .frame(
                    width: cameraState == .whole
                        ? screenWidth / 2 : screenWidth,
                    height: screenHeight
                )

                // 오른쪽
                VStack(spacing: 0) {
                    Spacer()
                }
                .frame(
                    width: cameraState == .whole
                        ? screenWidth / 2 : screenWidth,
                    height: screenHeight
                )
            }
            .background(
                Image("backgroundFrank")
                    .resizable()
                    .scaledToFill()
            )
            .position(x: backgroundX, y: screenHeight / 2)

            // Character Layer
            ZStack {
                // Flare
                Image("flareRun")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(
                        width: computedFlareWidth,
                        height: computedFlareWidth
                    )
                    .position(
                        x: computedFlareX,
                        y: 417
                    )
            }
            HStack {
                Spacer()
                if phase == 2 {
                    Button {
                        withAnimation {
                            cameraState = .whole
                            phase = 3
                        }
                    } label: {
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
                } else if phase == 4 {
                    Button {
                        withAnimation {
                            flareX = screenWidth - flareWidth / 2
                            cameraState = .right
                            phase = 5
                        }
                        AudioService.shared.playNarration(.scene6)
                    } label: {
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
                } else if phase == 6 {
                    NextButton(destination: Scene5View(path: $path))
                }
            }

            VStack {
                Spacer()
                if phase == 1 || phase == 2 {
                    SubtitleView(
                        sentences: narration1,
                        typingSpeeds: [0.07, 0.07],
                        holdDurations: [0.7],
                        onComplete: {
                            phase = 2
                        }
                    )
                    .padding(.horizontal, 40)
                    .padding(.bottom, 43)
                }

                if phase == 5 || phase == 6 {
                    SubtitleView(
                        sentences: narration2,
                        typingSpeeds: [0.07, 0.08, 0.07],
                        holdDurations: [1.4, 1.0],
                        onComplete: {
                            phase = 6
                        }
                    )
                    .padding(.horizontal, 40)
                    .padding(.bottom, 43)
                }
            }
        }
        // motionManager
        .task {
            motionManager.start()

            tiltTask = Task {
                for await vec in motionManager.tiltUnitStream {
                    await handleTiltVector(vec)
                }
            }

            physicsTask = Task { await runPhysicsLoop() }

            AudioService.shared.playNarration(.scene4)
        }
        .ignoresSafeArea(.all)
        .navigationBarBackButtonHidden()
    }

    private func handleTiltVector(_ vec: CGVector) async {
        let deadzone: CGFloat = 0.02
        let uy = abs(vec.dy) < deadzone ? 0 : CGFloat(vec.dy)

        let smoothing: CGFloat = 0.15
        flareTiltAccel.dy = flareTiltAccel.dy * (1 - smoothing) + uy * smoothing
    }

    private func runPhysicsLoop() async {
        var last = CACurrentMediaTime()
        while !Task.isCancelled {
            let now = CACurrentMediaTime()
            let dt = now - last
            last = now

            await MainActor.run {
                flarePhysicsStep(dt: dt)
            }

            try? await Task.sleep(for: .milliseconds(16))
        }
    }

    private func flarePhysicsStep(dt: Double) {
        let xMargin = max(screenWidth * 2 - flareWidth / 2, 0)

        let accelPerG: CGFloat = 16000
        let dampingPerSecond = 3.0

        let ay = flareTiltAccel.dy * accelPerG
        if ay > 0, phase == 3 {
            flareVelocity.dy += ay * CGFloat(dt)

            let damping = CGFloat(exp(-dampingPerSecond * dt))
            flareVelocity.dy *= damping

            var px = flareX + flareVelocity.dy * CGFloat(dt)

            if px < flareWidth / 2 {
                px = flareWidth / 2
            }
            if px > xMargin {
                px = xMargin
                phase = 4
            }

            flareX = px
        }
    }

    enum CameraState {
        case left
        case right
        case whole
    }
}

#Preview {
    Scene4View(path: .constant([.story]))
}
