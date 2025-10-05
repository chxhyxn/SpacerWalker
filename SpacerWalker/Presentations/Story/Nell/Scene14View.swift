//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene14View: View {
    @Binding var path: [Route]
    @State private var dragOffset: CGFloat = 0
    @State private var lastDragOffset: CGFloat = 0
    @State private var progress: Double = 0.0
    @State private var screenSize: CGSize = .zero
    @State private var friendsXOffset: CGFloat = -200
    @State private var friend2XOffset: CGFloat = -200
    @State private var isNextButton: Bool = false
    @State private var showDragGuide: Bool = true
    @State private var isCheerSoundEffectPlaying: Bool = false
    private let initFriendOffset: CGFloat = -8
    private let dragRatio: CGFloat = 1.35
    private let audioService = AudioService.shared

    var body: some View {
        GeometryReader { geo in
            initScreenSize(geo)

            ZStack(alignment: .bottom) {
                sky

                aurora

                friends

                people

                slider

                nextButton
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .onDisappear {
            if isCheerSoundEffectPlaying {
                audioService.stopSoundEffect()
            }
        }
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
        AuroraPlayerView(progress: $progress)
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

    var friends: some View {
        ZStack {
            // MARK: Hand guide
            AnimSwipeGestureView()
                .position(
                    x: screenSize.width - dragOffset - 200,
                    y: 150
                )
                .animFadeIn(order: 12, visible: $showDragGuide)

            // MARK: White line
            Rectangle()
                .foregroundColor(.white)
                .frame(width: 5, height: screenSize.height * 2)
                .position(
                    x: screenSize.width - dragOffset + 7.5,
                    y: screenSize.height / 2
                )

            // MARK: Friends
            ZStack {
                Image("AuroraFriend2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(x: -friend2XOffset)
                Image("AuroraFriend1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .frame(width: 208)
            .overlay {
                // MARK: Guide
                Image("Scene15Guide")
                    .position(x: -150, y: 250)
                    .animFadeIn(order: 12, visible: $showDragGuide)
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    withAnimation(.easeOut(duration: 0.25)) {
                        friend2XOffset = 0
                    }
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
                NextButton(destination: Scene15View(path: $path))
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
                            to: 0 ... (screenSize.width - initFriendOffset + 100)
                        )
                        progress = dragOffset / screenSize.width
                        withAnimation {
                            isNextButton = progress >= 1
                            showDragGuide = progress == 0
                            if progress > 0.5, !isCheerSoundEffectPlaying {
                                self.isCheerSoundEffectPlaying = true
                                audioService.playSoundEffect("Cheer")
                            } else if progress == 0 {
                                self.isCheerSoundEffectPlaying = false
                                audioService.stopSoundEffect()
                            }
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
    Scene14View(path: .constant([.story]))
}
