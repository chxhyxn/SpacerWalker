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
    @Binding var isPlaying: Bool
    @State private var player: AVPlayer
    @State private var endObserver: NSObjectProtocol?
    private let videoSize: CGSize
    private var ratio: CGFloat {
        videoSize.width / videoSize.height
    }

    init(path: String, isPlaying: Binding<Bool> = Binding.constant(true)) {
        let url = Bundle.main.url(forResource: path, withExtension: "mp4")!
        let asset = AVAsset(url: url)
        let track = asset.tracks(withMediaType: .video).first!
        videoSize = track.naturalSize.applying(track.preferredTransform)
        let player = AVPlayer(url: url)
        player.actionAtItemEnd = .none
        _player = State(initialValue: player)
        _isPlaying = isPlaying
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
                    if isPlaying {
                        player.play()
                    }
                    
                    endObserver = NotificationCenter.default.addObserver(
                        forName: .AVPlayerItemDidPlayToEndTime,
                        object: player.currentItem,
                        queue: .main
                    ) { _ in
                        player.seek(to: .zero)
                        player.play()
                    }
                }
                .onChange(of : isPlaying) { _, playing in
                    if playing {
                        player.play()
                    } else {
                        player.pause()
                    }
                }
                .onDisappear {
                    player.pause()
                    if let observer = endObserver {
                        NotificationCenter.default.removeObserver(observer)
                    }
                }
        }
    }
}
