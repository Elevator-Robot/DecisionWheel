import SwiftUI

struct ConfettiView: View {
    @State private var trigger = false

    struct Piece: Identifiable {
        let id: Int
        let hue: Double
        let size: CGFloat
        let shapeIndex: Int
        let xMultiplier: CGFloat
        let yMultiplier: CGFloat
        let rotationDeg: Double
        let delay: Double
    }

    private let pieces: [Piece] = {
        (0..<96).map { i in
            Piece(
                id: i,
                hue: Double(i) / 60,
                size: CGFloat.random(in: 5...18),
                shapeIndex: i % 4,
                xMultiplier: CGFloat.random(in: -0.52...0.52),
                yMultiplier: CGFloat.random(in: -0.72...0.18),
                rotationDeg: .random(in: 180...980),
                delay: Double.random(in: 0...0.16)
            )
        }
    }()

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(pieces) { piece in
                    ConfettiPieceView(
                        piece: piece,
                        trigger: trigger,
                        burstSize: proxy.size
                    )
                }
            }
        }
        .allowsHitTesting(false)
        .onAppear { trigger = true }
    }
}

private struct ConfettiPieceView: View {
    let piece: ConfettiView.Piece
    let trigger: Bool
    let burstSize: CGSize

    private var color: Color {
        Color(hue: piece.hue, saturation: 0.9, brightness: 1)
    }

    var body: some View {
        shapeView
            .scaleEffect(trigger ? 0.35 : 1.2)
            .offset(x: trigger ? piece.xMultiplier * burstSize.width : 0,
                    y: trigger ? piece.yMultiplier * burstSize.height : -40)
            .rotationEffect(.degrees(trigger ? piece.rotationDeg : 0))
            .opacity(trigger ? 0 : 1)
            .animation(
                .spring(response: 0.85, dampingFraction: 0.74)
                .delay(piece.delay)
                .repeatCount(1, autoreverses: false),
                value: trigger
            )
    }

    @ViewBuilder
    private var shapeView: some View {
        switch piece.shapeIndex {
        case 0:
            Circle()
                .fill(color)
                .frame(width: piece.size, height: piece.size)
        case 1:
            Rectangle()
                .fill(color)
                .frame(width: piece.size, height: piece.size)
        case 2:
            RoundedRectangle(cornerRadius: 2)
                .fill(color)
                .frame(width: piece.size * 0.7, height: piece.size * 1.8)
        default:
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [color, .white.opacity(0.8)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: piece.size, height: piece.size)
        }
    }
}
