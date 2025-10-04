//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

internal import Combine
import SwiftUI

struct Scene5View: View {
    @Binding var path: [Route]

    private let motionManager = MotionManager()
    
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

    @State var radiWidth: CGFloat = 100
    private var computedRadiWidth: CGFloat {
        if cameraState == .whole {
            return radiWidth / 2
        } else {
            return radiWidth
        }
    }

    @State var radiX: CGFloat = 50
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
                    if cameraState == .whole { Spacer() }
                    Color.red
                        .frame(
                            width: cameraState == .whole
                                ? screenWidth / 2 : screenWidth,
                            height: cameraState == .whole
                                ? screenHeight / 2 : screenHeight
                        )
                        .opacity(0.5)
                    if cameraState == .whole { Spacer() }
                }
                .frame(
                    width: cameraState == .whole
                        ? screenWidth / 2 : screenWidth,
                    height: screenHeight
                )

                // 오른쪽
                VStack(spacing: 0) {
                    if cameraState == .whole { Spacer() }
                    Color.blue
                        .frame(
                            width: cameraState == .whole
                                ? screenWidth / 2 : screenWidth,
                            height: cameraState == .whole
                                ? screenHeight / 2 : screenHeight
                        )
                        .opacity(0.5)
                    if cameraState == .whole { Spacer() }
                }
                .frame(
                    width: cameraState == .whole
                        ? screenWidth / 2 : screenWidth,
                    height: screenHeight
                )
            }
            .background(
                Image("SampleBackground")
                    .resizable()
                    .scaledToFill()
            )
            .position(x: backgroundX, y: screenHeight / 2)

            // Character Layer
            ZStack {
                // Radi
                Circle()
                    .fill(.pink)
                    .frame(
                        width: computedRadiWidth,
                        height: computedRadiWidth
                    )
                    .position(
                        x: computedRadiX,
                        y: radiY
                    )
            }

            VStack {
                Button {
                    withAnimation {
                        cameraState = .whole
                    }
                } label: {
                    Text("whole")
                }

                Button {
                    withAnimation {
                        cameraState = .left
                    }
                } label: {
                    Text("left")
                }

                Button {
                    withAnimation {
                        cameraState = .right
                    }
                } label: {
                    Text("right")
                }
                NextButton(destination: Scene6View(path: $path))
            }
            .tint(.white)
        }
        // motionManager
        .task {
            motionManager.start()
            shakeTask = Task {
                for await _ in motionManager.shakeDegreesStream {
                    await handleShake()
                }
            }
        }
        .ignoresSafeArea(.all)
        .navigationBarBackButtonHidden()
    }

    private func handleShake() async {
        let xMargin = max(screenWidth * 2 + radiWidth / 2, 0)

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
            print("radi벽에 닿음")
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
