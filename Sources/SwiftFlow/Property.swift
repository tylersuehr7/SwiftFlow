//
//  Property.swift
//  SwiftFlow
//
//  Copyright © Tyler Suehr 2022
//  Created by Tyler Suehr on 3/10/22.
//

import Foundation

/// Contains both *value* and *oldValue* fields and observable.
/// This is basically for legacy propjects I've built in the that need migrated.
///
/// - Deprecated: use *Flow* or *StateFlow* instead
@available(*, deprecated)
public class Property<T>: Visitor<T> {
    /// The previous value… initially set to null
    private(set) public var oldValue: T?
    
    /// The current value
    private var _value: T {
        didSet {
            visit(_value, oldValue: self.oldValue)
        }
    }
    
    /// Public-facing access to the underlying value stored by this class
    public var value: T {
        get {
            return self._value
        } set {
            self.oldValue = self._value
            self._value = newValue
        }
    }
    
    /// Constructs with a given value.
    /// - Parameter value: the initial value to be used
    public init(_ value: T) {
        self._value = value
    }
    
    internal override func visit(_ value: Any, oldValue: Any?) {
        // Trigger the visitor chain
        nextItem?.visit(self._value, oldValue: self.oldValue)
    }
}
