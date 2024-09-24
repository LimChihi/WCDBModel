import WCDBModel
import WCDBSwift

struct Sample: TableCodable {
    var id: Int = 0
    var name: String? = nil
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = Sample
        static var objectRelationalMapping: TableBinding<CodingKeys> {
            TableBinding(CodingKeys.self) {
                BindColumnConstraint(id, isPrimary: true)
            }
        }
        case id
        case name
    }
}


struct GenSample {
    
    var id: Int = 0
    var name: String? = nil
    
}
