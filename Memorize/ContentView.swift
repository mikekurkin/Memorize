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
                CardView(card: card, back: cardBack)
                        .onTapGesture {
                            viewModel.choose(card)
                    }
                        .padding(5)
            }
            .foregroundColor(viewModel.colors[0])
                
        }
        .padding()
    }
    
    @ViewBuilder
    private var cardBack: some View {
        if let _ = viewModel.colors.only {
            Rectangle().fill()
        } else {
            LinearGradient(gradient: Gradient(colors: viewModel.colors), startPoint: .bottomLeading, endPoint: .topTrailing)
        }
    }
    
    // MARK: - Drawing Constants
    
    private let cardsDesiredAspectRatio: Double = 3 / 4
    
}

// MARK: -

struct CardView<BackContent>: View where BackContent: View {
    var card: MemoryGame<String>.Card
    var back: BackContent
    
    var body: some View {
        GeometryReader { geometry in
                if !card.isMatched {
                    ZStack {
                        Pie(startAngle: Angle.degrees(0 - 90), endAngle: Angle.degrees(110 - 90), clockwise: true)
                            .opacity(pieOpacity)
                            .padding(piePadding)
                        Text(card.content)
                    }
                    .cardify(isFaceUp: card.isFaceUp, cardBack: back)
                    .font(.system(size: cardFontMultiplier * min(geometry.size.width, geometry.size.height)))
                }
        }
    }
    
    // MARK: - Drawing Constants
    
    private let cardFontMultiplier: CGFloat = 0.65
    private let piePadding: CGFloat = 7
    private let pieOpacity: Double = 0.3
    
}

// MARK: -

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards[1])
        return ContentView(viewModel: game)
            .preferredColorScheme(ColorScheme.dark)
    }
}
