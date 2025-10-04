//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import Foundation

enum Narration: String, CaseIterable, Identifiable {
    case scene1 = "Scene1Narration"
    case scene2 = "Scene2Narration"
    case scene3 = "Scene3Narration"
    case scene4 = "Scene4Narration"
    case scene6 = "Scene6Narration"
    case scene7 = "Scene7Narration"
    case scene9 = "Scene9Narration"
    case scene10 = "Scene10Narration"
    case scene12 = "Scene12Narration"
    case scene13 = "Scene13Narration"
    case scene15 = "Scene15Narration"

    var id: String { rawValue }

    var filename: String { rawValue }

    var sceneNumber: Int? {
        let numberPart = rawValue
            .replacingOccurrences(of: "Scene", with: "")
            .replacingOccurrences(of: "Narration", with: "")
        return Int(numberPart)
    }
}
