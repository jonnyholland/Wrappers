//
//  CoreStored.swift
//  Wrappers
//
//  Created by Jonathan Holland on 7/21/21.
//

import SwiftUI
import CoreData
import Combine

@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
@propertyWrapper
public struct CoreStored<Object: NSManagedObject>: DynamicProperty, CoreDataStorage {
    @Environment(\.managedObjectContext) public var viewContext
    
    public var object: Object
    
    public var wrappedValue: Object {
        get { object }
        set { self.object = newValue; if autoSave { try? viewContext.save() }; observer.object = newValue }
    }
    public var projectedValue: CoreStored { self }
    @ObservedObject public var observer: CoreDataObserver
    public var autoSave: Bool
    
    public init(object: Object, autoSave: Bool = true) where Object: NSManagedObject {
        self.object = object
        self.autoSave = autoSave
        observer = .init(object: object)
    }
    
    public func delete() throws {
        viewContext.delete(object)
        try viewContext.save()
    }
    
    public func publisher() -> AnyPublisher<Bool, Never> {
        object.publisher(for: \.hasChanges, options: [.new])
            .eraseToAnyPublisher()
    }
    
    ///https://www.donnywals.com/observing-changes-to-managed-objects-across-contexts-with-combine/
    func publisher<T: NSManagedObject>(for type: T.Type,
                                       in context: NSManagedObjectContext,
                                       changeTypes: [ChangeType]) -> AnyPublisher<[([T], ChangeType)], Never> {
        let notification = NSManagedObjectContext.didMergeChangesObjectIDsNotification
        return NotificationCenter.default.publisher(for: notification, object: context)
            .compactMap({ notification in
                return changeTypes.compactMap({ type -> ([T], ChangeType)? in
                    guard let changes = notification.userInfo?[type.userInfoKey] as? Set<NSManagedObjectID> else {
                        return nil
                    }
                    
                    let objects = changes
                        .filter({ objectID in objectID.entity == T.entity() })
                        .compactMap({ objectID in context.object(with: objectID) as? T })
                    return (objects, type)
                })
            })
            .eraseToAnyPublisher()
    }
}

public protocol CoreDataStorage {
    var viewContext: NSManagedObjectContext { get }
    
//    associatedtype Object
//
//    var wrappedValue: Object { get set }
    
    var autoSave: Bool { get set }
    func publisher() -> AnyPublisher<Bool, Never>
    
}

///https://www.donnywals.com/observing-changes-to-managed-objects-across-contexts-with-combine/
public enum ChangeType {
    case inserted, deleted, updated
    
    var userInfoKey: String {
        switch self {
            case .inserted: return NSInsertedObjectIDsKey
            case .deleted: return NSDeletedObjectIDsKey
            case .updated: return NSUpdatedObjectIDsKey
        }
    }
}
