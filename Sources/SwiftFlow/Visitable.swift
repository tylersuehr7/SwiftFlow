//
//  Visitable.swift
//  SwiftFlow
//
//  Copyright © Tyler Suehr 2022
//  Created by Tyler Suehr on 3/10/22.
//

/// Any component that can be visited for new and old values.
internal protocol Visitable {
    func visit(_ value: Any, oldValue: Any?)
}
