//
//  ContentView.swift
//  PaperPicker
//
//  Created by Shpat Avdiu on 17.05.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var paths: [String] = []
    @State private var showFileImporter = false

    var body: some View {
        VStack {

            Button("Select Images") {
                showFileImporter = true
            }
            
            Button("Test"){
                print(getImages(path: "/Users/uglyprincess/Pictures/Wallpaper"))
            }

            if !paths.isEmpty {
                Text(paths.joined(separator: "\n"))
            }
        }
        .padding()
        .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.directory], onCompletion: { result in
            switch result{
            case .success(let urls):
                print(getImages(path: urls.absoluteString))
                
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
