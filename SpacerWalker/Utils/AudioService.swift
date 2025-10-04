//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import AVFoundation

@Observable
final class AudioService: NSObject {
    static let shared = AudioService()
    
    private var narrationPlayer: AVAudioPlayer?
    private var bgmPlayer: AVAudioPlayer?
    private var sfxPlayers: [String: AVAudioPlayer] = [:]
    
    private(set) var currentNarration: Narration?
    
    private override init() {
        super.init()
        configureAudioSession()
    }
    
    private func configureAudioSession() {
        let session = AVAudioSession.sharedInstance()
        try? AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers])
        try? AVAudioSession.sharedInstance().setActive(true)
    }
}

extension AudioService {
    func playNarration(
        _ narration: Narration,
        ext: String = "mp3"
    ) {
        if currentNarration == narration, let narrationPlayer {
            narrationPlayer.currentTime = 0
            narrationPlayer.play()
            return
        }

        stopNarration()

        guard let url = Bundle.main.url(forResource: narration.filename, withExtension: ext) else { return }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            player.prepareToPlay()
            player.play()
            narrationPlayer = player
            currentNarration = narration
        } catch {
            print("❌ Error playing \(narration.filename): \(error.localizedDescription)")
        }
    }

    func stopNarration() {
        narrationPlayer?.stop()
        narrationPlayer = nil
        currentNarration = nil
    }
}

extension AudioService: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(
        _ player: AVAudioPlayer,
        successfully flag: Bool
    ) {
        guard let narrationPlayer else { return }
        stopNarration()
    }
}
