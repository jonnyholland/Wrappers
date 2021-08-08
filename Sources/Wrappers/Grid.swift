//
//  Grid.swift
//  Wrappers
//
//  Created by Jonathan Holland on 7/15/21.
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, macCatalyst 14.0, tvOS 14.0, watchOS 7.0, *)
public struct Grid<Item, Content>: View where Item: Hashable, Content: View {
    public init(_ items: [Item], padding: CGFloat = 8, alignment: HorizontalAlignment = .center, spacing: CGFloat? = 8, @ViewBuilder content: @escaping (Item) -> Content) {
        self.padding = padding
        self.items = items
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }
    
    private var padding: CGFloat
    private var columns = [GridItem(.adaptive(minimum: 50))]
    private var alignment: HorizontalAlignment
    private var spacing: CGFloat?
    private var items: [Item]
    private var content: (Item) -> Content
    
    public var body: some View {
        if !items.isEmpty {
            ScrollView {
                LazyVGrid(columns: columns, alignment: alignment, spacing: spacing) {
                    ForEach(items, id: \.self) { item in
                        content(item)
                    }
                }
            }
            .padding(padding)
            .animation(.interactiveSpring())
        }
    }
}
