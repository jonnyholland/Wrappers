//
//  Wrap.swift
//  Wrappers
//
//  Created by Jonathan Holland on 7/15/21.
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, macCatalyst 14.0, tvOS 14.0, watchOS 7.0, *)
public struct Wrap<Content>: View where Content: View {
    public init(minimumWidth: CGFloat = 50, maximumWidth: CGFloat? = nil, padding: CGFloat = 8, alignment: HorizontalAlignment = .center, spacing: CGFloat? = 8, @ViewBuilder content: @escaping () -> Content) {
        self.columns = [GridItem(.adaptive(minimum: minimumWidth, maximum: maximumWidth ?? .infinity))]
        self.padding = padding
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }
    
    private var padding: CGFloat
    private var columns: [GridItem]
    private var alignment: HorizontalAlignment
    private var spacing: CGFloat?
    private var content: () -> Content
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: alignment, spacing: spacing) {
                content()
            }
        }
        .padding(padding)
        .animation(.interactiveSpring())
    }
}
