//
//  Feed.swift
//  Wrappers
//
//  Created by Jonathan Holland on 7/23/21.
//

import SwiftUI
import Combine
import CoreData

/// This was used by Swify by Sundell.
/// https://www.swiftbysundell.com/articles/building-custom-combine-publishers-in-swift/
public struct Feed<Output>: Publisher {
    public typealias Failure = Never
    
    var provider: () -> Output?
    
    public func receive<S: Subscriber>(
        subscriber: S
    ) where S.Input == Output, S.Failure == Never {
        let subscription = Subscription(feed: self, target: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

private extension Feed {
    class Subscription<Target: Subscriber>: Combine.Subscription
    where Target.Input == Output {
        
        private let feed: Feed
        private var target: Target?
        
        init(feed: Feed, target: Target) {
            self.feed = feed
            self.target = target
        }
        
        func request(_ demand: Subscribers.Demand) {
            var demand = demand
            
            // We'll continue to emit new values as long as there's
            // demand, or until our provider closure returns nil
            // (at which point we'll send a completion event):
            while let target = target, demand > 0 {
                if let value = feed.provider() {
                    demand -= 1
                    demand += target.receive(value)
                } else {
                    target.receive(completion: .finished)
                    break
                }
            }
        }
        
        func cancel() {
            target = nil
        }
    }
}

