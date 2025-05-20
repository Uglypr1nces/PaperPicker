import SwiftUI
import AppKit

// MARK: - VisualEffectView for macOS Blur
struct VisualEffectView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = .ultraDark  // Stronger blur effect
        view.blendingMode = .behindWindow
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}

// MARK: - Main View
struct ContentView: View {
    @State private var images: [String] = []
    @State private var newImages: [String] = []
    @State private var paths: [String] = []
    @State private var showFileImporter = false
    @State private var saveFileURL: URL?

    var body: some View {
        ZStack {
            VisualEffectView() // Blurred background

            VStack(spacing: 20) {
                HStack {
                    Button("Select Save File") {
                        let panel = NSSavePanel()
                        panel.title = "Choose or Create Save File"
                        panel.nameFieldStringValue = "SavedImages.txt"
                        panel.allowedFileTypes = ["txt"]

                        if panel.runModal() == .OK, let url = panel.url {
                            saveFileURL = url

                            if !FileManager.default.fileExists(atPath: url.path) {
                                do {
                                    try "".write(to: url, atomically: true, encoding: .utf8)
                                } catch {
                                    print("Error creating file: \(error)")
                                }
                            }

                            images = getStoredImages(fileURL: url)
                        }
                    }

                    Button("Select Folder with Images") {
                        showFileImporter = true
                    }

                    Button("Load Saved Images") {
                        let panel = NSOpenPanel()
                        panel.title = "Select a saved image file"
                        panel.allowedFileTypes = ["txt"]
                        panel.canChooseFiles = true
                        panel.canChooseDirectories = false
                        panel.allowsMultipleSelection = false
                        
                        if panel.runModal() == .OK, let url = panel.url {
                            saveFileURL = url
                            images = getStoredImages(fileURL: url)
                            newImages = images
                        }
                    }

                }

                ScrollView(.horizontal) {
                    HStack {
                        ForEach(newImages, id: \.self) { imagePath in
                            Image(nsImage: NSImage(contentsOfFile: imagePath) ?? NSImage())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .cornerRadius(10)
                                .padding()
                                .onTapGesture {
                                    setDesktopWallpaper(imagePath)
                                }
                                .contextMenu {
                                    Button("Delete Image") {
                                        deleteImage(imagePath)
                                    }
                                }
                        }
                    }
                }
            }
            .padding()
        }
        .frame(minWidth: 900, minHeight: 300) // Window size hint
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.directory],
            onCompletion: { result in
                switch result {
                case .success(let url):
                    paths.append(url.path)
                    let allImages = getImages(path: url.path)
                    let newOnes = allImages.filter { !images.contains($0) }
                    newImages.append(contentsOf: newOnes)
                    images.append(contentsOf: newOnes)

                    if let fileURL = saveFileURL {
                        _ = storeImages(fileURL: fileURL, images: images)
                    }

                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        )
    }

    // MARK: - Helpers

    func deleteImage(_ imagePath: String) {
        newImages.removeAll { $0 == imagePath }
        images.removeAll { $0 == imagePath }

        if let fileURL = saveFileURL {
            _ = storeImages(fileURL: fileURL, images: images)
        }
    }

    func setDesktopWallpaper(_ imagePath: String) {
        guard let screen = NSScreen.main else { return }
        let url = URL(fileURLWithPath: imagePath)

        do {
            try NSWorkspace.shared.setDesktopImageURL(url, for: screen, options: [:])
        } catch {
            print("Failed to set wallpaper: \(error)")
        }
    }
}

