//
//  Cardify.swift
//  Memorize
//
//  Created by Mike Kurkin on 13.09.2020.
//

import SwiftUI

struct Cardify<BackContent>: ViewModifier where BackContent: View {
    var isFaceUp: Bool
    var cardBack: BackContent
    
    func body(content: Content) -> some View {
        ZStack {
            if isFaceUp {
                RoundedRectangle(cornerRadius: cardCornerRadius, style: cardCornerStyle)
                    .fill()
                    .foregroundColor(cardBackgroundColor)
                content
                RoundedRectangle(cornerRadius: cardCornerRadius, style: cardCornerStyle)
                    .strokeBorder(lineWidth: cardStrokeLineWidth)
            } else {
                cardBack
                    .clipShape(RoundedRectangle(cornerRadius: cardCornerRadius, style: cardCornerStyle))
            }
        }
    }
    
    // MARK: - Drawing Constants
    
    private let cardCornerRadius: CGFloat = 14.0
    private let cardCornerStyle: RoundedCornerStyle = .continuous
    private let cardBackgroundColor: Color = .white
    private let cardStrokeLineWidth: CGFloat = 3.0
}

extension View {
    func cardify<BackContent>(isFaceUp: Bool, cardBack: BackContent) -> some View where BackContent: View {
        self.modifier(Cardify(isFaceUp: isFaceUp, cardBack: cardBack))
    }
}
