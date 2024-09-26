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

struct DatabaseModelMacro: MemberMacro {
    
    static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        
        let typeName = try declaration.getName()
        
        let variableMembers = declaration.memberBlock.members
            .compactMap { member in
                member.decl.as(VariableDeclSyntax.self).map {
                    VariableDeclParser($0)
                }
            }
            .filter {
                !$0.contains(attribute: .transient)
            }

//        let caseDeclaration = variableMember
//            .reduce([]) { partialResult, variableDecl in
//                partialResult + variableDecl.bindings
//            }
//            .compactMap {
//                $0.pattern.as(IdentifierPatternSyntax.self)?.identifier
//            }
        
        let columnConstraintsGenerator = ColumnConstraintGenerator(variableMembers: variableMembers)
        let codingKeysGenerator = CodingKeysGenerator(
            root: typeName,
            variableMembers: variableMembers,
            columnConstraints: columnConstraintsGenerator.run()
        )
        
        return [
            try .init(codingKeysGenerator.run())
        ]
    }
    
}


//extension DatabaseModelMacro: ExtensionMacro {
//
//    static func expansion(of node: AttributeSyntax, attachedTo declaration: some DeclGroupSyntax, providingExtensionsOf type: some TypeSyntaxProtocol, conformingTo protocols: [TypeSyntax], in context: some MacroExpansionContext) throws -> [ExtensionDeclSyntax] {
//        [
//            try ExtensionDeclSyntax("extension \(type.trimmed): TableCodable {}")
//        ]
//    }
//    
//}
