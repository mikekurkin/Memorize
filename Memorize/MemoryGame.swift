//
//  MemoryGame.swift
//  Memorize
//
//  Created by mk on 01.09.2020.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: [Card]
    
    private(set) var score = 0
    
    private let scoreReward  = +2
    private let scorePenalty = -1
    
    private var theOnlyFaceUpCardIndex: Int? {
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
        
        cards[chosenIndex].isFaceUp = true
        
        if cards[chosenIndex].content == cards[matchingIndex].content {
            cards[chosenIndex].isMatched = true
            cards[matchingIndex].isMatched = true
            score += scoreReward
        } else {
            score += ((cards[matchingIndex].hasBeenShown ? 1 : 0) + (cards[chosenIndex].hasBeenShown ? 1 : 0)) * scorePenalty
        }
        
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
            didSet {
                if isFaceUp && !oldValue {
                    startUsingBonusTime()
                } else if !isFaceUp && oldValue {
                    stopUsingBonusTime()
                    hasBeenShown = true
                }
            }
        }
        
        var isMatched: Bool = false {
            didSet {
                if isMatched && !oldValue {
                    stopUsingBonusTime()
                }
            }
        }
        
        var hasBeenShown: Bool = false
        var content: CardContent
        
        var id: Int
        
        // MARK: - Bonus Time
        
        // This could give matching bonus points
        // if the user matches the card before
        // a certain amount of time passes
        // during which the card is face up
        
        // Can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // How long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // The last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        
        // The accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // How much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // Percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
        }
        
        // Whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        // Whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // Called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // Called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
        
    }
}
