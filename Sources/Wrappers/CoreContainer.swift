//
//  CoreContainer.swift
//  Wrappers
//
//  Created by Jonathan Holland on 7/22/21.
//

import SwiftUI
import CoreData
import Combine

@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
@propertyWrapper
public struct CoreContainer<C: NSPersistentContainer>: DynamicProperty, CoreDataStorage {
    
    public var container: C
    public var wrappedValue: C {
        get { container }
        set { container = newValue }
    }
    public var projectedValue: CoreContainer { self }
    public var viewContext: NSManagedObjectContext {
        wrappedValue.viewContext
    }
    public var hasChanges: Bool {
        if viewContext.hasChanges, autoSave {
            save()
        }
        return viewContext.hasChanges
    }
    public var autoSave: Bool
    
    public init(_ container: C, loadStore: Bool = false, autoSave: Bool = false) where C: NSPersistentContainer {
        self.container = container
        self.autoSave = autoSave
        if loadStore {
            self.container.loadPersistentStores { storeDescription, error in
                if let error = error {
                    print("****\(#file)-\(#line) error found loading persistent store: \(error)")
                }
            }
        }
    }
    
    public init(name: String, loadStore: Bool = false) {
        self.init(.init(name: name), loadStore: loadStore)
    }
    
    public init(name: String, managedObjectModel: NSManagedObjectModel, loadStore: Bool = false) {
        self.init(.init(name: name, managedObjectModel: managedObjectModel), loadStore: loadStore)
    }
    
    public func publisher() -> AnyPublisher<Bool, Never> {
        container.viewContext.publisher(for: \.hasChanges, options: [.new])
            .eraseToAnyPublisher()
    }
    
    public func save() {
        if viewContext.hasChanges {
            try? viewContext.save()
        }
    }
    
    public mutating func updateContainer(to newContainer: NSPersistentContainer, loadStore: Bool) {
        if let newContainer = newContainer as? C {
            self.wrappedValue = newContainer
            if loadStore {
                self.wrappedValue.loadPersistentStores { _ , error in
                    if let error = error {
                        print("****\(#file)-\(#line) error found loading new persistent store: \(error)")
                    }
                }
            }
        }
    }
    
}

struct Test {
    
    @CoreStorage<ManagedObject> private var storage
    @CoreContainer(name: "name") private var container
    @CoreStored(object: ManagedObject()) var object
    
    func test() {
        
    }
}

public class ManagedObject: NSManagedObject {
    
}
