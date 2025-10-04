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

                let opacity2 = min(max((currentValue - 25) / 33, 0), 1)
                let opacity3 = min(max((currentValue - 50) / 33, 0), 1)
                let opacity4 = min(max((currentValue - 75) / 33, 0), 1)

                ZStack {
                    Image("spaceBackground")
                    
                    YearPickerView(value: $value, dragOffset: $dragOffset)
                    
                    Path { path in
                        path.addArc(
                            center: arcCenter,
                            radius: arcRadius,
                            startAngle: .degrees(0),
                            endAngle: .degrees(180),
                            clockwise: true
                        )
                    }.stroke(Color.gray, lineWidth: 2)
                    
                    Image("earth")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.cyan)
                        .position(x: circleX, y: circleY)
                    
                    ZStack {
                        Image("sunWithSpot1")
                        Image("sunWithSpot2").opacity(opacity2)
                        Image("sunWithSpot3").opacity(opacity3)
                    }
                    .position(x: geo.size.width / 2 + 30, y: geo.size.height)
                    
                    Image("sunWithSpot4").opacity(opacity4)
                        .position(x: geo.size.width / 2 + 16, y: geo.size.height)
                    
                    Image("family").resizable()
                        .scaledToFit()
                        .foregroundStyle(Color.white)
                        .frame(width: 500)
                        .position(x: geo.size.width / 2, y: geo.size.height - 400)
                    
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
