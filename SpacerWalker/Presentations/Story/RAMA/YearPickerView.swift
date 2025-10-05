//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct YearPickerView: View {
    @Binding var value: Double
    @Binding var dragOffset: CGFloat

    private let years = Array(2015 ... 2026)
    private let itemHeight: CGFloat = 100

    var body: some View {
        GeometryReader { geo in
            let rawValue = value + Double(dragOffset / geo.size.width * 100)
            let currentValue = min(max(rawValue, 0), 100)

            VStack {
                ZStack {
                    VStack(spacing: 25) {
                        ForEach(years, id: \.self) { year in
                            Text(String(year))
                                .font(.oneMobile60)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(height: itemHeight)
                        }
                    }
                    .offset(y: calculateOffset(value: currentValue))

                    VStack {
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: .black, location: 0.0),
                                .init(color: .clear, location: 0.5),
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }

                    VStack {
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: .black, location: 0.0),
                                .init(color: .clear, location: 0.5),
                            ]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    }
                }
            }
            .frame(height: itemHeight * 3)
            .clipped()
        }
    }

    private func calculateOffset(value: Double) -> CGFloat {
        let spacing: CGFloat = 25
        let itemTotalHeight = itemHeight + spacing
        let totalItems = years.count

        let totalScrollHeight = itemTotalHeight * CGFloat(totalItems - 1)
        let scrollProgress = value / 100
        let currentYOffset = -totalScrollHeight * scrollProgress
        let correction = (CGFloat(totalItems) / 2 - 0.5) * itemTotalHeight

        return currentYOffset + correction
    }
}
