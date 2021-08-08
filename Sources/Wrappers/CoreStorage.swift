//
//  CoreStorage.swift
//  Wrappers
//
//  Created by Jonathan Holland on 7/21/21.
//

import SwiftUI
import CoreData
import Combine

@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
@propertyWrapper
public struct CoreStorage<Object: NSManagedObject>: DynamicProperty, CoreDataStorage {
    @Environment(\.managedObjectContext) public var viewContext
    private var cancellables = Set<AnyCancellable>()
    
    public var fetchRequest: FetchRequest<Object>
    
    public var wrappedValue: FetchedResults<Object> { fetchRequest.wrappedValue }
    public var projectedValue: CoreStorage { self }
    public var hasChanges: Bool = false
    public var autoSave: Bool
    
    public init(with predicate: NSPredicate? = nil, sorters: [NSSortDescriptor] = [], autoSave: Bool = true) where Object: NSManagedObject {
        if let predicate = predicate {
            fetchRequest = FetchRequest<Object>(entity: Object.entity(), sortDescriptors: sorters, predicate: predicate)
        } else {
            fetchRequest = FetchRequest<Object>(entity: Object.entity(), sortDescriptors: sorters, predicate: nil)
        }
        self.autoSave = autoSave
    }
    
    public func deleteItems(at offsets: IndexSet) {
        offsets.map { wrappedValue[$0] }.forEach(viewContext.delete)
        if autoSave {
            save()
        }
    }
    public func deleteAll() {
        wrappedValue.forEach(viewContext.delete(_:))
        if autoSave {
            save()
        }
    }
    public func publisher() -> AnyPublisher<Bool, Never> {
        wrappedValue.publisher
            .compactMap { results in
                results.hasChanges
            }
            .eraseToAnyPublisher()
    }
    
    public func save() {
        if viewContext.hasChanges {
            try? viewContext.save()
        }
    }
    
}
