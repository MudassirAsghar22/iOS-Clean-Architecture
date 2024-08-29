//
//  DynamicAsync.swift
//  Created by Mudassir Asghar on 09/07/2022.
//

import Foundation

class DynamicAsync<T>: Dynamic<T> {
    
    // MARK: - Ovverides
    
    override func fire() {
        -->{ self.listener?(self.value) }
    }
    
    // MARK: - Initialization
    
    override init(_ v: T) {
        super.init(v)
    }
}
