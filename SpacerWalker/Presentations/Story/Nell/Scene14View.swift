//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene14View: View {
    @State private var dragOffset: CGFloat = 0
    @State private var lastDragOffset: CGFloat = 0
    @State private var progress: Double = 0.0
    @State private var screenSize: CGSize = .zero
    @State private var friendsXOffset: CGFloat = -200
    @State private var isNextButton: Bool = false
    @State private var showDragGuide: Bool = true
    private let initFriendOffset: CGFloat = -8
    private let dragRatio: CGFloat = 1.35

    var body: some View {
        GeometryReader { geo in
            initScreenSize(geo)

            ZStack(alignment: .bottom) {
                sky

                aurora

                handGuide

                // MARK: White line
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: 5, height: screenSize.height * 2)
                    .position(
                        x: screenSize.width - dragOffset + 7.5,
                        y: screenSize.height / 2
                    )

                friends

                // earth

                people

                slider

                nextButton
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
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
                        width: max(0, dragOffset + initFriendOffset),
                        height: screenSize.height
                    )
            }
        }
    }

    var handGuide: some View {
        // MARK: Hand guide
        AnimSwipeGestureView()
            .position(
                x: screenSize.width - dragOffset - 200,
                y: 150
            )
            .animFadeIn(order: 10, visible: $showDragGuide)
    }

    var friends: some View {
        // MARK: Friends
        Image("AuroraFriends")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 208)
            .overlay {
                // MARK: Guide
                Image("Scene15Guide")
                    .position(x: -150, y: 200)
                    .animFadeIn(order: 8, visible: $showDragGuide)
            }
            .position(
                x: screenSize.width - dragOffset - initFriendOffset - 78
                    - friendsXOffset,
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

            Image("People")
                .foregroundColor(.yellow)
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
        Image("earth")
            .resizable()
            .scaledToFit()
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
                        // MARK: Drag start
                        let w = value.translation.width * dragRatio
                        dragOffset = (lastDragOffset - w).clamped(
                            to: 0...(screenSize.width - initFriendOffset + 100)
                        )
                        withAnimation {
                            progress = dragOffset / screenSize.width
                            isNextButton = progress >= 1
                            showDragGuide = progress == 0
                        }
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
