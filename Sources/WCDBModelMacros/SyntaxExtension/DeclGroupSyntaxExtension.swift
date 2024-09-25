//
//  File.swift
//  WCDBModel
//
//  Created by lim on 25/9/2024.
//

import SwiftSyntax

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

