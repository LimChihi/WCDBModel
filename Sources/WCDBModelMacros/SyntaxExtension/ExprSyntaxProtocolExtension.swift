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
