//
//  File.swift
//  WCDBModel
//
//  Created by lim on 27/9/2024.
//

import SwiftSyntax
import SwiftSyntaxBuilder

struct VariableDeclParser {
    
    let context: VariableDeclContext
    
    init(_ context: VariableDeclContext) {
        self.context = context
    }
    
    init(_ syntax: VariableDeclSyntax) {
        self.context = VariableDeclContext(syntax: syntax)
    }
    
    func contains(attribute: AttributeSyntax) -> Bool {
        context.attributeSyntaxAttributes.contains {
            $0 ~= attribute
        }
    }
    
    func first(attribute: AttributeSyntax) -> AttributeSyntax? {
        context.attributeSyntaxAttributes.first {
            $0 ~= attribute
        }
    }
    
//    func first()
    
    func attributeArguments() -> LabeledExprListSyntax? {
        let attribute = first(attribute: .attribute)
        
        guard case let .argumentList(arguments) = attribute?.arguments, arguments.count > 0 else {
            return nil
        }
        
        return arguments
    }
    
}


extension LabeledExprListSyntax {
    
    func expression(for label: TokenSyntax?) -> ExprSyntax? {
        guard let label else {
            return first {
                $0.label == nil
            }.map {
                $0.expression
            }
        }
        
        return first {
            guard let lhsLabel = $0.label else {
                return false
            }
            return lhsLabel ~= label
        }
        .map {
            $0.expression
        }
    }
    
}
