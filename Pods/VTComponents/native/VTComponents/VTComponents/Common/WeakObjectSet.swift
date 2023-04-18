//
//  WeakObjectSet.swift
//  CliqUiController
//
//  Created by vel-9174 on 03/04/22.
//  Copyright © 2022 Zoho Corporation. All rights reserved.
//


import Foundation

public class WeakObject<T: AnyObject>: Equatable, Hashable {
    
    public weak var object: T?
    private let hashKey: Int
    
    init(_ object: T) {
        self.object = object
        self.hashKey = ObjectIdentifier(object).hashValue
    }
    
    static public func == (lhs: WeakObject<T>, rhs: WeakObject<T>) -> Bool {
        if lhs.object == nil || rhs.object == nil { return false }
        return lhs.object === rhs.object
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(object.debugDescription)
    }
}

public class WeakObjectSet<T: AnyObject> {
    
    public var isEmpty : Bool {
        return _objects.isEmpty
    }
    
    public var _objects: Set<WeakObject<T>>
    
    public init() {
        self._objects = Set<WeakObject<T>>([])
    }
    
    public init(_ objects: [T]) {
        self._objects = Set<WeakObject<T>>(objects.map { WeakObject($0) })
    }
    
    public var objects: [T] {
        return self._objects.compactMap { $0.object }
    }
    
    public func contains(_ object: T) -> Bool {
        return self._objects.contains(WeakObject(object))
    }
    
    public func addObject(_ object: T) {
        self._objects.insert(WeakObject(object))
    }
    
    public func addingObject(_ object: T) -> WeakObjectSet<T> {
        return WeakObjectSet( self.objects + [object])
    }
    
    public func addObjects(_ objects: [T]) {
        self._objects.formUnion(objects.map { WeakObject($0) })
    }
    
    public func addingObjects(_ objects: [T]) -> WeakObjectSet<T> {
        return WeakObjectSet( self.objects + objects)
    }
    
    public func removeAllObjects() {
        self._objects.removeAll()
    }
    
    public func removeObject(_ object: T) {
        self._objects.remove(WeakObject(object))
    }
    
    public func removingObject(_ object: T) -> WeakObjectSet<T> {
        var temporaryObjects = self._objects
        temporaryObjects.remove(WeakObject(object))
        return WeakObjectSet(temporaryObjects.compactMap { $0.object })
    }
    
    public func removeObjects(_ objects: [T]) {
        self._objects.subtract(objects.map { WeakObject($0) })
    }
    
    public func removingObjects(_ objects: [T]) -> WeakObjectSet<T> {
        let temporaryObjects = self._objects.subtracting(objects.map { WeakObject($0) })
        return WeakObjectSet(temporaryObjects.compactMap { $0.object })
    }
}
