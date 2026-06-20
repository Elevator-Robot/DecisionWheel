import SwiftUI

struct ContentView: View {
    @State private var options: [WheelOption] = [
        WheelOption(title: "Pizza", color: wheelPalette[0]),
        WheelOption(title: "Sushi", color: wheelPalette[1]),
        WheelOption(title: "Tacos", color: wheelPalette[2]),
        WheelOption(title: "Burgers", color: wheelPalette[3]),
    ]
    @State private var showEditor = false
    @State private var animateBackground = false

    var body: some View {
        ZStack(alignment: .top) {
            backgroundView
                .ignoresSafeArea()

            GeometryReader { proxy in
                VStack(spacing: 12) {
                    headerView
                        .padding(.horizontal, 24)
                        .padding(.top, proxy.safeAreaInsets.top + 16)
                        .frame(maxWidth: .infinity)

                    WheelView(options: options)
                        .frame(
                            width: proxy.size.width,
                            height: max(280, proxy.size.height - proxy.safeAreaInsets.top - proxy.safeAreaInsets.bottom - 96)
                        )
                        .padding(.bottom, proxy.safeAreaInsets.bottom + 12)
                }
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .top)
                .ignoresSafeArea(.container, edges: .bottom)
            }
        }
        .sheet(isPresented: $showEditor) {
            OptionsEditorView(options: $options)
        }
    }

    private var headerView: some View {
        ZStack {
            VStack(spacing: 4) {
                Text("Decision Wheel")
                    .font(.system(size: 28, weight: .heavy))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                Text("What's it gonna be?")
                    .font(.system(size: 16, weight: .medium))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.5))
            }

            Button {
                showEditor = true
            } label: {
                Image(systemName: "pencil.line")
                    .font(.body.weight(.semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.28), lineWidth: 1)
                            )
                    )
                    .clipShape(Circle())
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    private var backgroundView: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hex: 0x11152F),
                    Color(hex: 0x241E5B),
                    Color(hex: 0x11152F),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: 0xFF4D8D).opacity(0.55), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 260
                    )
                )
                .frame(width: 520, height: 520)
                .offset(x: animateBackground ? -170 : -80, y: animateBackground ? -300 : -210)

            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: 0x4D96FF).opacity(0.5), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 300
                    )
                )
                .frame(width: 600, height: 600)
                .offset(x: animateBackground ? 180 : 90, y: animateBackground ? 230 : 320)

            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: 0xFFD93D).opacity(0.18), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 220
                    )
                )
                .frame(width: 440, height: 440)
                .offset(x: animateBackground ? 150 : 230, y: animateBackground ? -110 : -40)

            Color.black.opacity(0.24)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 7).repeatForever(autoreverses: true)) {
                animateBackground = true
            }
        }
    }
}
