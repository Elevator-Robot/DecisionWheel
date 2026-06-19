import SwiftUI

struct SegmentShape: Shape {
    let startAngle: Double
    let endAngle: Double

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        return Path { path in
            path.move(to: center)
            path.addArc(
                center: center,
                radius: radius,
                startAngle: .degrees(startAngle - 90),
                endAngle: .degrees(endAngle - 90),
                clockwise: true
            )
            path.closeSubpath()
        }
    }
}
