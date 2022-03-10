//
//  StateFlow.swift
//  SwiftFlow
//
//  Created by Tyler Suehr on 3/10/22.
//

import Foundation

/// Cold Flow-based observer system.
/// Any observer will get notified using stored emitted values.
public class StateFlow<T>: Flow<T> {
    private var isInitial = false
    private var isNotifyInitial = true
    
    public var value: T {
        didSet {
            self.isInitial = false
            super.emit(value)
        }
    }
    
    public init(_ initialValue: T, isNotifyInitial: Bool = true) {
        self.value = initialValue
        self.isInitial = true
        self.isNotifyInitial = isNotifyInitial
    }
    
    override open func emit(_ value: T) {
        self.value = value
    }
    
    override public func observe(_ delegate: @escaping (T) -> ()) {
        if isInitial && isNotifyInitial {
            delegate(value)
        } else if !isInitial {
            delegate(value)
        }
        super.observe(delegate)
    }
}
