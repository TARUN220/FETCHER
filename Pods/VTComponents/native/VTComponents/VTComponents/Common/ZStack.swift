//
//  ZStack.swift
//  ZMail
//
//  Created by siva-6975 on 05/12/19.
//

import Foundation

public struct ZStack<T: Equatable> {
    
    private var array: SafeReadWrite<[T]> = SafeReadWrite([T]())
    
    public var allElements: [T] {
        return array.value
    }
    
    public init() {}
    
    public mutating func push(_ element: T) {
        array.write { (array) in
            array.append(element)
        }
    }
    
    public mutating func addAtBottom(_ element: T) {
        array.write { (array) in
            array.insert(element, at: 0)
        }
    }
    
    public mutating func push(_ elements: [T]) {
        array.write { (array) in
            array.append(contentsOf: elements)
        }
    }
    
    public mutating func pop(completion: (T?) -> Void) {
        array.write { (value) in
            let lastValue = value.popLast()
            completion(lastValue)
        }
    }
    public mutating func pop() -> T? {
        return array.value.popLast()
    }
    
    public mutating func popNElements(_ n: Int, completion: (([T]) -> Void)? = nil) {
        var elements: [T] = []
        array.write { (value) in
            for _ in 1...n {
                guard let element = value.popLast() else {
                    completion?(elements)
                    return
                }
                elements.append(element)
                completion?(elements)
            }
        }
    }
    
    public mutating func popAll(completion: (([T]) -> Void)? = nil) {
        array.write { (value) in
            let allValues = value.map({return $0})
            value.removeAll()
            completion?(allValues)
        }
    }
    
    public mutating func remove(element: T) {
        array.write { (value) in
            value.removeAll(where: {$0 == element})
        }
    }
    
    
    public func count() -> Int {
        return array.value.count
    }
    
    public func isEmpty() -> Bool {
        return array.value.isEmpty
    }
    
}
