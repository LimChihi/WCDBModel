import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


@main
struct WCDBModelPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        DatabaseModelMacro.self
    ]
}
