//
//  DynamicArray.swift
//  Created by Mudassir Asghar on 09/07/2022.
//

import Foundation

enum ListenerToFire {
    case add
    case remove
    case defaultCase
}

class DynamicArray<T>: DynamicAsync<[T]> {
    
    // MARK: - typealias
    
    typealias RemoveListener = (Int) -> ()
    typealias AddListener = ((Int)) -> ()
    
    // MARK: - Vars & Lets
    
    var removeListener: RemoveListener?
    var appendListener: AddListener?
    
    var listenerToFire = ListenerToFire.defaultCase
    
    override func fire() {
        if listenerToFire == .defaultCase {
            listener?(value)
        }
        self.listenerToFire = .defaultCase
    }
    
    // MARK: - Public methods
    
    func append(_ element: T) {
        self.listenerToFire = .add
        self.value.append(contentsOf: [element])
        self.appendListener?(value.count)
    }
    
    func append(_ contentsOf: [T]) {
        self.listenerToFire = .add
        self.value.append(contentsOf: contentsOf)
        self.appendListener?(contentsOf.count)
    }
    
    func remove(_ at: Int) {
        self.listenerToFire = .remove
        self.value.remove(at: at)
        self.removeListener?(at)
    }
    
    func bindRemoveListener(_ listener: RemoveListener?) {
        self.removeListener = listener
    }
    
    func bindAppendListener(_ listener: AddListener?) {
        self.appendListener = listener
    }
    
}
