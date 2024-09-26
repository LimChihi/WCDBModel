//
//  File.swift
//  WCDBModel
//
//  Created by lim on 27/9/2024.
//

import SwiftSyntax

struct VariableDeclContext {
    
    let syntax: VariableDeclSyntax
    
    var attributeSyntaxAttributes: [AttributeSyntax] {
        syntax.attributes.compactMap {
            $0.as(AttributeSyntax.self)
        }
    }
    
    var identifiers: [TokenSyntax] {
        syntax.bindings.compactMap {
            $0.pattern.as(IdentifierPatternSyntax.self)?.identifier
        }
    }
    
    
}
