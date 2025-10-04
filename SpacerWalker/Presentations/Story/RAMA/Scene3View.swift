//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct Scene3View: View {
    @Binding var path: [Route]
    
    @State private var value: Double = 0
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        ZStack {
            GeometryReader { geo in
                let rawValue = value + Double(dragOffset / geo.size.width * 100)
                let currentValue = min(max(rawValue, 0), 100)
                
                let arcCenter = CGPoint(x: geo.size.width / 2, y: geo.size.height)
                let arcRadius = geo.size.width / 2
                let angle = Angle.degrees((currentValue / 100 * 22) * 180 - 180)
                
                let circleX = arcCenter.x + arcRadius * cos(angle.radians)
                let circleY = arcCenter.y + arcRadius * sin(angle.radians)
                
                let minImageSize: CGFloat = 70
                let maxImageSize: CGFloat = 250
                let currentImageSize = minImageSize + (maxImageSize - minImageSize) * (currentValue / 100)

                let opacity2 = min(max((currentValue - 25) / 33, 0), 1)
                let opacity3 = min(max((currentValue - 50) / 33, 0), 1)
                let opacity4 = min(max((currentValue - 75) / 33, 0), 1)

                ZStack {
                    Path { path in
                        path.addArc(center: arcCenter, radius: arcRadius, startAngle: .degrees(0), endAngle: .degrees(180), clockwise: true)
                    }.stroke(Color.gray, lineWidth: 2)
                    
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.cyan)
                        .shadow(color: .cyan, radius: 10)
                        .position(x: circleX, y: circleY)
                    
                    ZStack {
                        Image("sunWithSpot1")
                        Image("sunWithSpot2").opacity(opacity2)
                        Image("sunWithSpot3").opacity(opacity3)
                    }
                    .position(x: geo.size.width / 2, y: geo.size.height)
                    
                    Image("sunWithSpot4").opacity(opacity4)
                        .position(x: geo.size.width / 2 - 14, y: geo.size.height)
                    
                    HStack(spacing: 100) {
                        Group {
                            Image(systemName: "person.fill").resizable()
                            Image(systemName: "person.fill").resizable()
                            Image(systemName: "person.fill").resizable()
                        }
                        .scaledToFit()
                        .foregroundStyle(Color.white)
                        .frame(width: currentImageSize)
                    }.position(x: geo.size.width / 2, y: geo.size.height - 200)
                    
                    if currentValue >= 100 {
                        NextButton(destination: Scene4View(path: $path))
                            .position(x: geo.size.width - 60, y: geo.size.height / 2)
                    }
                }
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { gestureValue in
                            self.dragOffset = gestureValue.translation.width
                        }
                        .onEnded { _ in
                            var newValue = self.value + Double(self.dragOffset / geo.size.width * 100)
                            newValue = min(max(newValue, 0), 100)
                            self.value = newValue
                            
                            self.dragOffset = 0
                        }
                )
            }
        }
        .background(Color.black.opacity(0.9))
        .ignoresSafeArea()
    }
}

#Preview {
    Scene3View(path: .constant([.story]))
}
