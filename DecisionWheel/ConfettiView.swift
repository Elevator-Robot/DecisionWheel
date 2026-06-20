import SwiftUI

struct ConfettiView: View {
    @State private var trigger = false

    struct Piece: Identifiable {
        let id: Int
        let hue: Double
        let size: CGFloat
        let shapeIndex: Int
        let offsetX: CGFloat
        let offsetY: CGFloat
        let rotationDeg: Double
    }

    private let pieces: [Piece] = {
        (0..<60).map { i in
            Piece(
                id: i,
                hue: Double(i) / 60,
                size: CGFloat.random(in: 6...14),
                shapeIndex: i % 3,
                offsetX: CGFloat.random(in: -200...200),
                offsetY: CGFloat.random(in: -400...100),
                rotationDeg: .random(in: 0...720)
            )
        }
    }()

    var body: some View {
        ZStack {
            ForEach(pieces) { piece in
                ConfettiPieceView(piece: piece, trigger: trigger)
            }
        }
        .allowsHitTesting(false)
        .onAppear { trigger = true }
    }
}

private struct ConfettiPieceView: View {
    let piece: ConfettiView.Piece
    let trigger: Bool

    private var color: Color {
        Color(hue: piece.hue, saturation: 0.8, brightness: 1)
    }

    var body: some View {
        shapeView
            .offset(x: trigger ? piece.offsetX : 0, y: trigger ? piece.offsetY : -50)
            .rotationEffect(.degrees(trigger ? piece.rotationDeg : 0))
            .opacity(trigger ? 0 : 1)
            .animation(
                .easeOut(duration: 1.2 + Double(piece.id) * 0.02)
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
        default:
            RoundedRectangle(cornerRadius: 2)
                .fill(color)
                .frame(width: piece.size, height: piece.size)
        }
    }
}
