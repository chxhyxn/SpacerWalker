//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct StoryView: View {
    @Binding var path: [Route]

    var body: some View {
        Scene14View(path: $path)
    }
}
