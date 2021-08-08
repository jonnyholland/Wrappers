//
//  CoreDataObserver.swift
//  Wrappers
//
//  Created by Jonathan Holland on 7/23/21.
//

import SwiftUI
import CoreData
import Combine

public class CoreDataObserver: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var object: NSManagedObject
    @Published var hasChanges: Bool = false
    @Published var isDeleted: Bool = false
    @Published var isUpdated: Bool = false
    @Published var context: NSManagedObjectContext?
    
    public init(object: NSManagedObject) {
        self.object = object
        
        objectPublisher
            .receive(on: RunLoop.main)
            .sink { object in
                self.hasChanges = object.hasChanges
                self.isDeleted = object.isDeleted
                self.isUpdated = object.isUpdated
                self.context = object.managedObjectContext
            }
            .store(in: &cancellables)
        
    }
    
    private var objectPublisher: AnyPublisher<NSManagedObject, Never> {
        $object
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map { object in
                return object
            }
            .eraseToAnyPublisher()
    }
    
}
