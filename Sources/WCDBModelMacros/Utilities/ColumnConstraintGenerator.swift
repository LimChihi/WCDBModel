//
//  ColumnConstraintGenerator.swift
//  WCDBModel
//
//  Created by lim on 26/9/2024.
//

import SwiftSyntax
import SwiftSyntaxBuilder

struct ColumnConstraintGenerator {
    
    let columnVariables: [VariableDeclSyntax]
    
    func run() -> [CodeBlockItemSyntax] {
        
        pretreatment().map { item in
            
            FunctionCallExprSyntax(
                callee: .identifier("BindColumnConstraint"),
                argumentList: {
                    LabeledExprSyntax(
                        expression: MemberAccessExprSyntax(
                            period: .periodToken(),
                            declName: DeclReferenceExprSyntax(baseName: item.identifier))
                    )
                    for arg in argumentsExpr(for: item.attribute) {
                        arg
                    }
                }
            )
            
        }
        .map {
            CodeBlockItemSyntax(item: CodeBlockItemSyntax.Item.expr(ExprSyntax($0)))
        }
    }
    
    private struct VariableItem {
        let attribute: LabeledExprListSyntax
        let identifier: TokenSyntax
    }
    
    private func pretreatment() -> [VariableItem] {
        columnVariables
            .compactMap { variable -> (LabeledExprListSyntax, [TokenSyntax])? in
                let attribute = variable.attributes
                    .compactMap {
                        $0.as(AttributeSyntax.self)
                    }
                    .first {
                        $0 ~= .attribute
                    }
                
                guard case let .argumentList(arguments) = attribute?.arguments else {
                    return nil
                }
                
                let identifiers = variable.bindings.compactMap {
                    $0.pattern.as(IdentifierPatternSyntax.self)
                }
                    .map {
                        $0.identifier
                    }
                guard identifiers.count > 0 else {
                    return nil
                }
                
                
                return (arguments, identifiers)
            }
            .reduce([]) { partialResult, next in
                partialResult + next.1.map {
                    VariableItem(attribute: next.0, identifier: $0)
                }
            }
    }
    
    private func argumentsExpr(for attribute: LabeledExprListSyntax) -> [LabeledExprSyntax] {
        attribute
            .compactMap { item in
                item.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text
            }
            .compactMap { key in
                argumentsDictionary[key]
            }
            .sorted { lhs, rhs in
                lhs.index < rhs.index
            }
            .map {
                $0.expr
            }
    }
    
    private struct ColumnConstraintArguments {
        let expr: LabeledExprSyntax
        let index: Int
    }
    
    private var argumentsDictionary: [String: ColumnConstraintArguments] {
//        BindColumnConstraint(_ codingKey: CodingTableKeyType,
//                 1  isPrimary: Bool = false,
//                 2  orderBy term: Order? = nil,
//                 3  isAutoIncrement: Bool = false,
//                 4  enableAutoIncrementForExistingTable: Bool = false,
//                 5  onConflict conflict: ConflictAction? = nil,
//                 6  isNotNull: Bool = false,
//                 7  isUnique: Bool = false,
//                 8  defaultTo defaultValue: LiteralValue? = nil,
//                 9  isNotIndexed: Bool = false)
        [
            "primary" : ColumnConstraintArguments(
                expr: LabeledExprSyntax(
                    label: "isPrimary",
                    expression: BooleanLiteralExprSyntax(true)
                ),
                index: 1),
            "autoIncrement" : ColumnConstraintArguments(
                expr: LabeledExprSyntax(
                    label: "isAutoIncrement",
                    expression: BooleanLiteralExprSyntax(true)
                ),
                index: 3),
        ]
    }

}
