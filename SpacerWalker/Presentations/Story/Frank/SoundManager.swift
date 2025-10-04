//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import AVFoundation
import SwiftUI

@Observable
class SoundManager {
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?

    var soundLevel: Float = 0.0

    init() {
        setupAudioRecorder()
    }

    deinit {
        stopMonitoring()
    }

    private func setupAudioRecorder() {
        let audioSession = AVAudioSession.sharedInstance()

        do {
            AVAudioApplication.requestRecordPermission { granted in
                if granted {
                    print("마이크 권한 승인됨")
                } else {
                    print("마이크 권한 거부됨")
                }
            }

            try audioSession.setCategory(.record, mode: .default)
            try audioSession.setActive(true)

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 1,
                AVLinearPCMBitDepthKey: 16,
                AVLinearPCMIsBigEndianKey: false,
                AVLinearPCMIsFloatKey: false,
            ]

            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFilename = documentPath.appendingPathComponent("soundMeter.wav")

            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
        } catch {
            print("오디오 레코더 설정 오류: \(error.localizedDescription)")
        }
    }

    func startMonitoring() {
        audioRecorder?.record()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            self.audioRecorder?.updateMeters()
            let power = self.audioRecorder?.averagePower(forChannel: 0) ?? -160

            self.soundLevel = (power > -8) ? (power + 160) / 160 : 0
            self.soundLevel = (power > -80) ? (power + 80) / 80 : 0
        }
    }

    func stopMonitoring() {
        timer?.invalidate()
        audioRecorder?.stop()

        soundLevel = 0
    }
}
