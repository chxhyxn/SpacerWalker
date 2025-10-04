//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

@Observable
final class Scene13ViewModel {
    private(set) var isNextButton: Bool = false
    
    func showNextButton() {
        isNextButton = true
    }
}
