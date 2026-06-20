import SwiftUI

struct OptionsEditorView: View {
    @Binding var options: [WheelOption]
    @State private var newOptionText = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(options) { option in
                    HStack(spacing: 14) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(option.color)
                            .frame(width: 28, height: 28)
                            .shadow(color: option.color.opacity(0.4), radius: 4)
                        Text(option.title)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(Color(hex: 0x302B63))
                    }
                    .padding(.vertical, 4)
                }
                .onDelete { options.remove(atOffsets: $0) }
                .onMove { options.move(fromOffsets: $0, toOffset: $1) }

                VStack(spacing: 0) {
                    HStack(spacing: 12) {
                        TextField("Add an option", text: $newOptionText)
                            .textFieldStyle(.plain)
                            .font(.system(size: 17))
                        Button {
                            let trimmed = newOptionText.trimmingCharacters(in: .whitespaces)
                            guard !trimmed.isEmpty else { return }
                            withAnimation {
                                options.append(WheelOption(
                                    title: trimmed,
                                    color: wheelPalette[options.count % wheelPalette.count]
                                ))
                            }
                            newOptionText = ""
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(Color(hex: 0x4ECDC4))
                        }
                        .disabled(newOptionText.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                    .padding(.vertical, 8)
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(
                LinearGradient(
                    colors: [Color(hex: 0xF8F9FF), Color(hex: 0xE8ECF8)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationTitle("Options")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .font(.body.weight(.semibold))
                            .foregroundColor(Color(hex: 0x4ECDC4))
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                        .tint(Color(hex: 0x4ECDC4))
                }
            }
        }
    }
}
