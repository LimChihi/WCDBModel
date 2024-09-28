//
//  File.swift
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
    "DatabaseModel" : DatabaseModelMacro.self
]

final class DatabaseModelMacroTests: XCTestCase {
    
    func test_emptyAttribute() throws {
        assertMacroExpansion(
            """
            @DatabaseModel
            struct Model {
                let id: Int
                var name: String?
            }
            """,
            expandedSource: """
            struct Model {
                let id: Int
                var name: String?
            
                enum CodingKeys: String, CodingTableKey {
                    typealias Root = Model
                    static var objectRelationalMapping: TableBinding<CodingKeys> {
                        TableBinding(CodingKeys.self) {
                        }
                    }
                    case id
                    case name
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_transientMark() throws {
        assertMacroExpansion(
            """
            @DatabaseModel
            struct Model {
                let id: Int
                @Transient
                var name: String?
            }
            """,
            expandedSource: """
            struct Model {
                let id: Int
                @Transient
                var name: String?
            
                enum CodingKeys: String, CodingTableKey {
                    typealias Root = Model
                    static var objectRelationalMapping: TableBinding<CodingKeys> {
                        TableBinding(CodingKeys.self) {
                        }
                    }
                    case id
                }
            }
            """,
            macros: testMacros
        )
    }
    
    
    func test_attribute_primary() throws {
        assertMacroExpansion(
            """
            @DatabaseModel
            struct Model {
                @Attribute(.primary)
                let id: Int
                var name: String?
            }
            """,
            expandedSource: """
            struct Model {
                @Attribute(.primary)
                let id: Int
                var name: String?
            
                enum CodingKeys: String, CodingTableKey {
                    typealias Root = Model
                    static var objectRelationalMapping: TableBinding<CodingKeys> {
                        TableBinding(CodingKeys.self) {
                            BindColumnConstraint(.id, isPrimary: true)
                        }
                    }
                    case id
                    case name
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_attribute_primaryAutoIncrement() {
        assertMacroExpansion(
            """
            @DatabaseModel
            struct Model {
                @Attribute(.primary(.autoIncrement))
                let id: Int
                var name: String?
            }
            """,
            expandedSource: """
            struct Model {
                @Attribute(.primary(.autoIncrement))
                let id: Int
                var name: String?
            
                enum CodingKeys: String, CodingTableKey {
                    typealias Root = Model
                    static var objectRelationalMapping: TableBinding<CodingKeys> {
                        TableBinding(CodingKeys.self) {
                            BindColumnConstraint(.id, isPrimary: true, isAutoIncrement: true)
                        }
                    }
                    case id
                    case name
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_attribute_unique() {
        assertMacroExpansion(
            """
            @DatabaseModel
            struct Model {
                @Attribute(.unique)
                let id: Int
                var name: String?
            }
            """,
            expandedSource: """
            struct Model {
                @Attribute(.unique)
                let id: Int
                var name: String?
            
                enum CodingKeys: String, CodingTableKey {
                    typealias Root = Model
                    static var objectRelationalMapping: TableBinding<CodingKeys> {
                        TableBinding(CodingKeys.self) {
                            BindColumnConstraint(.id, isUnique: true)
                        }
                    }
                    case id
                    case name
                }
            }
            """,
            macros: testMacros
        )
    }
    
    
    func test_attribute_originalName() {
        assertMacroExpansion(
            """
            @DatabaseModel
            struct Model {
                @Attribute(originalName: "identifier")
                let id: Int
                var name: String?
            }
            """,
            expandedSource: """
            struct Model {
                @Attribute(originalName: "identifier")
                let id: Int
                var name: String?
            
                enum CodingKeys: String, CodingTableKey {
                    typealias Root = Model
                    static var objectRelationalMapping: TableBinding<CodingKeys> {
                        TableBinding(CodingKeys.self) {
                        }
                    }
                    case id = "identifier"
                    case name
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_public() throws {
        assertMacroExpansion(
            """
            @DatabaseModel
            public struct Model {
                let id: Int
                var name: String?
            }
            """,
            expandedSource: """
            public struct Model {
                let id: Int
                var name: String?
            
                public enum CodingKeys: String, CodingTableKey {
                    public typealias Root = Model
                    public static var objectRelationalMapping: TableBinding<CodingKeys> {
                        TableBinding(CodingKeys.self) {
                        }
                    }
                    case id
                    case name
                }
            }
            """,
            macros: testMacros
        )
    }
    
}

#endif
