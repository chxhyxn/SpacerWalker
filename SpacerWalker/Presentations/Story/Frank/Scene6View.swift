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

    @State private var hasTriggeredWind = false

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
                    .position(
                        x: computedCmeX,
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

        while cmeX < xMargin {
            cmeX += 10
            try? await Task.sleep(for: .milliseconds(30))
        }
        
        withAnimation {
            phase = 4
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
