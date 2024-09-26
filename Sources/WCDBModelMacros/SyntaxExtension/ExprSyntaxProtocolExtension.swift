//
//  File.swift
//  WCDBModel
//
//  Created by lim on 26/9/2024.
//

import SwiftSyntax

extension ExprSyntaxProtocol where Self == DeclReferenceExprSyntax {
    
    static func identifier(_ name: String) -> DeclReferenceExprSyntax {
        DeclReferenceExprSyntax(baseName: .identifier(name))
    }
    
}


extension ExprSyntaxProtocol where Self == BooleanLiteralExprSyntax {
    
    static func literal(_ value: Bool) -> BooleanLiteralExprSyntax {
        BooleanLiteralExprSyntax(value)
    }
    
}

extension ExprSyntaxProtocol where Self == StringLiteralExprSyntax {
    
    static func literal(_ value: String) -> StringLiteralExprSyntax {
        StringLiteralExprSyntax(content: value)
    }
    
}
