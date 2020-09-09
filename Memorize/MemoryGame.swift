//
//  MemoryGame.swift
//  Memorize
//
//  Created by mk on 01.09.2020.
//

import Foundation

struct MemoryGame<CardContent> {
    var cards: Array<Card>
    
    mutating func choose(_ card: Card) {
//        print("Card chosen: \(card)")
        if let cardIndex = index(of: card) {
            cards[cardIndex].isFaceUp.toggle()
        }
//        print("Card flipped: \n\(cards)")
    }
    
    func index(of card: Card) -> Int? {
        cards.firstIndex(where: { $0.id == card.id })
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable
    {
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent
        
        var id: Int
    }
}
