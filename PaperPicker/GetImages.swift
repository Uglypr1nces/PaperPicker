//
//  GetImages.swift
//  PaperPicker
//
//  Created by Shpat Avdiu on 17.05.2025.
//

import Foundation

let fm = FileManager.default

func getImages(path: String) -> [String] {
    var images: [String] = []

    do {
        let files = try fm.contentsOfDirectory(atPath: path)

        for file in files {
            let lowerExt = (file as NSString).pathExtension.lowercased()
            if ["png", "jpg", "jpeg"].contains(lowerExt) {
                images.append((path as NSString).appendingPathComponent(file))
            }
        }

    } catch {
        print("Failed to read contents of directory: \(error)")
    }

    return images
}



func getFileExtension(filename: String) -> String {
    if filename.split(separator: ".").count > 1 {
        return String(filename.split(separator: ".").last!)
    } else {
        return ""
    }
}
