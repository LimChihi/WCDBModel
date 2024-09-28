//
//  File.swift
//  WCDBModel
//
//  Created by lim on 26/9/2024.
//

import SwiftSyntax
import SwiftSyntaxBuilder

struct CodingKeysGenerator {
    
    let isPublic: Bool
    
    let root: TokenSyntax
    
    let variableMembers: [VariableDeclParser]
    
    let columnConstraints: [CodeBlockItemSyntax]
    
    func run() throws -> EnumDeclSyntax {
        EnumDeclSyntax(
            modifiers: DeclModifierListSyntax {
                if isPublic {
                    DeclModifierSyntax(name: .publicToken)
                }
            },
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
            if isPublic {
                "public typealias Root = \(root)"
            } else {
                "typealias Root = \(root)"
            }
            mappingDeclarations()
            let cases = variableMembers
                .map { member -> ([TokenSyntax], ExprSyntax?) in
                    let identifiers = member.context.identifiers
                    let originalName = member.attributeArguments()?.expression(for: .identifier("originalName"))
                    return (identifiers, originalName)
                }
                .reduce([]) { partialResult, next in
                    partialResult + next.0.map {
                        ($0, next.1)
                    }
                }
            
            for (caseDeclaration, originalNameExpr) in cases {
                let originalName = originalNameExpr?
                    .as(StringLiteralExprSyntax.self)?
                    .segments.first?
                    .as(StringSegmentSyntax.self)?.content
                
                MemberBlockItemSyntax(
                    decl: EnumCaseDeclSyntax(
                        elements: EnumCaseElementListSyntax {
                            EnumCaseElementSyntax(
                                name: caseDeclaration,
                                rawValue: originalName.map {
                                    InitializerClauseSyntax(value: .literal($0.text))
                                }
                            )
                        }
                    )
                )
            }
        })
    }
    
    /*
    private func mappingDeclarations() -> VariableDeclSyntax {
        VariableDeclSyntax(
            modifiers: DeclModifierListSyntax {
                if isPublic {
                    DeclModifierSyntax(name: .publicToken)
                }
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
     */
    
    private func mappingDeclarations() -> VariableDeclSyntax {
        VariableDeclSyntax(
            modifiers: DeclModifierListSyntax {
                if isPublic {
                    DeclModifierSyntax(name: .publicToken)
                }
                DeclModifierSyntax(name: .keyword(.static))
            },
            bindingSpecifier: .keyword(.let)) {
                PatternBindingSyntax(
                    pattern: PatternSyntax(IdentifierPatternSyntax(identifier: .identifier("objectRelationalMapping"))),
                    typeAnnotation: TypeAnnotationSyntax(
                        colon: .colonToken(),
                        type: IdentifierTypeSyntax(name: .identifier("TableBinding"), genericArgumentClause: GenericArgumentClauseSyntax(arguments: GenericArgumentListSyntax {
                            GenericArgumentSyntax(argument: IdentifierTypeSyntax(name: .codingKeys))
                        }))
                    ),
                    initializer: InitializerClauseSyntax(
                        equal: .equalToken(),
                        value: FunctionCallExprSyntax(
                            callee: ClosureExprSyntax(statements: tableBindingInitFunctionSyntax())
                        )
                    )
                )
            }
    }
    
    
    func test() -> VariableDeclSyntax {
        try! VariableDeclSyntax(
        """
        static let objectRelationalMapping: TableBinding<CodingKeys> = {
            TableBinding(CodingKeys.self) {
                BindColumnConstraint(id, isPrimary: true, isAutoIncrement: true)
            }
        }()
        """
        )
    }
    
    /*
    private func tableBindingInit() -> AccessorBlockSyntax {
        AccessorBlockSyntax(
            accessors: AccessorBlockSyntax.Accessors.getter(
                tableBindingInitFunctionSyntax()
            )
        )
    }
     */
    
    private func tableBindingInitFunctionSyntax() -> CodeBlockItemListSyntax {
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
        
    }
    
}

extension TokenSyntax {
    
    fileprivate static var codingKeys: TokenSyntax {
        .identifier("CodingKeys")
    }
    
}
