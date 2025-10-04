//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene14View: View {
    @State private var viewModel: Scene14ViewModel = .init()
    @State private var dragOffset: CGFloat = 0
    @State private var lastDragOffset: CGFloat = 0
    @State private var isPlaying: Bool = false
    private let initDragOffset: CGFloat = 100

    var body: some View {
        ZStack(alignment: .bottom) {
            // MARK: Sky
            sky

            // MARK: Aurora
            aurora

            // MARK: Earth & People
            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height
                let r = w / 2
                // MARK: Earth
                Circle()
                    .foregroundColor(.blue)
                    .position(x: r * 1.5, y: h * 1.2)
            }

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
        .ignoresSafeArea()
    }

    var sky: some View {
        GeometryReader { geo in
            Image("Aurora")
                .resizable()
                .scaledToFill()
                .frame(
                    width: geo.size.width,
                    height: geo.size.height
                )
        }
    }

    var aurora: some View {
        GeometryReader { geo in
            VideoPlayer(path: "Aurora", isPlaying: $isPlaying)
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
    }

    var slider: some View {
        Color.clear
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let w = value.translation.width
                        isPlaying = true
                        dragOffset = max(
                            0,
                            lastDragOffset - w
                        )
                    }
                    .onEnded { _ in
                        lastDragOffset = dragOffset
                    }
            )
    }
}

#Preview {
    Scene14View()
}
