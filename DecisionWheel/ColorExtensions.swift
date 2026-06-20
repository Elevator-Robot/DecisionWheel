import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: alpha
        )
    }
}

let wheelPalette: [Color] = [
    Color(hex: 0xFF6B6B),
    Color(hex: 0x4ECDC4),
    Color(hex: 0xFFD93D),
    Color(hex: 0x6BCB77),
    Color(hex: 0x4D96FF),
    Color(hex: 0x9B59B6),
    Color(hex: 0xFF8A5C),
    Color(hex: 0x00B4D8),
]
