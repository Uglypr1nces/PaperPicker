//
//  StoreImages.swift
//  PaperPicker
//
//  Created by Shpat Avdiu on 17.05.2025.
//

import Foundation
import Cocoa

import Foundation

func storeImages(fileURL: URL, images: [String]) -> Bool {
    do {
        let text = images.joined(separator: "\n")
        try text.write(to: fileURL, atomically: true, encoding: .utf8)
        return true
    } catch {
        print("Error writing to file: \(error)")
        return false
    }
}

func getStoredImages(fileURL: URL) -> [String] {
    do {
        let content = try String(contentsOf: fileURL, encoding: .utf8)
        let imagePaths = content.components(separatedBy: .newlines).filter { !$0.isEmpty }
        return imagePaths
    } catch {
        print("Error reading file: \(error)")
        return []
    }
}
