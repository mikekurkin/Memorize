//
//  ContentView.swift
//  Memorize
//
//  Created by mk on 01.09.2020.
//

import SwiftUI

struct ContentView: View {
    var viewModel: EmojiMemoryGame
    
    var body: some View {
            HStack {
                ForEach(viewModel.cards) { card in
                    CardView(card: card)
                        .onTapGesture {
                                viewModel.choose(card: card)
                        }
                }
        }
            .font(viewModel.cards.count / 2 < 5 ? .largeTitle : .headline)
            .padding()
            .foregroundColor(Color.orange)
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        ZStack {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: 10.0, style: .continuous)
                    .fill()
                    .foregroundColor(Color.white)
                RoundedRectangle(cornerRadius: 10.0, style: .continuous)
                    .stroke(lineWidth: 3.0)
                Text(card.content)
            } else {
                RoundedRectangle(cornerRadius: 10.0, style: .continuous)
                    .fill()
            }
        }
            .aspectRatio(2 / 3, contentMode: .fit)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: EmojiMemoryGame())
            .preferredColorScheme(ColorScheme.dark)
    }
}
