import SwiftUI

struct ConfettiView: View {
    @State private var trigger = false

    var body: some View {
        ZStack {
            ForEach(0..<60, id: \.self) { i in
                let hue = Double(i) / 60
                let size = CGFloat.random(in: 6...14)
                let shape = i % 3
                Group {
                    switch shape {
                    case 0: Circle()
                    case 1: Rectangle()
                    default: RoundedRectangle(cornerRadius: 2)
                    }
                }
                .fill(Color(hue: hue, saturation: 0.8, brightness: 1))
                .frame(width: size, height: size)
                .offset(x: trigger ? CGFloat.random(in: -200...200) : 0,
                        y: trigger ? CGFloat.random(in: -400...100) : -50)
                .rotationEffect(.degrees(trigger ? .random(in: 0...720) : 0))
                .opacity(trigger ? 0 : 1)
                .animation(
                    .easeOut(duration: 1.2)
                    .delay(Double(i) * 0.02)
                    .repeatCount(1, autoreverses: false),
                    value: trigger
                )
            }
        }
        .allowsHitTesting(false)
        .onAppear { trigger = true }
    }
}
