//
//  File.swift
//  
//
//  Created by Leo Tsuchiya on 6/6/21.
//

import Foundation

extension Bundle {

    /// Returns a package manager appropriate `Bundle`.
    static var resolvedBundle: Bundle {
        return Bundle(for: LifetimeTracker.self)
    }
}
