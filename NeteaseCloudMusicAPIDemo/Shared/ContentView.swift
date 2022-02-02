//
//  ContentView.swift
//  Shared
//
//  Created by teenloong on 2022/2/2.
//

import SwiftUI
import NeteaseCloudMusicAPI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear {
                test()
            }
    }
    
    func test() {
        NCM.requestHttpHeader
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
