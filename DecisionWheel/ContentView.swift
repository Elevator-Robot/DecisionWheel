import SwiftUI

struct ContentView: View {
    @State private var options: [WheelOption] = [
        WheelOption(title: "Pizza", color: wheelPalette[0]),
        WheelOption(title: "Sushi", color: wheelPalette[1]),
        WheelOption(title: "Tacos", color: wheelPalette[2]),
        WheelOption(title: "Burgers", color: wheelPalette[3]),
    ]
    @State private var showEditor = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hex: 0x0F0C29),
                    Color(hex: 0x302B63),
                    Color(hex: 0x24243E),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Decision Wheel")
                            .font(.system(size: 28, weight: .heavy))
                            .foregroundColor(.white)
                        Text("What's it gonna be?")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    Spacer()
                    Button {
                        showEditor = true
                    } label: {
                        Image(systemName: "pencil.line")
                            .font(.body.weight(.semibold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                Spacer()

                WheelView(options: options)

                Spacer()
            }
        }
        .sheet(isPresented: $showEditor) {
            OptionsEditorView(options: $options)
        }
    }
}
