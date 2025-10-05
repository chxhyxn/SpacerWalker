//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

internal import Combine
import SwiftUI

struct Scene6View: View {
    @Binding var path: [Route]

    @State var soundManager: SoundManager?

    private let narration1: [String] = [
        "This friend is called CME, the funny gassy friend.",
        "Among the three friends, he’s the slowest…",
        "but still, he can travel the long distance from the Sun to Earth in just a few days!",
    ]

    private let narration2: [String] = [
        "When CME releases her gas, the lights flicker, satellites shake, and kids jump in surprise.",
        "But she just can’t stop.",
    ]

    @State private var phase: Int = 1

    @State private var blinkBackgroundCount: Int = 0

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

    @State var cmeWidth: CGFloat = 200
    private var computedCmeWidth: CGFloat {
        if cameraState == .whole {
            return cmeWidth / 2
        } else {
            return cmeWidth
        }
    }

    @State var cmeX: CGFloat = 100
    private var computedCmeX: CGFloat {
        if cameraState == .whole {
            return cmeX / 2
        } else {
            return cmeX
        }
    }

    @State private var cmeAngle: Double = 0

    @State private var hasTriggeredWind = false
    @State private var fartStamps: [FartStamp] = []

    let soundDetectTimer = Timer.publish(every: 0.03, on: .main, in: .common)
        .autoconnect()

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
                Image(phase > 4 && blinkBackgroundCount % 20 > 10 ? "6Background" : "backgroundFrank")
                    .resizable()
                    .scaledToFill()
            )
            .position(x: backgroundX, y: screenHeight / 2)

            // Character Layer
            ZStack {
                // CME
                Image(
                    Int(computedCmeX) % 100 > 50 ? "cmeRunBig" : "cmeRunSmall"
                )
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(
                    width: computedCmeWidth,
                    height: computedCmeWidth
                )
                .rotationEffect(.degrees(cmeAngle), anchor: .bottomTrailing)
                .position(
                    x: computedCmeX,
                    y: screenHeight / 2
                )

                // Fart stamps overlayed above CME
                ForEach(fartStamps) { stamp in
                    VStack {
                        Image("fart")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(
                                width: stamp.width * 0.35,
                                height: stamp.width * 0.35
                            )
                        Spacer()
                            .frame(height: computedCmeWidth / 2)
                    }
                    .rotationEffect(
                        .degrees(stamp.angle),
                        anchor: .bottomTrailing
                    )
                    .position(x: stamp.x, y: stamp.y)
                    .offset(x: -stamp.width * 0.22, y: -stamp.width * 0.05)
                    .opacity(stamp.fadeOut ? 0 : 1)
                    .scaleEffect(stamp.fadeOut ? 1.25 : 1.0)
                    .animation(
                        .easeOut(duration: 0.35),
                        value: stamp.fadeOut
                    )
                }
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
                        NextButtonLabel()
                    }
                }
                if phase == 6 {
                    NextButton(destination: Scene13View(path: $path))
                }
            }

            VStack {
                if phase == 3 {
                    Image("blowIPad")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 144)
                        .padding(58)
                }
                Spacer()
                if phase == 1 || phase == 2 {
                    SubtitleView(
                        sentences: narration1,
                        typingSpeeds: [0.07, 0.07, 0.07],
                        holdDurations: [0.7, 0.7],
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
                        typingSpeeds: [0.07, 0.07],
                        holdDurations: [0.7],
                        onComplete: {
                            phase = 6
                        }
                    )
                    .padding(.horizontal, 40)
                    .padding(.bottom, 43)
                }
            }
        }
        .task {
            AudioService.shared.playNarration(.scene10)
        }
        .onReceive(soundDetectTimer) { _ in
            blinkBackgroundCount += 1
            if hasTriggeredWind { return }
            if phase != 3 { return }
            if soundManager == nil { soundManager = SoundManager() }
            guard let soundManager else { return }
            if soundManager.soundLevel > 0.9 {
                hasTriggeredWind = true
                self.soundManager = nil
                Task { @MainActor in
                    await handleWindDetect()
                }
            }
        }
        .ignoresSafeArea(.all)
        .navigationBarBackButtonHidden()
    }

    private func handleWindDetect() async {
        let xMargin = max(screenWidth * 2 + cmeWidth / 2, 0)
        var step = 0

        while cmeX < xMargin {
            cmeX += 10
            cmeAngle += 5
            if step % 4 == 0 { spawnFartStamp() }
            step += 1
            try? await Task.sleep(for: .milliseconds(30))
        }

        withAnimation {
            phase = 5
            cmeAngle = 0
            AudioService.shared.playNarration(.scene12)
        }
    }

    // MARK: - Fart stamp model and helpers
    private struct FartStamp: Identifiable, Equatable {
        let id: UUID
        let x: CGFloat
        let y: CGFloat
        let angle: Double
        let width: CGFloat
        var fadeOut: Bool
    }

    @MainActor
    private func spawnFartStamp() {
        let id = UUID()
        let stamp = FartStamp(
            id: id,
            x: computedCmeX + computedCmeWidth / 2,
            y: screenHeight / 2,
            angle: cmeAngle + 10,
            width: 300,
            fadeOut: false
        )
        fartStamps.append(stamp)

        // Trigger fade-out shortly after appearance, then remove
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let idx = fartStamps.firstIndex(where: { $0.id == id }) {
                withAnimation(.easeIn(duration: 0.9)) {
                    fartStamps[idx].fadeOut = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if let idx = fartStamps.firstIndex(where: { $0.id == id }) {
                    fartStamps.remove(at: idx)
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
    Scene6View(path: .constant([.story]))
}
