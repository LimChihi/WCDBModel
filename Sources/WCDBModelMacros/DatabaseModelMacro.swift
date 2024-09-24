//
//  DatabaseModel.swift
//  WCDBModel
//
//  Created by lim on 25/9/2024.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

struct DatabaseModelMacro {
    
}

extension DatabaseModelMacro: MemberAttributeMacro {
    
    static func expansion(of node: AttributeSyntax, attachedTo declaration: some DeclGroupSyntax, providingAttributesFor member: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [AttributeSyntax] {
        
        let containsTransient = member.as(VariableDeclSyntax.self)?
            .attributes
            .contains { element in
                guard let attribute = element.as(AttributeSyntax.self) else {
                    return false
                }
                return attribute ~= .transient
        } ?? false
        
        return containsTransient ? [] : ["@_PersistedProperty"]
    }

}

extension AttributeSyntax {
    
    static var transient: AttributeSyntax {
        "@Transient"
    }
}
