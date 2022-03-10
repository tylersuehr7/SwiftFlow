//
//  Visitor.swift
//  SwiftFlow
//
//  Created by Tyler Suehr on 3/10/22.
//

/// Parent class for any component whose underlying value can be observered.
public class Visitor<T>: Visitable {
    internal var nextItem: Visitable?
    
    /// Subclasses should override this function.
    internal func visit(_ value: Any, oldValue: Any?) {
    }
    
    /// Appends a condition to the visitor chain.in
    public func when(_ delegate: @escaping (T) -> Bool) -> Visitor<T> {
        let evaluator = Predicate(delegate: delegate)
        self.nextItem = evaluator
        return evaluator
    }
    
    /// Appends an adapter function to the visitor chain.
    public func map<U>(_ delegate: @escaping (T) -> U) -> Visitor<U> {
        let transformer = Function(delegate: delegate)
        self.nextItem = transformer
        return transformer
    }
    
    /// Appends a comparator to the visitor chain.
    public func compare(_ delegate: @escaping (T,T?) -> Bool) -> Visitor<T> {
        let comparator = Comparator(delegate: delegate)
        self.nextItem = comparator
        return comparator
    }
    
    /// Appends a watch consumer to the visitor chain.
    /// Can observe values at any given place in this chain.
    public func watch(_ delegate: @escaping (T) -> ()) -> Visitor<T> {
        let monitor = Consumer(delegate: delegate)
        self.nextItem = monitor
        return monitor
    }
    
    /// Appends a watch consumer to the visitor chain.
    /// Terminates the visitor chain and observes the latest value.
    public func observe(_ delegate: @escaping (T) -> ()) {
        let monitor = Consumer(delegate: delegate)
        self.nextItem = monitor
    }
}

extension Visitor where T: Equatable {
    /// Appends a comparator to the visitor chain.
    /// Asserts each new value is different than the previous.
    public func distinct() -> Visitor<T> {
        let comparator = Comparator<T>(delegate: { $0 != $1 })
        self.nextItem = comparator
        return comparator
    }
}

fileprivate class Comparator<T>: Visitor<T> {
    private let delegate: (T,T?) -> Bool
    
    fileprivate init(delegate: @escaping (T,T?) -> Bool) {
        self.delegate = delegate
    }
    
    override func visit(_ value: Any, oldValue: Any?) {
        guard let val = value as? T else { return }
        guard delegate(val, oldValue as? T) else { return }
        nextItem?.visit(val, oldValue: oldValue)
    }
}

fileprivate class Consumer<T>: Visitor<T> {
    private var delegate: ((T) -> ())?
    
    fileprivate init(delegate: @escaping (T) -> ()) {
        self.delegate = delegate
    }
    
    override func visit(_ value: Any, oldValue: Any?) {
        guard let val = value as? T else { return }
        delegate?(val)
        nextItem?.visit(val, oldValue: oldValue)
    }
}

fileprivate class Function<T,U>: Visitor<U> {
    private let delegate: (T) -> U
    
    fileprivate init(delegate: @escaping (T) -> U) {
        self.delegate = delegate
    }
    
    override func visit(_ value: Any, oldValue: Any?) {
        guard let val = value as? T else { return }
        
        var oldVal: U?
        if let ov = oldValue as? T {
            oldVal = delegate(ov)
        }
        
        let newVal = delegate(val)
        nextItem?.visit(newVal, oldValue: oldVal)
    }
}

fileprivate class Predicate<T>: Visitor<T> {
    private let delegate: (T) -> Bool
    
    fileprivate init(delegate: @escaping (T) -> Bool) {
        self.delegate = delegate
    }
    
    override func visit(_ value: Any, oldValue: Any?) {
        guard let val = value as? T else { return }
        guard delegate(val) else { return }
        nextItem?.visit(val, oldValue: oldValue)
    }
}
