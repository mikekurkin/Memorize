//
//  EmojiMemoryGameView.swift
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
                    Button {
                        withAnimation(.easeInOut(duration: newGameAnimationDuration)) {
                            viewModel.newGame()
                        }
                    } label: { Image(systemName: "shuffle") }
                }
            }
            .font(.title)
            .padding()
            
            Grid(viewModel.cards, itemDesiredAspectRatio: cardsDesiredAspectRatio) { card in
                CardView(card: card, back: cardBack)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: chooseAnimationDuration)) {
                            viewModel.choose(card)
                        }
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
    private let newGameAnimationDuration: Double = 0.3
    private let chooseAnimationDuration: Double = 0.5
    
}

// MARK: -



struct CardView<BackContent>: View where BackContent: View {
    var card: MemoryGame<String>.Card
    var back: BackContent
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(pieStartAngle + pieCorrectionAngle), endAngle: Angle.degrees(-animatedBonusRemaining * 360 + pieCorrectionAngle), clockwise: true)
                                .onAppear { startBonusTimeAnimation() }
                    } else {
                        Pie(startAngle: Angle.degrees(pieStartAngle + pieCorrectionAngle), endAngle: Angle.degrees(-card.bonusRemaining * 360 + pieCorrectionAngle), clockwise: true)
                    }
                }
                .opacity(pieOpacity)
                .padding(piePadding)
                .transition(.scale)
                
                Text(card.content)
                    .font(.system(size: cardFontMultiplier * min(geometry.size.width, geometry.size.height)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: somersaultAnimationDuration).repeatCount(2))
            }
            .cardify(isFaceUp: card.isFaceUp, cardBack: back)
            .scaleEffect(CGSize(width: card.isMatched ? 0 : 1, height: card.isMatched ? 0 : 1))
        }
    }
    
    // MARK: - Drawing Constants
    
    private let cardFontMultiplier: CGFloat = 0.65
    
    private let piePadding: CGFloat = 7
    private let pieOpacity: Double = 0.3
    private let pieStartAngle: Double = 0
    private let pieCorrectionAngle: Double = -90
    
    private let somersaultAnimationDuration: Double = 0.5
    
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
