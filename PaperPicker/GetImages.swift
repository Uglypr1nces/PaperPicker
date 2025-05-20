//
//  GetImages.swift
//  PaperPicker
//
//  Created by Shpat Avdiu on 17.05.2025.
//

import Foundation

func getImages(path: String) -> [String] {
    let fileManager = FileManager.default
    let allowedExtensions = ["jpg", "jpeg", "png", "heic", "bmp", "gif", "tiff"]
    var imagePaths: [String] = []

    if let items = try? fileManager.contentsOfDirectory(atPath: path) {
        for item in items {
            let fullPath = (path as NSString).appendingPathComponent(item)
            let ext = (item as NSString).pathExtension.lowercased()
            if allowedExtensions.contains(ext) {
                imagePaths.append(fullPath)
            }
        }
    }

    return imagePaths
}


