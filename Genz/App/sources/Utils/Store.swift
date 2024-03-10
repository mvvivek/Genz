//
//  Store.swift
//  Genz
//
//  Created by Vivek MV on 10/03/24.
//

import Foundation

class Store: NSObject {
    
    static let shared = Store()
    
    private override init() {}
    
    var likes: Dictionary<String, Bool> = [:]
}
