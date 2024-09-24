//
//  File.swift
//  WCDBModel
//
//  Created by lim on 25/9/2024.
//

import Foundation

struct MessageError: Error, ExpressibleByStringLiteral {
    
    let message: String
    
    init(stringLiteral value: StringLiteralType) {
        self.message = value
    }
    
}
