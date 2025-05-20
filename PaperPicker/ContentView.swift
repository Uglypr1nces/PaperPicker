import SwiftUI
import AppKit

struct ContentView: View {
    @State private var images: [String] = []
    @State private var newImages: [String] = []
    @State private var paths: [String] = []
    @State private var showFileImporter = false
    @State private var saveFileURL: URL?

    var body: some View {
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
                
                Button("Load Save File") {
                    let panel = NSOpenPanel()
                    panel.title = "Select Save File"
                    panel.allowedFileTypes = ["txt"]
                    panel.allowsMultipleSelection = false

                    if panel.runModal() == .OK, let url = panel.url {
                        saveFileURL = url
                        images = getStoredImages(fileURL: url)
                        newImages = images // display them
                    }
                }
            }

            ScrollView {
                VStack {
                    ForEach(newImages, id: \.self) { imagePath in
                        Image(nsImage: NSImage(contentsOfFile: imagePath) ?? NSImage())
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .padding()
                    }
                }
            }
        }
        .padding()
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.directory],
            onCompletion: { result in
                switch result {
                case .success(let url):
                    paths.append(url.path)
                    let foundImages = getImages(path: url.path)

                    let newOnes = foundImages.filter { !images.contains($0) }
                    images.append(contentsOf: newOnes)
                    newImages = newOnes

                    if let fileURL = saveFileURL {
                        _ = storeImages(fileURL: fileURL, images: images)
                    }

                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        )
    }
}
