import SwiftUI

struct OptionsEditorView: View {
    @Binding var options: [WheelOption]
    let palette: [Color]
    @State private var newOptionText = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(options) { option in
                    HStack {
                        Circle()
                            .fill(option.color)
                            .frame(width: 20, height: 20)
                        Text(option.title)
                    }
                }
                .onDelete { options.remove(atOffsets: $0) }

                HStack {
                    TextField("Add option", text: $newOptionText)
                    Button("Add") {
                        let trimmed = newOptionText.trimmingCharacters(in: .whitespaces)
                        guard !trimmed.isEmpty else { return }
                        options.append(WheelOption(
                            title: trimmed,
                            color: palette[options.count % palette.count]
                        ))
                        newOptionText = ""
                    }
                    .disabled(newOptionText.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .navigationTitle("Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
        }
    }
}
