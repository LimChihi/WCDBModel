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

extension DatabaseModelMacro: MemberMacro {
    
    static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        
        let typeName = try declaration.getName()
        
        let variableMember = declaration.memberBlock.members
            .compactMap { member in
                member.decl.as(VariableDeclSyntax.self)
            }
            .filter { variableDecl in
                !variableDecl.attributes.contains { element in
                    guard let attribute = element.as(AttributeSyntax.self) else {
                        return false
                    }
                    return attribute ~= .transient
                }
            }
            .reduce([]) { partialResult, variableDecl in
                partialResult + variableDecl.bindings
            }
        
        let caseDeclaration = variableMember
            .compactMap {
                $0.pattern.as(IdentifierPatternSyntax.self)?.identifier
            }
        
        return [
            try .init(generateCodingKeys(for: caseDeclaration, root: typeName))
        ]
    }
    
    private static func generateCodingKeys(for caseDeclarations: [TokenSyntax], root: TokenSyntax) throws -> EnumDeclSyntax {
        return EnumDeclSyntax(
            name: .identifier("CodingKeys"),
            inheritanceClause: InheritanceClauseSyntax {
                InheritedTypeSyntax(type: TypeSyntax(stringLiteral: "String"))
                InheritedTypeSyntax(type: TypeSyntax(stringLiteral: "CodingTableKey"))
            },
            memberBlock: MemberBlockSyntax(members: MemberBlockItemListSyntax {
                "typealias Root = \(root)"
                for caseDeclaration in caseDeclarations {
                    MemberBlockItemSyntax(
                        decl: EnumCaseDeclSyntax(
                            elements: EnumCaseElementListSyntax {
                                EnumCaseElementSyntax(name: caseDeclaration)
                            }
                        )
                    )
                }

            })
        )
    }
    
}

extension DeclGroupSyntax {
    
    func getName() throws(MessageError) -> TokenSyntax {
        if let structDecl = self.as(StructDeclSyntax.self) {
            return structDecl.name
        } else if let enumDecl = self.as(EnumDeclSyntax.self) {
            return enumDecl.name
        } else if let classDecl = self.as(ClassDeclSyntax.self) {
            return classDecl.name
        }
        throw "Can't get declaration name."
    }
    
}

extension AttributeSyntax {
    
    static var transient: AttributeSyntax {
        "@Transient"
    }
}
