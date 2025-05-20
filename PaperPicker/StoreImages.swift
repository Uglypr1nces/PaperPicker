//
//  StoreImages.swift
//  PaperPicker
//
//  Created by Shpat Avdiu on 17.05.2025.
//

import Foundation
import Cocoa

import Foundation

func getStoredImages(fileURL: URL) -> [String] {
    do {
        let contents = try String(contentsOf: fileURL)
        return contents
            .split(separator: "\n")
            .map { String($0) }
            .filter { !$0.isEmpty }
    } catch {
        print("Failed to read from file: \(error)")
        return []
    }
}

func storeImages(fileURL: URL, images: [String]) -> Bool {
    let content = images.joined(separator: "\n")
    do {
        try content.write(to: fileURL, atomically: true, encoding: .utf8)
        return true
    } catch {
        print("Failed to write to file: \(error)")
        return false
    }
}
