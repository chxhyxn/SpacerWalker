//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct SubtitleView: View {
    let fullText: String
    let typingSpeed: Double
    
    @State private var displayedText: String = ""

    init(fullText: String, typingSpeed: Double = 0.1) {
        self.fullText = fullText
        self.typingSpeed = typingSpeed
    }

    var body: some View {
        Text(displayedText)
            .onAppear {
                typeWriter()
            }
    }
    
    private func typeWriter() {
        guard displayedText.count < fullText.count else { return }
        
        let index = fullText.index(fullText.startIndex, offsetBy: displayedText.count)
        displayedText.append(fullText[index])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + typingSpeed) {
            typeWriter()
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        SubtitleView(fullText: "이것은 기본 속도 테스트입니다.")
            .font(.title)
        
        SubtitleView(fullText: "이것은 빠른 속도 테스트입니다.", typingSpeed: 0.03)
            .font(.title)
        
        SubtitleView(fullText: "이것은 느린 속도 테스트입니다.", typingSpeed: 0.25)
            .font(.title)
    }
    .padding()
    .preferredColorScheme(.dark)
}
