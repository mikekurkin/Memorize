//
//  ThemeManager.swift
//  Memorize
//
//  Created by Mike Kurkin on 09.09.2020.
//

import SwiftUI

struct GameTheme<Element> {
    
    let name: String
    let elements: [Element]
    let colors: [Color]?
    
    var numberOfPairsDefault = (min: 4, max: 8)
    
    // Bounds defined by reasonable number of pairs in a game and number of theme elements
    var numberOfPairsBounds: (min: Int, max: Int) {
        let defaultMin = numberOfPairsDefault.min
        let defaultMax = numberOfPairsDefault.max
        return (min(defaultMin, elements.count), min(defaultMax, elements.count + 1))
    }
    
    var fixedNumberOfPairs: Int?
    
    // Returns fixedNumberOfPairs if not nil, random amount within the set bounds otherwise.
    var numberOfPairs: Int {
        fixedNumberOfPairs ?? Int.random(in: numberOfPairsBounds.min..<numberOfPairsBounds.max)
    }
    
    var shuffledElements: [Element] {
        elements.shuffled()
    }
    
    init(elements: [Element], name: String, colors: [Color]? = nil, fixedNumberOfPairs: Int? = nil) {
        self.elements = elements
        self.name = name
        self.fixedNumberOfPairs = fixedNumberOfPairs
        self.colors = colors
    }
    
    init(_ elements: Element..., name: String, colors: [Color]? = nil, fixedNumberOfPairs: Int? = nil) {
        self.init(elements: elements, name: name, colors: colors, fixedNumberOfPairs: fixedNumberOfPairs)
    }
}

struct ThemeManager<Element> {
    var themes = [GameTheme<Element>]()

    mutating func add(_ theme: GameTheme<Element>) {
        themes.append(theme)
    }
    
    mutating func add(_ elements: Element..., name: String, colors: [Color]? = nil, fixedNumberOfPairs: Int? = nil) {
        themes.append(GameTheme<Element>(elements: elements, name: name, colors: colors, fixedNumberOfPairs: fixedNumberOfPairs))
    }
    
    func chooseRandom () -> GameTheme<Element>? {
        themes.count > 0 ? themes[Int.random(in: 0..<themes.count)] : nil
    }
}

