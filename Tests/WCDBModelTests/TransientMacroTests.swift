//
//  TransientMacroTests.swift
//  WCDBModel
//
//  Created by lim on 25/9/2024.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(WCDBModelMacros)
@testable import WCDBModelMacros

private let testMacros: [String: Macro.Type] = [
    "Transient" : TransientMacro.self
]

final class TransientMacroTests: XCTestCase {
    
    func test_memberAttribute() throws {
        assertMacroExpansion(
            """
            struct Model {
                let id: Int
                @Transient
                var name: String?
            }
            """,
            expandedSource: """
            struct Model {
                let id: Int
                var name: String?
            }
            """,
            macros: testMacros
        )
    }
    
}

#endif

