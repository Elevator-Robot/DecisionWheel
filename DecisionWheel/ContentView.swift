import SwiftUI

struct ContentView: View {
    @State private var options: [WheelOption] = [
        WheelOption(title: "Pizza", color: .red),
        WheelOption(title: "Sushi", color: .orange),
        WheelOption(title: "Tacos", color: .yellow),
        WheelOption(title: "Burgers", color: .green),
    ]
    @State private var showEditor = false

    private let palette: [Color] = [
        .red, .orange, .yellow, .green, .blue, .purple, .pink, .teal
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Decision Wheel")
                    .font(.title.weight(.bold))
                Spacer()
                Button {
                    showEditor = true
                } label: {
                    Image(systemName: "pencil")
                        .font(.title3)
                }
                .disabled(options.count < 2 && !showEditor)
            }
            .padding()

            Spacer()

            WheelView(options: options)

            Spacer()
        }
        .sheet(isPresented: $showEditor) {
            OptionsEditorView(options: $options, palette: palette)
        }
    }
}
