import SwiftUI

struct OptionsEditorView: View {
    @Binding var options: [WheelOption]
    @State private var newOptionText = ""
    @State private var pasteListText = ""
    @State private var showPasteList = false
    @State private var pasteListMessage = ""
    @State private var pasteListMessageColor = Color.green
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
                            pasteListText = ""
                            pasteListMessage = ""
                            showPasteList = true
                        } label: {
                            Image(systemName: "doc.on.clipboard")
                                .font(.title2)
                                .foregroundColor(Color(hex: 0x4ECDC4))
                        }
                        .accessibilityLabel("Import options")
                        Button {
                            let trimmed = newOptionText.trimmingCharacters(in: .whitespacesAndNewlines)
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
                        .disabled(newOptionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .padding(.vertical, 8)
                }
            }
            .sheet(isPresented: $showPasteList) {
                NavigationStack {
                    VStack(spacing: 16) {
                        Text("Paste one option per line")
                            .font(.system(size: 17))
                            .foregroundColor(Color(hex: 0x302B63))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ZStack(alignment: .topLeading) {
                            if pasteListText.isEmpty {
                                Text("One option per line")
                                    .foregroundColor(Color(hex: 0x302B63).opacity(0.4))
                                    .padding(EdgeInsets(top: 18, leading: 18, bottom: 0, trailing: 0))
                            }
                            TextEditor(text: $pasteListText)
                                .font(.system(size: 17))
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                                .frame(minHeight: 240)
                        }
                        Spacer()
                        Button {
                            importPasteList()
                        } label: {
                            Text("Import")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .disabled(pasteListText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .padding(.bottom, 2)

                        if !pasteListMessage.isEmpty {
                            Text(pasteListMessage)
                                .font(.footnote)
                                .foregroundColor(pasteListMessageColor)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()
                    .navigationTitle("Import Options")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done") {
                                showPasteList = false
                            }
                            .foregroundColor(Color(hex: 0x4ECDC4))
                        }
                    }
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

    private func importPasteList() {
        var seenTitles = Set(options.map { $0.title })
        let entries = pasteListText
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        let newEntries = entries.compactMap { title -> String? in
            guard !seenTitles.contains(title) else { return nil }
            seenTitles.insert(title)
            return title
        }

        guard !newEntries.isEmpty else {
            pasteListMessage = "No new options were imported."
            pasteListMessageColor = .red
            return
        }

        withAnimation {
            for title in newEntries {
                options.append(WheelOption(
                    title: title,
                    color: wheelPalette[options.count % wheelPalette.count]
                ))
            }
        }
        pasteListText = ""
        pasteListMessage = "Imported \(newEntries.count) option\(newEntries.count == 1 ? "" : "s")."
        pasteListMessageColor = .green
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            showPasteList = false
            pasteListMessage = ""
        }
    }
}
