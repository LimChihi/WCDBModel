//
//  File.swift
//  WCDBModel
//
//  Created by lim on 26/9/2024.
//

import SwiftSyntax
import SwiftSyntaxBuilder

struct CodingKeysGenerator {
    
    let root: TokenSyntax
    
    let caseDeclarations: [TokenSyntax]
    
    let columnConstraints: [CodeBlockItemSyntax]
    
    func run() throws -> EnumDeclSyntax {
        EnumDeclSyntax(
            name: .codingKeys,
            inheritanceClause: inheritanceClauseSyntax(),
            memberBlock: memberBlockSynax()
        )
    }
    
    // MARK: - enum

    private func inheritanceClauseSyntax() -> InheritanceClauseSyntax {
        InheritanceClauseSyntax {
            InheritedTypeSyntax(type: TypeSyntax(stringLiteral: "String"))
            InheritedTypeSyntax(type: TypeSyntax(stringLiteral: "CodingTableKey"))
        }
    }
    
    private func memberBlockSynax() -> MemberBlockSyntax {
        MemberBlockSyntax(members: MemberBlockItemListSyntax {
            "typealias Root = \(root)"
            mappingDeclarations()
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
    }
    
    private func mappingDeclarations() -> VariableDeclSyntax {
        VariableDeclSyntax(
            modifiers: DeclModifierListSyntax {
                DeclModifierSyntax(name: .keyword(.static))
            },
            bindingSpecifier: .keyword(.var)) {
                PatternBindingSyntax(
                    pattern: PatternSyntax(IdentifierPatternSyntax(identifier: .identifier("objectRelationalMapping"))),
                    typeAnnotation: TypeAnnotationSyntax(
                        colon: .colonToken(),
                        type: IdentifierTypeSyntax(name: .identifier("TableBinding"), genericArgumentClause: GenericArgumentClauseSyntax(arguments: GenericArgumentListSyntax {
                            GenericArgumentSyntax(argument: IdentifierTypeSyntax(name: .codingKeys))
                        }))
                    ),
                    accessorBlock: tableBindingInit()
                )
            }
    }
    
    private func tableBindingInit() -> AccessorBlockSyntax {
        AccessorBlockSyntax(
            accessors: AccessorBlockSyntax.Accessors.getter(
                CodeBlockItemListSyntax {
                    FunctionCallExprSyntax(
                        callee: DeclReferenceExprSyntax(baseName: .identifier("TableBinding")),
                        trailingClosure: ClosureExprSyntax(statements: CodeBlockItemListSyntax {
                            for item in columnConstraints {
                                item
                            }
                        }),
                        argumentList: {
                            LabeledExprListSyntax {
                                LabeledExprSyntax(
                                    expression: MemberAccessExprSyntax(
                                        base: DeclReferenceExprSyntax(baseName: .codingKeys),
                                        period: .periodToken(),
                                        declName: DeclReferenceExprSyntax(baseName: .keyword(.self))
                                    )
                                )
                            }
                        }
                    )
                }
            )
        )
    }
    
}

extension TokenSyntax {
    
    fileprivate static var codingKeys: TokenSyntax {
        .identifier("CodingKeys")
    }
    
}
