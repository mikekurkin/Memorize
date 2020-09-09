//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by mk on 01.09.2020.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var game = EmojiMemoryGame.createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        let emojis: [String] = ["👻", "😁", "👽", "👹", "👾", "👀", "🐭", "🐙", "🍄", "🌧", "🌞", "🌚"].shuffled()
        let pairsCount = Int.random(in: 2...8)
        
        return MemoryGame<String>(numberOfPairsOfCards: pairsCount) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    
    // MARK: - Access to the Model
    
    var cards: [MemoryGame<String>.Card] {
        game.cards
    }
    
    // MARK: - Intents
    
    func choose(_ card: MemoryGame<String>.Card) {
//        objectWillChange.send()
        game.choose(card)
    }
    
    
}

struct EmojiMemoryGame_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
