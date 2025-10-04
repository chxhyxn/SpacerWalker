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
    @State private var player: AVPlayer
    @State private var endObserver: NSObjectProtocol?

    init(path: String) {
        let url = Bundle.main.url(forResource: path, withExtension: "mp4")!
        let player = AVPlayer(url: url)
        player.actionAtItemEnd = .none
        _player = State(initialValue: player)
    }

    var body: some View {
        VideoPlayerView(player: player)
            .onAppear {
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
            .onDisappear {
                player.pause()
                if let observer = endObserver {
                    NotificationCenter.default.removeObserver(observer)
                }
            }
    }
}
