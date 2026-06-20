import SwiftUI

struct WheelView: View {
    let options: [WheelOption]

    @State private var rotation: Double = 0
    @State private var dragRotation: Double = 0
    @State private var isSpinning = false
    @State private var winner: WheelOption?
    @State private var showConfetti = false

    var body: some View {
        GeometryReader { proxy in
            let wheelSize = max(
                170,
                min(proxy.size.width - 32, (proxy.size.height - 150) * 0.86, 390)
            )
            let stackSpacing = max(12, min(22, wheelSize * 0.06))

            VStack(spacing: stackSpacing) {
                wheel(size: wheelSize)
                    .frame(height: wheelSize * 1.12)

                resultView

                Button {
                    spin()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "bolt.fill")
                            .font(.title3.weight(.semibold))
                            .rotationEffect(.degrees(isSpinning ? 18 : 0))
                        Text(isSpinning ? "Spinning..." : "Spin the Wheel")
                            .font(.title3.weight(.bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: 0xFF4D8D), Color(hex: 0xFF8A5C), Color(hex: 0xFFD93D)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .clipShape(Capsule())
                        .shadow(color: Color(hex: 0xFF6B6B).opacity(0.5), radius: 14, y: 6)
                    )
                    .scaleEffect(isSpinning ? 0.97 : 1)
                }
                .disabled(isSpinning || options.count < 2)
                .padding(.horizontal, 32)
                .animation(.spring(response: 0.3), value: isSpinning)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .overlay {
                if showConfetti {
                    ConfettiView()
                }
            }
        }
    }

    private var segmentArc: Double {
        360.0 / Double(max(options.count, 1))
    }

    private var displayRotation: Double {
        rotation + dragRotation
    }

    @ViewBuilder
    private var resultView: some View {
        if let winner {
            Text(winner.title)
                .font(.system(size: 34, weight: .heavy))
                .lineLimit(1)
                .minimumScaleFactor(0.55)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [winner.color, winner.color.opacity(0.75), .white.opacity(0.22)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: winner.color.opacity(0.65), radius: 16)
                )
                .transition(.scale(scale: 0.3).combined(with: .opacity))
        } else {
            Text(options.count < 2 ? "Add at least two options" : "Ready when you are")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white.opacity(0.6))
        }
    }

    private func wheel(size: CGFloat) -> some View {
        ZStack {
            Circle()
                .stroke(
                    AngularGradient(colors: wheelPalette + [wheelPalette[0]], center: .center),
                    lineWidth: max(8, size * 0.035)
                )
                .blur(radius: isSpinning ? 8 : 3)
                .opacity(isSpinning ? 0.95 : 0.55)
                .rotationEffect(.degrees(displayRotation * 0.4))

            Circle()
                .fill(.ultraThinMaterial)
                .overlay(
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.white.opacity(0.18), .clear],
                                center: .topLeading,
                                startRadius: 0,
                                endRadius: size * 0.65
                            )
                        )
                )

            Circle()
                .stroke(Color.white.opacity(0.18), lineWidth: 1)
                .padding(size * 0.035)

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
                        .fill(
                            RadialGradient(
                                colors: [.white.opacity(0.26), .clear, .black.opacity(0.16)],
                                center: .topLeading,
                                startRadius: 0,
                                endRadius: size * 0.55
                            )
                        )
                    )
                    .overlay(
                        SegmentShape(
                            startAngle: segmentArc * Double(i),
                            endAngle: segmentArc * Double(i + 1)
                        )
                        .stroke(Color.white.opacity(0.35), lineWidth: 0.75)
                    )
                }
            }
            .padding(size * 0.055)
            .rotationEffect(.degrees(displayRotation))
            .scaleEffect(isSpinning ? 1.02 : 1)
            .shadow(color: .black.opacity(0.35), radius: 16, y: 6)

            Circle()
                .fill(.white)
                .overlay(
                    Circle()
                        .fill(AngularGradient(colors: wheelPalette + [wheelPalette[0]], center: .center))
                        .padding(size * 0.026)
                )
                .frame(width: size * 0.12, height: size * 0.12)
                .shadow(color: .black.opacity(0.25), radius: 5)

            ForEach(0..<32, id: \.self) { i in
                let isMajor = i % 4 == 0
                RoundedRectangle(cornerRadius: 1.5)
                    .fill(Color.white.opacity(isMajor ? 0.65 : 0.28))
                    .frame(width: isMajor ? 3 : 1.5, height: isMajor ? size * 0.038 : size * 0.025)
                    .offset(y: -(size * 0.49))
                    .rotationEffect(.degrees(Double(i) * 11.25))
            }

            VStack(spacing: 0) {
                Image(systemName: "chevron.compact.down")
                    .font(.system(size: size * 0.055, weight: .black))
                Image(systemName: "chevron.down")
                    .font(.system(size: size * 0.07, weight: .black))
            }
            .foregroundStyle(
                LinearGradient(
                    colors: [Color(hex: 0xFFD93D), Color(hex: 0xFF4D8D)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .shadow(color: .black.opacity(0.35), radius: 4)
            .offset(y: -(size * 0.545))
        }
        .frame(width: size, height: size)
        .contentShape(Circle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    guard !isSpinning else { return }
                    dragRotation = Double(value.translation.width) * 0.35
                }
                .onEnded { value in
                    guard !isSpinning else { return }
                    let distance = hypot(value.translation.width, value.translation.height)
                    let predictedMomentum = Double(value.predictedEndTranslation.width - value.translation.width) * 0.25
                    if distance < 10 {
                        spin()
                    } else {
                        rotation += dragRotation
                        dragRotation = 0
                        spin(extraMomentum: predictedMomentum)
                    }
                }
        )
        .animation(.spring(response: 0.32, dampingFraction: 0.72), value: dragRotation)
    }

    private func spin(extraMomentum: Double = 0) {
        guard !isSpinning, options.count >= 2 else { return }

        isSpinning = true
        showConfetti = false
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) { winner = nil }

        let fullSpins = Double(Int.random(in: 6...12)) * 360
        let randomOffset = Double.random(in: 0...360)
        let target = rotation + dragRotation + fullSpins + randomOffset + extraMomentum
        dragRotation = 0

        withAnimation(.interpolatingSpring(stiffness: 18, damping: 7)) {
            rotation = target
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.8) {
            guard !options.isEmpty else { return }
            let normalized = rotation.truncatingRemainder(dividingBy: 360)
            let pointerAngle = (360 - normalized).truncatingRemainder(dividingBy: 360)
            let index = Int(pointerAngle / segmentArc) % options.count
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                winner = options[index]
            }
            showConfetti = true
            isSpinning = false
        }
    }
}
