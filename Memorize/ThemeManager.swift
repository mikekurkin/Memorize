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
    
    private var desiredNumberOfPairs = (min: 4, max: 8)
    
    // Bounds defined by desired number of pairs in a game and number of theme elements
    private var numberOfPairsBounds: (min: Int, max: Int) {
        return (min(desiredNumberOfPairs.min, elements.count), min(desiredNumberOfPairs.max, elements.count))
    }
    
    // Returns random amount within the set bounds
    var numberOfPairs: Int {
        Int.random(in: numberOfPairsBounds.min...numberOfPairsBounds.max)
    }
    
    var shuffledElements: [Element] {
        elements.shuffled()
    }
    
    init(elements: [Element], name: String, colors: [Color]? = nil, desiredNumberOfPairs: (min: Int, max: Int)? = nil) {
        self.elements = elements
        self.name = name
        self.colors = colors
        if let desiredNumberOfPairs = desiredNumberOfPairs {
            self.desiredNumberOfPairs = desiredNumberOfPairs
        }
    }
    
    init(elements: [Element], name: String, colors: [Color]? = nil, fixedNumberOfPairs: Int?) {
        let desiredNumberOfPairs = fixedNumberOfPairs != nil ? (fixedNumberOfPairs!, fixedNumberOfPairs!) : nil
        self.init(elements: elements, name: name, colors: colors, desiredNumberOfPairs: desiredNumberOfPairs)
    }
    
    init(_ elements: Element..., name: String, colors: [Color]? = nil, desiredNumberOfPairs: (min: Int, max: Int)? = nil) {
        self.init(elements: elements, name: name, colors: colors, desiredNumberOfPairs: desiredNumberOfPairs)
    }
    
    init(_ elements: Element..., name: String, colors: [Color]? = nil, fixedNumberOfPairs: Int?) {
        self.init(elements: elements, name: name, colors: colors, fixedNumberOfPairs: fixedNumberOfPairs)
    }
}

struct ThemeManager<Element> {
    private(set) var themes = [GameTheme<Element>]()

    mutating func add(_ theme: GameTheme<Element>) {
        themes.append(theme)
    }
    
    mutating func add(_ elements: Element..., name: String, colors: [Color]? = nil, desiredNumberOfPairs: (min: Int, max: Int)? = nil) {
        themes.append(GameTheme<Element>(elements: elements, name: name, colors: colors, desiredNumberOfPairs: desiredNumberOfPairs))
    }
    
    mutating func add(_ elements: Element..., name: String, colors: [Color]? = nil, fixedNumberOfPairs: Int?) {
        themes.append(GameTheme<Element>(elements: elements, name: name, colors: colors, fixedNumberOfPairs: fixedNumberOfPairs))
    }
    
    func chooseRandom () -> GameTheme<Element>? {
        themes.count > 0 ? themes[Int.random(in: 0..<themes.count)] : nil
    }
}

