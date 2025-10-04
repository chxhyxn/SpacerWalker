//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene14View: View {
    @State private var viewModel: Scene14ViewModel = .init()
    @State private var dragOffset: CGFloat = 0
    @State private var lastDragOffset: CGFloat = 0
    @State private var progress: Double = 0.0
    @State private var screenSize: CGSize = .zero
    private let initDragOffset: CGFloat = 100

    var body: some View {
        GeometryReader { geo in
            Color.clear
                .onAppear {
                    self.screenSize = geo.size
                }
                .onChange(of: geo.size) { _, newSize in
                    self.screenSize = newSize
                }

            ZStack(alignment: .bottom) {
                // MARK: Sky
                sky

                // MARK: Aurora
                aurora

                // MARK: Earth
                Circle()
                    .foregroundColor(.blue)
                    .position(
                        x: screenSize.width / 2 * 1.5,
                        y: screenSize.height * 1.2
                    )

                // MARK: People
                HStack {
                    Spacer()

                    Rectangle()
                        .foregroundColor(.yellow)
                        .frame(width: 100, height: 200)
                        .padding(120)
                }

                // MARK: Slider
                slider
            }
        }
        .ignoresSafeArea()
    }

    var sky: some View {
        Image("Aurora")
            .resizable()
            .scaledToFill()
            .frame(
                width: screenSize.width,
                height: screenSize.height
            )
    }

    var aurora: some View {
        VideoFramePlayer(
            path: "Aurora",
            progress: $progress
        )
        .mask {
            HStack {
                Spacer()
                Rectangle()
                    .frame(
                        width: dragOffset + initDragOffset,
                        height: .infinity
                    )
            }
        }
    }

    var slider: some View {
        Color.clear
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let w = value.translation.width
                        dragOffset = (lastDragOffset - w).clamped(
                            to: 0...(screenSize.width - initDragOffset + 10)
                        )
                        progress = dragOffset / screenSize.width
                    }
                    .onEnded { _ in
                        lastDragOffset = dragOffset
                    }
            )
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}

#Preview {
    Scene14View()
}
