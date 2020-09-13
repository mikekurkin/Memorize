//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by mk on 01.09.2020.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var game = EmojiMemoryGame.createMemoryGame()
    
    private static func createMemoryGame() -> (model: MemoryGame<String>, theme: GameTheme<String>) {
        
        var themes = ThemeManager<String>()
        
        // MARK: Themes declaration
        
        themes.add("👻", "🎃", "👿", "👹", "💀", "🤖", "🍬",
                   name: "Halloween",
                   colors: [.orange])
        themes.add("🐶", "🐙", "🐱", "🐭", "🦊", "🐷", "🐨", "🐻", "🐼", "🐹", "🙈", "🐸",
                   name: "Animals",
                   colors: [.green, .blue])
        themes.add("🌧", "🌞", "❄️", "⛅️", "💨", "☔️", "⚡️",
                   name: "Weather",
                   colors: [.gray],
                   desiredNumberOfPairs: (min: 4, max: 6))
        themes.add("☄️", "🌝", "🌚", "🌜", "✨", "🌎", "🪐",
                   name: "Space",
                   colors: [.purple, .blue],
                   fixedNumberOfPairs: 6)
        themes.add("🍩", "🍕", "🧀", "🥨", "🍆", "🍉", "🥩", "🍟",
                   name: "Food",
                   colors: [.yellow, .red])
        themes.add("🥎", "🎾", "🏐", "🏉", "🎱", "🪀", "⚽️", "🧶",
                   name: "Balls",
                   colors: [])
        themes.add("🏴‍☠️", "🇷🇺", "🇬🇧", "🇺🇸", "🇲🇰", "🇭🇰", "🇨🇳", "🇻🇳", "🇳🇵",
                   name: "Flags",
                   colors: [.red])
        themes.add("🥎", "🎾", "🏐", "🏉",
                   name: "4 Balls")
        
        let chosenTheme = themes.chooseRandom()!
        
        return (MemoryGame<String>(numberOfPairsOfCards: chosenTheme.numberOfPairs) { pairIndex in
            chosenTheme.shuffledElements[pairIndex]
        }, chosenTheme)
    }
    
    // MARK: - Access to the Theme
    
    var colors: [Color] {
        if game.theme.colors?.isEmpty ?? true {
            return [.accentColor]
        } else {
            return game.theme.colors!
        }
    }
    
    var name: String {
        game.theme.name
    }
    
    // MARK: - Access to the Model
    
    var cards: [MemoryGame<String>.Card] {
        game.model.cards
    }
    
    var score: Int {
        game.model.score
    }
    
    // MARK: - Intents
    
    func choose(_ card: MemoryGame<String>.Card) {
        game.model.choose(card)
    }
    
    func newGame() {
        game = EmojiMemoryGame.createMemoryGame()
    }
    
}

