// The Swift Programming Language
// https://docs.swift.org/swift-book

//@attached(extension, conformances: TableCodable)
@attached(member, names: named(CodingKeys))
public macro DatabaseModel() = #externalMacro(module: "WCDBModelMacros", type: "DatabaseModelMacro")

@attached(peer)
public macro Transient() = #externalMacro(module: "WCDBModelMacros", type: "TransientMacro")

@attached(peer)
public macro Attribute(_ options: Attribute.Option...) = #externalMacro(module: "WCDBModelMacros", type: "AttributeMacro")
