//
//  MemorizeApp.swift
//  Memorize
//
//  Created by mk on 01.09.2020.
//

import SwiftUI

@main
struct MemoizeApp: App {
    var body: some Scene {
        WindowGroup {
            let game = EmojiMemoryGame()
            ContentView(viewModel: game)
        }
    }
}
