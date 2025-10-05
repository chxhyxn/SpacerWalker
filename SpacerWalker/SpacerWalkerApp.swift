//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI
import UIKit

@main
struct SpacerWalkerApp: App {
    var body: some Scene {
        WindowGroup {
            Scene3View(path: .constant([.story]))
                .preferredColorScheme(.light)
        }
    }
}
