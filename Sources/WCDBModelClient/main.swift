import WCDBModel
import WCDBSwift

struct Sample: TableCodable {
    var id: Int = 0
    var name: String? = nil
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = Sample
        static var objectRelationalMapping: TableBinding<CodingKeys> {
            TableBinding(CodingKeys.self) {
                BindColumnConstraint(id, isPrimary: true, isAutoIncrement: true)
            }
        }
        case id = "identifier"
        case name
    }
    
}

@DatabaseModel
public struct GenSample: TableCodable {
    
    @Attribute(.primary(.autoIncrement), .unique, originalName: "identifier")
    var id: Int = 0
    @Transient
    var name: String? = nil
    
}
