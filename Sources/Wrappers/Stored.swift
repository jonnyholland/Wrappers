//
//  Stored.swift
//  Wrappers
//
//  Created by Jonathan Holland on 7/26/21.
//

import SwiftUI
import Combine
import CoreData

@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
@propertyWrapper
public struct Stored<C: CoreDataStorage>: DynamicProperty {
    @Environment(\.managedObjectContext) public var viewContext
    private var cancellables = Set<AnyCancellable>()
    
    public var object: C
    public var wrappedValue: C {
        get { object }
        set { object = newValue }
    }
    public var projectedValue: C { self as! C }
    public var newObject = Feed {
        C.self
    }
    
    public init(_ object: C) {
        self.object = object
        
        object.publisher()
            .sink { [self] didChange in
                if didChange, object.autoSave {
                    self.save()
                }
            }
            .store(in: &cancellables)
    }
    public init<Object: NSManagedObject>(object: Object) {
        self.init(CoreStored(object: object) as! C)
    }
    public init<Object: NSPersistentContainer>(container: Object) {
        self.init(CoreContainer(container) as! C)
    }
    public init(name: String, loadStore: Bool = false) {
        self.init(CoreContainer(name: name, loadStore: loadStore) as! C)
    }
    public init<Object: NSManagedObject>(_ object: Object, with predicate: NSPredicate? = nil, sorters: [NSSortDescriptor] = [], autoSave: Bool = true) {
        self.init(CoreStorage<Object>(with: predicate, sorters: sorters, autoSave: autoSave) as! C)
    }
    
    public func save() {
        if viewContext.hasChanges {
            try? viewContext.save()
        }
    }
}
