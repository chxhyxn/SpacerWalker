//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import AVKit
import SwiftUI

struct VideoPlayerView: UIViewControllerRepresentable {
    let player: AVPlayer

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        return controller
    }

    func updateUIViewController(
        _ uiViewController: AVPlayerViewController,
        context: Context
    ) {
    }
}

struct VideoPlayer: View {
    @Binding var progress: Double
    @State private var player: AVPlayer
    @State private var endObserver: NSObjectProtocol?
    private let videoSize: CGSize
    private var ratio: CGFloat {
        videoSize.width / videoSize.height
    }
    private var autoPlay: Bool {
        progress == -1
    }

    init(
        path: String,
        progress: Binding<Double> = Binding.constant(-1.0)
    ) {
        let url = Bundle.main.url(forResource: path, withExtension: "mp4")!
        let asset = AVAsset(url: url)
        let track = asset.tracks(withMediaType: .video).first!
        videoSize = track.naturalSize.applying(track.preferredTransform)
        let player = AVPlayer(url: url)
        player.actionAtItemEnd = .none
        _player = State(initialValue: player)
        _progress = progress
    }

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            VideoPlayerView(player: player)
                .ignoresSafeArea()
                .aspectRatio(contentMode: .fill)
                .frame(
                    width: height * ratio,
                    height: height
                )
                .position(
                    x: width / 2,
                    y: height / 2
                )
                .onAppear {
                    if autoPlay {
                        player.play()
                        endObserver = NotificationCenter.default.addObserver(
                            forName: .AVPlayerItemDidPlayToEndTime,
                            object: player.currentItem,
                            queue: .main
                        ) { _ in
                            player.seek(to: .zero)
                            player.play()
                        }
                    }
                }
                .onChange(of: progress) { _, newValue in
                    guard let duration = player.currentItem?.duration.seconds,
                        duration > 0
                    else { return }
                    let targetTime = CMTime(
                        seconds: newValue * duration,
                        preferredTimescale: 600
                    )
                    player.seek(to: targetTime)
                }
                .onDisappear {
                    if autoPlay {
                        player.pause()
                        if let observer = endObserver {
                            NotificationCenter.default.removeObserver(observer)
                        }
                    }
                }
        }
    }
}
