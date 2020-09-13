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
        VStack {
            HStack(alignment: .center) {
                Text(viewModel.name).bold().lineLimit(1)
                Spacer()
                HStack(spacing: 25) {
                    HStack(alignment: .bottom, spacing: -2) {
                        Text(String(viewModel.score)).bold()
                        Text("/\(String(viewModel.cards.count))").font(.title3)
                    }
                    Button(action: viewModel.newGame) { Image(systemName: "shuffle") }
                }
            }
            .font(.title)
            .padding()
            Grid(viewModel.cards, itemDesiredAspectRatio: cardsDesiredAspectRatio) { card in
                CardView(card: card, cardBack: cardBack)
                        .onTapGesture {
                            viewModel.choose(card)
                    }
                        .padding(5)
            }
            .foregroundColor(viewModel.colors[0])
                
        }
        .padding()
    }
    
    private var cardBack: some View {
        Group {
            if let _ = viewModel.colors.only {
                Rectangle().fill()
            } else {
                Rectangle().fill(LinearGradient(gradient: Gradient(colors: viewModel.colors), startPoint: .bottomLeading, endPoint: .topTrailing))
            }
        }
    }
    
    // MARK: - Drawing Constants
    
    private let cardsDesiredAspectRatio: Double = 3 / 4
}

// MARK: -

struct CardView<BackContent>: View where BackContent: View {
    var card: MemoryGame<String>.Card
    var cardBack: BackContent
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if card.isMatched {
                    EmptyView()
                } else if card.isFaceUp {
                    RoundedRectangle(cornerRadius: cardCornerRadius, style: cardCornerStyle)
                        .fill()
                        .foregroundColor(cardBackgroundColor)
                    RoundedRectangle(cornerRadius: cardCornerRadius, style: cardCornerStyle)
                        .strokeBorder(lineWidth: cardStrokeLineWidth)
                    Text(card.content)
                } else {
                    cardBack
                        .clipShape(RoundedRectangle(cornerRadius: cardCornerRadius, style: cardCornerStyle))
                }
            }
            .font(.system(size: cardFontMultiplier * min(geometry.size.width, geometry.size.height)))
        }
    }
    
    // MARK: - Drawing Constants
    
    private let cardCornerRadius: CGFloat = 18.0
    private let cardCornerStyle: RoundedCornerStyle = .continuous
    private let cardBackgroundColor: Color = .white
    private let cardStrokeLineWidth: CGFloat = 3.0
    private let cardFontMultiplier: CGFloat = 0.7
    
}

// MARK: -

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: EmojiMemoryGame())
            .preferredColorScheme(ColorScheme.dark)
    }
}
