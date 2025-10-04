//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import AVKit
import SwiftUI

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
        AVKit.VideoPlayer(player: player)
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
