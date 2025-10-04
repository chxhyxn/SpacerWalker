//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

internal import Combine
import SwiftUI

struct Scene5View: View {
    @Binding var path: [Route]

    private let motionManager = MotionManager()

    private let narration1: [String] = [
        "This friend’s name is Radi.",
        "Radi is messy, always sprinkling cookie crumbs wherever he goes.",
    ]

    private let narration2: [String] = [
        "Oops! Radi dropped crumbs again!",
        "The crumbs got into a spaceship, and the astronaut sighed",
        "“Not again… now it’s showing errors!”",
    ]

    @State private var phase: Int = 1

    @State private var shakeTask: Task<Void, Never>? = nil
    @State private var physicsTask: Task<Void, Never>? = nil

    //    private let screenWidth: CGFloat = 1210
    //    private let screenHeight: CGFloat = 835

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

    @State var radiWidth: CGFloat = 200
    private var computedRadiWidth: CGFloat {
        if cameraState == .whole {
            return radiWidth / 2
        } else {
            return radiWidth
        }
    }

    @State var radiX: CGFloat = 100
    private var computedRadiX: CGFloat {
        if cameraState == .whole {
            return radiX / 2
        } else {
            return radiX
        }
    }

    @State var radiY: CGFloat = 0

    @State var radiDeltaY: CGFloat = 25

    // MARK: - Stamp effect
    private struct Stamp: Identifiable, Equatable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var variant: Int
        var rotation: Angle
        var scale: CGFloat
        var opacity: Double
    }

    @State private var stamps: [Stamp] = []
    private let maxStamps: Int = 200

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
                // Stamps (rendered behind Radi)
                ForEach(stamps) { stamp in
                    Image("crumble\(stamp.variant)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            width: stamp.scale,
                            height: stamp.scale
                        )
                        .rotationEffect(stamp.rotation)
                        .position(x: stamp.x, y: stamp.y)
                        .opacity(stamp.opacity)
                        .allowsHitTesting(false)
                }

                // Radi
                Image("radiRun")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(
                        width: computedRadiWidth,
                        height: computedRadiWidth
                    )
                    .position(
                        x: computedRadiX,
                        y: radiY
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
                                        .stroke(
                                            Color.buttonStroke,
                                            lineWidth: 1
                                        )
                                )

                            Image(systemName: "chevron.right")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        .frame(width: 80, height: 80)
                    }
                }
                if phase == 4 {
                    Button {
                        withAnimation {
                            radiX = screenWidth - radiWidth / 2
                            cameraState = .right
                            phase = 5
                        }
                        AudioService.shared.playNarration(.scene9)
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.buttonBackground)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            Color.buttonStroke,
                                            lineWidth: 1
                                        )
                                )

                            Image(systemName: "chevron.right")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        .frame(width: 80, height: 80)
                    }
                }
                if phase == 6 {
                    NextButton(destination: Scene6View(path: $path))
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
                        typingSpeeds: [0.07, 0.07, 0.07],
                        holdDurations: [0.7, 0.7],
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
            radiY = screenHeight / 2
            motionManager.start()
            shakeTask = Task {
                for await _ in motionManager.shakeDegreesStream {
                    await handleShake()
                }
            }

            AudioService.shared.playNarration(.scene7)
        }
        .ignoresSafeArea(.all)
        .navigationBarBackButtonHidden()
    }

    private func handleShake() async {
        if phase == 3 {
            let xMargin = max(screenWidth * 2 - radiWidth / 2, 0)

            withAnimation(.easeOut(duration: 0.1)) {
                radiX += 100
                if radiX > xMargin {
                    radiX = xMargin
                }
                radiY += radiDeltaY
                spawnStamps(aroundX: computedRadiX, y: radiY, count: 10)
            }
            if radiDeltaY == 25 {
                radiDeltaY = 50
            }
            radiDeltaY *= -1
            if radiX == xMargin {
                withAnimation {
                    phase = 4
                }
            }
        }
        try? await Task.sleep(for: .seconds(0.1))
    }

    // MARK: - Stamp generation
    private func spawnStamps(aroundX x: CGFloat, y: CGFloat, count: Int) {
        let baseSize = computedRadiWidth
        var new: [Stamp] = []

        for _ in 0 ..< count {
            let horizontalRange = baseSize * 0.8
            let verticalMin = baseSize * 0.6
            let verticalMax = baseSize * 1.8

            let offsetX = CGFloat.random(in: -horizontalRange ... horizontalRange)
            let sign: CGFloat = Bool.random() ? -1 : 1
            let offsetY = sign * CGFloat.random(in: verticalMin ... verticalMax)

            let scale = CGFloat.random(in: 10 ... 20)
            let rotation = Angle.degrees(Double.random(in: 0 ... 360))
            let variant = Int.random(in: 1 ... 4)

            let stamp = Stamp(
                x: x + offsetX,
                y: y + offsetY,
                variant: variant,
                rotation: rotation,
                scale: scale,
                opacity: 1.0
            )
            new.append(stamp)
        }

        // Append and cap the total number of stamps
        stamps.append(contentsOf: new)
        if stamps.count > maxStamps {
            stamps.removeFirst(stamps.count - maxStamps)
        }

        // Schedule fade-out and removal
        for id in new.map({ $0.id }) {
            let delay = Double.random(in: 0.3 ... 1.0)
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(delay))
                if let idx = stamps.firstIndex(where: { $0.id == id }) {
                    withAnimation(.easeOut(duration: 0.25)) {
                        stamps[idx].opacity = 0
                    }
                }
                try? await Task.sleep(for: .seconds(0.3))
                if let idx = stamps.firstIndex(where: { $0.id == id }) {
                    stamps.remove(at: idx)
                }
            }
        }
    }

    enum CameraState {
        case left
        case right
        case whole
    }
}

#Preview {
    Scene5View(path: .constant([.story]))
}
