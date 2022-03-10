//
//  Flow.swift
//  SwiftFlow
//
//  Copyright © Tyler Suehr 2022
//  Created by Tyler Suehr on 3/10/22.
//

import Foundation

/// Hot Flow-based observer system.
/// Only active observers get notified of non-stored emitted values.
public class Flow<T>: Visitor<T> {
    
    public override init() {}
    
    /// Triggers the visitor chain with given arguments.
    internal override func visit(_ value: Any, oldValue: Any?) {
        nextItem?.visit(value, oldValue: oldValue)
    }
    
    /// Emits the given value to active observers.
    /// - Parameter value: the value to be emitted
    public func emit(_ value: T) {
        visit(value, oldValue: nil)
    }
    
    /// Always emits the given value on the main event queue to active observers.
    /// - Parameter value: the value to be emitted
    public func emitOnMain(_ value: T) {
        DispatchQueue.main.async {
            self.visit(value, oldValue: nil)
        }
    }
    
}
