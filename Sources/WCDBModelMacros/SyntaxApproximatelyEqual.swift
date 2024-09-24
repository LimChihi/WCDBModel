//
//  File.swift
//  WCDBModel
//
//  Created by lim on 25/9/2024.
//

import SwiftSyntax


extension AttributeSyntax {
    
    static func ~= (lhs: AttributeSyntax, rhs: AttributeSyntax) -> Bool {
        if lhs == rhs {
            return true
        }
        return lhs.atSign ~= rhs.atSign &&
        lhs.attributeName ~= rhs.attributeName
    }
    
}

extension TokenSyntax {
    static func ~= (lhs: TokenSyntax, rhs: TokenSyntax) -> Bool {
        if lhs == rhs {
            return true
        }
        return lhs.tokenKind == rhs.tokenKind &&
        lhs.text == rhs.text
    }
}

extension TypeSyntax {
    
    static func ~= (lhs: TypeSyntax, rhs: TypeSyntax) -> Bool {
        if lhs == rhs {
            return true
        }
        if lhs.kind != rhs.kind {
            return false
        }
        
        switch lhs.kind {
        case .identifierType:
            return lhs.as(IdentifierTypeSyntax.self)! ~= rhs.as(IdentifierTypeSyntax.self)!
        default:
            assertionFailure()
            return false
        }
    }
    
}

extension IdentifierTypeSyntax {
    
    static func ~= (lhs: IdentifierTypeSyntax, rhs: IdentifierTypeSyntax) -> Bool {
        if lhs == rhs {
            return true
        }
        return lhs.name ~= rhs.name
    }
    
}
