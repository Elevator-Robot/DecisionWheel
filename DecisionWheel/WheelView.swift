import SwiftUI

struct WheelView: View {
    let options: [WheelOption]

    @State private var rotation: Double = 0
    @State private var isSpinning = false
    @State private var winner: WheelOption?

    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                ForEach(options.indices, id: \.self) { i in
                    SegmentShape(
                        startAngle: segmentArc * Double(i),
                        endAngle: segmentArc * Double(i + 1)
                    )
                    .fill(options[i].color)
                }
                .rotationEffect(.degrees(rotation))

                Circle()
                    .fill(.white)
                    .frame(width: 50, height: 50)

                Image(systemName: "chevron.down")
                    .font(.title.weight(.heavy))
                    .offset(y: -155)
                    .foregroundStyle(.primary)
            }
            .frame(width: 300, height: 300)

            if let winner {
                Text(winner.title)
                    .font(.system(size: 32, weight: .bold))
                    .transition(.scale.combined(with: .opacity))
            }

            Button {
                spin()
            } label: {
                Label(isSpinning ? "Spinning..." : "Spin", systemImage: "arrow.triangle.2.circlepath")
                    .font(.title2.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .disabled(isSpinning || options.count < 2)
            .tint(.primary)
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 40)
        }
    }

    private var segmentArc: Double {
        360.0 / Double(max(options.count, 1))
    }

    private func spin() {
        isSpinning = true
        withAnimation(.default) { winner = nil }

        let fullSpins = Double(Int.random(in: 5...10)) * 360
        let randomOffset = Double.random(in: 0...360)
        let target = rotation + fullSpins + randomOffset

        withAnimation(.easeOut(duration: 3.5)) {
            rotation = target
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            let normalized = rotation.truncatingRemainder(dividingBy: 360)
            let pointerAngle = (360 - normalized).truncatingRemainder(dividingBy: 360)
            let index = Int(pointerAngle / segmentArc) % options.count
            withAnimation { winner = options[index] }
            isSpinning = false
        }
    }
}
