//
//  CoreContextObserver.swift
//  Wrappers
//
//  Created by Jonathan Holland on 7/23/21.
//

import SwiftUI
import CoreData
import Combine

public class CoreContextObserver: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var context: NSManagedObjectContext
    @Published var hasChanges: Bool = false
    @Published var insertedObjects = Set<NSManagedObject>()
    @Published var deletedObjects = Set<NSManagedObject>()
    @Published var updatedObjects = Set<NSManagedObject>()
    
    public init(context: NSManagedObjectContext) {
        self.context = context
        
        contextPublisher
            .receive(on: RunLoop.main)
            .sink { context in
                self.hasChanges = context.hasChanges
                self.insertedObjects = context.insertedObjects
                self.deletedObjects = context.deletedObjects
                self.updatedObjects = context.updatedObjects
            }
            .store(in: &cancellables)
        
    }
    
    private var contextPublisher: AnyPublisher<NSManagedObjectContext, Never> {
        $context
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map { context in
                return context
            }
            .eraseToAnyPublisher()
    }
    
}

