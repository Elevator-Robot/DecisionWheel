import SwiftUI

struct WheelView: View {
    let options: [WheelOption]

    @State private var rotation: Double = 0
    @State private var isSpinning = false
    @State private var winner: WheelOption?
    @State private var showConfetti = false

    var body: some View {
        VStack(spacing: 32) {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 350, height: 350)

                Circle()
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    .frame(width: 338, height: 338)

                ZStack {
                    ForEach(options.indices, id: \.self) { i in
                        SegmentShape(
                            startAngle: segmentArc * Double(i),
                            endAngle: segmentArc * Double(i + 1)
                        )
                        .fill(options[i].color)
                        .overlay(
                            SegmentShape(
                                startAngle: segmentArc * Double(i),
                                endAngle: segmentArc * Double(i + 1)
                            )
                            .stroke(Color.white.opacity(0.25), lineWidth: 0.5)
                        )
                    }
                    .rotationEffect(.degrees(rotation))

                    Circle()
                        .fill(Color.white.opacity(0.95))
                        .frame(width: 28, height: 28)
                        .shadow(color: .black.opacity(0.2), radius: 4)
                }
                .shadow(color: .black.opacity(0.3), radius: 12, y: 4)

                // Tick marks
                ForEach(0..<20, id: \.self) { i in
                    let isMajor = i % 5 == 0
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color.white.opacity(isMajor ? 0.5 : 0.2))
                        .frame(width: isMajor ? 2.5 : 1.5, height: isMajor ? 10 : 6)
                        .offset(y: -172)
                        .rotationEffect(.degrees(Double(i) * 18))
                }

                // Pointer
                VStack(spacing: 0) {
                    Image(systemName: "chevron.compact.down")
                        .font(.system(size: 20, weight: .black))
                        .foregroundStyle(Color(hex: 0xFF6B6B))
                    Image(systemName: "chevron.down")
                        .font(.system(size: 24, weight: .black))
                        .foregroundStyle(Color(hex: 0xFF6B6B))
                }
                .shadow(color: .black.opacity(0.3), radius: 4)
                .offset(y: -188)
            }
            .frame(width: 350, height: 350)

            if let winner {
                Text(winner.title)
                    .font(.system(size: 36, weight: .heavy))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .fill(winner.color)
                            .shadow(color: winner.color.opacity(0.5), radius: 12)
                    )
                    .transition(.scale(scale: 0.3).combined(with: .opacity))
            } else {
                Text("Tap spin to decide")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }

            Button {
                spin()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.title3.weight(.semibold))
                        .rotationEffect(.degrees(isSpinning ? 360 : 0))
                    Text(isSpinning ? "Spinning..." : "Spin the Wheel")
                        .font(.title3.weight(.bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [Color(hex: 0xFF6B6B), Color(hex: 0xFF8A5C)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .clipShape(Capsule())
                    .shadow(color: Color(hex: 0xFF6B6B).opacity(0.4), radius: 8, y: 4)
                )
                .scaleEffect(isSpinning ? 0.97 : 1)
            }
            .disabled(isSpinning || options.count < 2)
            .padding(.horizontal, 32)
            .animation(.spring(response: 0.3), value: isSpinning)

            if showConfetti {
                ConfettiView()
            }
        }
    }

    private var segmentArc: Double {
        360.0 / Double(max(options.count, 1))
    }

    private func spin() {
        isSpinning = true
        showConfetti = false
        withAnimation(.spring(response: 0.4, damping: 0.6)) { winner = nil }

        let fullSpins = Double(Int.random(in: 5...10)) * 360
        let randomOffset = Double.random(in: 0...360)
        let target = rotation + fullSpins + randomOffset

        withAnimation(.interpolatingSpring(stiffness: 20, damping: 8)) {
            rotation = target
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.8) {
            let normalized = rotation.truncatingRemainder(dividingBy: 360)
            let pointerAngle = (360 - normalized).truncatingRemainder(dividingBy: 360)
            let index = Int(pointerAngle / segmentArc) % options.count
            withAnimation(.spring(response: 0.5, damping: 0.6)) {
                winner = options[index]
            }
            showConfetti = true
            isSpinning = false
        }
    }
}
