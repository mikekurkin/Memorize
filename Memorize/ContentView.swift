//
//  ContentView.swift
//  Memorize
//
//  Created by mk on 01.09.2020.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
            HStack {
                ForEach(viewModel.cards) { card in
                    CardView(card: card)
                        .onTapGesture {
                            viewModel.choose(card)
                        }
                }
        }
            .padding()
            .foregroundColor(cardsAccentColor)
    }
    
    // MARK: - Drawing Constants
    
    let cardsAccentColor: Color = .accentColor
}

// MARK: -

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if card.isFaceUp {
                    RoundedRectangle(cornerRadius: cardCornerRadius, style: cardCornerStyle)
                        .fill()
                        .foregroundColor(cardBackgroundColor)
                    RoundedRectangle(cornerRadius: cardCornerRadius, style: cardCornerStyle)
                        .strokeBorder(lineWidth: cardStrokeLineWidth)
                    Text(card.content)
                } else {
                    RoundedRectangle(cornerRadius: cardCornerRadius, style: cardCornerStyle)
                        .fill()
                }
            }
            
                .aspectRatio(cardAspectRatio, contentMode: .fit)
            .font(.system(size: cardFontMultiplier * min(geometry.size.width, geometry.size.height)))
        }
    }
    
    // MARK: - Drawing Constants
    
    let cardCornerRadius: CGFloat = 10.0
    let cardCornerStyle: RoundedCornerStyle = .continuous
    let cardBackgroundColor: Color = .white
    let cardStrokeLineWidth: CGFloat = 3.0
    let cardAspectRatio: CGFloat = 2 / 3
    let cardFontMultiplier: CGFloat = 0.7
    
}

// MARK: -

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: EmojiMemoryGame())
            .preferredColorScheme(ColorScheme.dark)
    }
}
