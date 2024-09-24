//
//  File.swift
//  WCDBModel
//
//  Created by lim on 25/9/2024.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(WCDBModelMacros)
@testable import WCDBModelMacros

private let testMacros: [String: Macro.Type] = [
    "DatabaseModel" : DatabaseModelMacro.self
]

final class DatabaseModelMacroTests: XCTestCase {
    
    func test_memberAttribute() throws {
        assertMacroExpansion(
            """
            @DatabaseModel
            struct Model {
              let id: Int
              let name: String?
            }
            """,
            expandedSource: """
            struct Model {
              @_PersistedProperty
              let id: Int
              @_PersistedProperty
              let name: String?
            }
            """,
            macros: testMacros
        )
    }
    
    func test_memberAttribute_transientMark() throws {
        assertMacroExpansion(
            """
            @DatabaseModel
            struct Model {
              let id: Int
              @Transient
              let name: String?
            }
            """,
            expandedSource: """
            struct Model {
              @_PersistedProperty
              let id: Int
              @Transient
              let name: String?
            }
            """,
            macros: testMacros
        )
    }
    
}

#endif
