//
//  ColumnConstraintGenerator.swift
//  WCDBModel
//
//  Created by lim on 26/9/2024.
//

import SwiftSyntax
import SwiftSyntaxBuilder

struct ColumnConstraintGenerator {
    
    let variableMembers: [VariableDeclParser]
    
    func run() -> [CodeBlockItemSyntax] {
        variableMembers
            .compactMap { member -> (LabeledExprListSyntax, [TokenSyntax])? in
                guard let arguments = member.attributeArguments() else {
                    return nil
                }
                let identifiers = member.context.identifiers
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
            .compactMap { item -> FunctionCallExprSyntax? in
                let argExprs = argumentsExpr(for: item.attribute)
                guard argExprs.count > 0 else {
                    return nil
                }
                return FunctionCallExprSyntax(
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
    
    private func argumentsExpr(for attribute: LabeledExprListSyntax) -> [LabeledExprSyntax] {
        attribute
            .map { item -> [BindColumnConstraintArguments] in
                let expression = item.expression
                if let member = expression.as(MemberAccessExprSyntax.self) {
                    if let arg = columnConstraintArguments(for: member) {
                        return [arg]
                    }
                    return []
                }
                
                if let function = expression.as(FunctionCallExprSyntax.self) {
                    return columnConstraintArguments(for: function)
                }
                return []
            }
            .reduce([]) { partialResult, next in
                partialResult + next
            }
            .sorted {
                $0.index < $1.index
            }
            .map {
                $0.expr()
            }
    }
    
    private func columnConstraintArguments(for member: MemberAccessExprSyntax) -> BindColumnConstraintArguments? {
        BindColumnConstraintArguments(key: member.declName.baseName.text, value: true)
    }

    private func columnConstraintArguments(for function: FunctionCallExprSyntax) -> [BindColumnConstraintArguments] {
        var member: [MemberAccessExprSyntax] = []
        
        function.calledExpression.as(MemberAccessExprSyntax.self).map {
            member.append($0)
        }
        
        member += function.arguments
            .compactMap {
                $0.expression.as(MemberAccessExprSyntax.self)
            }
        
        return member.compactMap {
            columnConstraintArguments(for: $0)
        }
    }
    
}

//BindColumnConstraint(_ codingKey: CodingTableKeyType,
//           isPrimary: Bool = false,
//           orderBy term: Order? = nil,
//           isAutoIncrement: Bool = false,
//           enableAutoIncrementForExistingTable: Bool = false,
//           onConflict conflict: ConflictAction? = nil,
//           isNotNull: Bool = false,
//           isUnique: Bool = false,
//           defaultTo defaultValue: LiteralValue? = nil,
//           isNotIndexed: Bool = false)
fileprivate enum BindColumnConstraintArguments {
    case primary(Bool)
//        case orderBy(Order?)
    case autoIncrement(Bool)
//        case enableAutoIncrementForExistingTable(Bool)
//        case onConflict(ConflictAction?)
//        case notNull(Bool)
    case unique(Bool)
//        case defaultTo(LiteralValue?)
//        case notIndexed(Bool)
    
    init?(key: String, value: Bool) {
        switch key {
        case "primary":
            self = .primary(value)
        case "autoIncrement":
            self = .autoIncrement(value)
        case "unique":
            self = .unique(value)
        default:
            return nil
        }
    }
    
    var index: Int {
        switch self {
        case .primary: return 1
//            case .orderBy: return 2
        case .autoIncrement: return 3
//            case .enableAutoIncrementForExistingTable: return 4
//            case .onConflict: return 5
//            case .notNull: return 6
        case .unique: return 7
//            case .defaultTo: return 8
//            case .notIndexed: return 9
        }
    }
    
    func expr() -> LabeledExprSyntax {
        switch self {
        case .primary(let value):
            return LabeledExprSyntax(
                label: "isPrimary",
                expression: BooleanLiteralExprSyntax(value)
            )
        case .autoIncrement(let value):
            return LabeledExprSyntax(
                label: "isAutoIncrement",
                expression: BooleanLiteralExprSyntax(value)
            )
        case .unique(let value):
            return LabeledExprSyntax(
                label: "isUnique",
                expression: BooleanLiteralExprSyntax(value)
            )
        }
    }
}
