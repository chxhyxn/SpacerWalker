//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene14View: View {
    @State private var dragOffset: CGFloat = 0
    @State private var lastDragOffset: CGFloat = 0
    @State private var progress: Double = 0.0
    @State private var screenSize: CGSize = .zero
    private let initDragOffset: CGFloat = 0
    private let dragRatio: CGFloat = 1.25

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
                sky

                aurora

                friends

                earth

                people

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
                        height: screenSize.height
                    )
            }
        }
    }

    var friends: some View {
        Image("AuroraFriends")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: screenSize.height / 4)
            .position(
                x: screenSize.width - dragOffset - initDragOffset - 80,
                y: screenSize.height / 3
            )
    }

    var people: some View {
        HStack {
            Spacer()

            Rectangle()
                .foregroundColor(.yellow)
                .frame(width: 100, height: 200)
                .padding(120)
        }
    }

    var earth: some View {
        Circle()
            .foregroundColor(.blue)
            .position(
                x: screenSize.width / 2 * 1.5,
                y: screenSize.height * 1.2
            )
    }

    var slider: some View {
        Color.clear
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let w = value.translation.width * dragRatio
                        dragOffset = (lastDragOffset - w).clamped(
                            to: 0...(screenSize.width - initDragOffset + 100)
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
