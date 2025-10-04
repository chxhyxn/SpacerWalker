//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

internal import Combine
import SwiftUI

struct Scene5View: View {
    @Binding var path: [Route]

    private let motionManager = MotionManager()

    @State private var phase: Int = 1

    @State private var shakeTask: Task<Void, Never>? = nil
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

    @State var radiY: CGFloat = 417

    @State var radiDeltaY: CGFloat = 25

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
                            radiX = screenWidth - radiWidth / 2
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
                    NextButton(destination: Scene6View(path: $path))
                }
            }
        }
        // motionManager
        .task {
            motionManager.start()
            shakeTask = Task {
                for await _ in motionManager.shakeDegreesStream {
                    await handleShake()
                }
            }

            try? await Task.sleep(for: .seconds(5))
            phase = 2
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

    enum CameraState {
        case left
        case right
        case whole
    }
}

#Preview {
    Scene5View(path: .constant([.story]))
}
