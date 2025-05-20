//
//  GetImages.swift
//  PaperPicker
//
//  Created by Shpat Avdiu on 17.05.2025.
//

import Foundation

func getImages(path: String) -> [String] {
    let imageExtensions = ["jpg", "jpeg", "png", "heic", "webp"]
    let fileManager = FileManager.default

    do {
        let files = try fileManager.contentsOfDirectory(atPath: path)
        let fullPaths = files
            .filter { file in
                let ext = URL(fileURLWithPath: file).pathExtension.lowercased()
                return imageExtensions.contains(ext)
            }
            .map { "\(path)/\($0)" }

        return fullPaths
    } catch {
        print("Error reading folder: \(error)")
        return []
    }
}

