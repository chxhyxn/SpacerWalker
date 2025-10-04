//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

import SwiftUI

struct SubtitleView: View {
    let sentences: [String]
    
    var typingSpeed: Double = 0.06
    var holdDuration: Double = 0.5
    var gapDuration: Double = 0.0
    
    var typingSpeeds: [Double] = []
    var holdDurations: [Double] = []
    var gapDurations: [Double] = []
    
    @State private var index: Int = 0
    @State private var displayed: String = ""
    @State private var isFinished: Bool = false
    
    var body: some View {
        Text(displayed)
            .multilineTextAlignment(.leading)
            .onAppear { startTyping() }
    }
    
    private func startTyping() {
        guard !sentences.isEmpty else { return }
        typeNextCharacter()
    }
    
    private func typeNextCharacter() {
        guard !isFinished, index < sentences.count else { return }
        let current = sentences[index]
        
        if displayed.count < current.count {
            let i = current.index(current.startIndex, offsetBy: displayed.count)
            displayed.append(current[i])
            
            let speed = typingSpeeds[safe: index] ?? typingSpeed
            DispatchQueue.main.asyncAfter(deadline: .now() + speed) {
                typeNextCharacter()
            }
        } else {
            let hold = holdDurations[safe: index] ?? holdDuration
            let gap  = gapDurations[safe: index]  ?? gapDuration
            
            DispatchQueue.main.asyncAfter(deadline: .now() + hold) {
                displayed = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + gap) {
                    index += 1
                    if index < sentences.count {
                        typeNextCharacter()
                    } else {
                        isFinished = true
                    }
                }
            }
        }
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    VStack(spacing: 30) {
        SubtitleView(sentences: ["이것은 기본 속도 테스트입니다."])
            .font(.title)
        
        SubtitleView(sentences: ["이것은 기본 속도 테스트입니다."])
            .font(.title)
        
        SubtitleView(sentences: ["이것은 기본 속도 테스트입니다."])
            .font(.title)
    }
    .padding()
    .preferredColorScheme(.dark)
}
