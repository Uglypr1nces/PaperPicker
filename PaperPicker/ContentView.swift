//
//  ContentView.swift
//  PaperPicker
//
//  Created by Shpat Avdiu on 17.05.2025.
//

import SwiftUI
import AppKit
import Foundation


struct ContentView: View {
    @State private var images: [String] = []
    @State private var paths: [String] = []
    @State private var showFileImporter = false

    var body: some View {
        VStack {

            Button("Select Images") {
                showFileImporter = true
            }
            
            ForEach(images, id: \.self) { image in
                if let nsImage = NSImage(contentsOfFile: image) {
                    Image(nsImage: nsImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }
            }
            

        }
        .padding()
        .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.directory], onCompletion: { result in
            switch result{
            case .success(let urls):
                paths.append(urls.path)
                images = getImages(path: urls.path)
                
            case .failure(let error):
                print("Error: \(error)")
            }
                
        }
    )}
}

#Preview {
    ContentView()
}


func displayImages(){
    
}
