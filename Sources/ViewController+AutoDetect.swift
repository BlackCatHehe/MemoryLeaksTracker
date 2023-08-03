//
//  ViewController+AutoDetect.swift
//  LifetimeTracker
//
//  Created by zjy on 2023/8/3.
//  Copyright © 2023 LifetimeTracker. All rights reserved.
//

import Foundation
import UIKit

public protocol MaxTrackerCount {
    var maxTrackerCount: Int { get }
}
extension MaxTrackerCount {
    public var maxTrackerCount: Int { 1 }
}

extension UIViewController: MaxTrackerCount {
    @objc func memory_viewDidLoad() {
        memory_viewDidLoad()
        
        if String(reflecting: Self.self).contains("LifetimeTracker") == false {
            memoryTrack(object: self, maxCount: maxTrackerCount)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.memoryPropertiesTrack()
            }
        }
    }
    
    private func memoryTrack(object: Any, maxCount: Int) {
        let configuration = LifetimeConfiguration(maxCount: 1, groupName: "\(self.self)")
        LifetimeTracker.instance?.track(object, configuration: configuration)
    }
    private func memoryPropertiesTrack() {
        let mirror = Mirror(reflecting: self)
        mirror.children.forEach { child in
            var subMirror = Mirror(reflecting: child.value)
            if subMirror.displayStyle == .optional, let first = subMirror.children.first?.value {
                subMirror = Mirror(reflecting: first)
            }
            if subMirror.displayStyle == .class {
                memoryTrack(object: child.value, maxCount: (child.value as? MaxTrackerCount)?.maxTrackerCount ?? 1 )
            }
        }
    }
}

