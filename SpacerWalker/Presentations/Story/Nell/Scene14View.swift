//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene14View: View {
    @State private var dragOffset: CGFloat = 0
    @State private var lastDragOffset: CGFloat = 0
    @State private var progress: Double = 0.0
    @State private var screenSize: CGSize = .zero
    @State private var friendsXOffset: CGFloat = -200
    @State private var isNextButton: Bool = false
    private let initDragOffset: CGFloat = 0
    private let dragRatio: CGFloat = 1.25

    var body: some View {
        GeometryReader { geo in
            initScreenSize(geo)

            ZStack(alignment: .bottom) {
                sky

                aurora

                friends

                earth

                people

                slider

                nextButton
            }
        }
        .ignoresSafeArea()
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
        let targetX = screenSize.width - dragOffset - initDragOffset - 80
        return Image("AuroraFriends")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: screenSize.height / 4)
            .position(
                x: targetX - friendsXOffset,
                y: screenSize.height / 3
            )
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeOut(duration: 0.25)) {
                        friendsXOffset = 0
                    }
                }
            }
    }

    var people: some View {
        HStack {
            Spacer()

            Rectangle()
                .foregroundColor(.yellow)
                .frame(width: 100, height: 200)
                .padding(120)
        }
        .animSlide(offsetY: 350, order: 3)
    }

    var nextButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                NextButton(destination: Scene15View())
                    .animFadeIn(visible: $isNextButton)
                    .padding(16)
            }
            Spacer()
        }
    }

    var earth: some View {
        Circle()
            .foregroundColor(.blue)
            .position(
                x: screenSize.width / 2 * 1.5,
                y: screenSize.height * 1.2
            )
            .animSlide(offsetY: 350, order: 2)
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
                        isNextButton = progress >= 1
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
