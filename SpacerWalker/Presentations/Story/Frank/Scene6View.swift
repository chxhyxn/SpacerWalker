//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

internal import Combine
import SwiftUI

struct Scene6View: View {
    @Binding var path: [Route]

    let soundManager: SoundManager = SoundManager()

    @State private var phase: Int = 1

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
                Image("backgroundFrank")
                    .resizable()
                    .scaledToFill()
            )
            .position(x: backgroundX, y: screenHeight / 2)

            // Character Layer
            ZStack {
                // CME
                Image(Int(computedCmeX) % 100 > 50 ? "cmeRunBig" : "cmeRunSmall")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(
                        width: computedCmeWidth,
                        height: computedCmeWidth
                    )
                    .rotationEffect(.degrees(cmeAngle), anchor: .bottomTrailing)
                    .position(
                        x: computedCmeX,
                        y: 417
                    )
                
                // Fart stamps overlayed above CME
                ForEach(fartStamps) { stamp in
                    Image("fart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: stamp.width * 0.35, height: stamp.width * 0.35)
                        .padding(.bottom, 90)
                        .rotationEffect(.degrees(stamp.angle), anchor: .bottomTrailing)
                        .position(x: stamp.x, y: stamp.y)
                        .offset(x: -stamp.width * 0.22, y: -stamp.width * 0.05)
                        .opacity(stamp.fadeOut ? 0 : 1)
                        .scaleEffect(stamp.fadeOut ? 1.25 : 1.0)
                        .animation(.easeOut(duration: 0.35), value: stamp.fadeOut)
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
                        ZStack {
                            Circle()
                                .foregroundColor(.blue)
                                .frame(width: 60, height: 60)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .bold))
                        }
                    }
                } else if phase == 4 {
                    Button {
                        withAnimation {
                            cmeX = screenWidth - cmeWidth / 2
                            cameraState = .right
                            phase = 5
                        }
                        Task {
                            try? await Task.sleep(for: .seconds(5))
                            phase = 6
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .foregroundColor(.blue)
                                .frame(width: 60, height: 60)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .bold))
                        }
                    }
                } else if phase == 6 {
                    NextButton(destination: Scene13View(path: $path))
                }
            }
        }
        .task {
            soundManager.startMonitoring()
            try? await Task.sleep(for: .seconds(5))
            phase = 2
        }
        .onReceive(soundDetectTimer) { _ in
            if hasTriggeredWind { return }
            if phase != 3 { return }
            if soundManager.soundLevel > 0.9 {
                hasTriggeredWind = true
                Task { @MainActor in
                    await handleWindDetect()
                }
            }
        }
        .ignoresSafeArea(.all)
        .navigationBarBackButtonHidden()
    }

    private func handleWindDetect() async {
        let xMargin = max(screenWidth * 2 - cmeWidth / 2, 0)
        var step = 0

        while cmeX < xMargin {
            cmeX += 10
            cmeAngle += 5
            if step % 4 == 0 { spawnFartStamp() }
            step += 1
            try? await Task.sleep(for: .milliseconds(30))
        }
        
        withAnimation {
            phase = 4
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
            x: computedCmeX + 90,
            y: 400,
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

