//
//  MemoryGame.swift
//  Memorize
//
//  Created by mk on 01.09.2020.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    var cards: [Card]
    
    var score = 0
    let scoreReward  = +2
    let scorePenalty = -1
    
    var theOnlyFaceUpCardIndex: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.only }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func choose(_ card: Card) {
        guard let chosenIndex = cards.firstIndex(matching: card),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched else {
            return
        }
        
        guard let matchingIndex = theOnlyFaceUpCardIndex else {
            theOnlyFaceUpCardIndex = chosenIndex
            return
        }
        
        if cards[chosenIndex].content == cards[matchingIndex].content {
            cards[chosenIndex].isMatched = true
            cards[matchingIndex].isMatched = true
            score += scoreReward
        } else {
            score += ((cards[matchingIndex].hasBeenShown ? 1 : 0) + (cards[chosenIndex].hasBeenShown ? 1 : 0)) * scorePenalty
        }
        cards[chosenIndex].isFaceUp = true
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = [Card]()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable
    {
        var isFaceUp: Bool = false {
            willSet {
                if isFaceUp && !newValue {
                    hasBeenShown = true
                }
            }
        }
        var isMatched: Bool = false
        var hasBeenShown: Bool = false
        var content: CardContent
        
        var id: Int
    }
}
