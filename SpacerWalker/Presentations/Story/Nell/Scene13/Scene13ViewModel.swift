//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

@Observable
final class Scene13ViewModel {
    var counter: Int = 0
    
    func add() {
        print("Hi")
        counter += 1
    }
}
