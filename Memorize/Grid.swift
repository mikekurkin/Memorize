//
//  Grid.swift
//  Memorize
//
//  Created by Mike Kurkin on 09.09.2020.
//

import SwiftUI

struct Grid<Item, ItemView>: View where
    Item: Identifiable,
    ItemView: View {
    var items: [Item]
    var viewForItem: (Item) -> ItemView
    var itemDesiredAspectRatio: Double = 1
    
    init(_ items: [Item], itemDesiredAspectRatio: Double = 1, contents viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.itemDesiredAspectRatio = itemDesiredAspectRatio
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader { geometry in
            let layout = GridLayout(itemCount: items.count, nearAspectRatio: itemDesiredAspectRatio, in: geometry.size)
            ForEach(items) { item in
                if let index = items.firstIndex(matching: item) {
                    viewForItem(item)
                        .frame(width: layout.itemSize.width, height: layout.itemSize.height)
                        .position(layout.location(ofItemAt: index))
                }
            }
        }
    }
}

