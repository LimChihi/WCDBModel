//
//  File.swift
//  WCDBModel
//
//  Created by lim on 25/9/2024.
//

import Foundation

public struct Attribute {
    
    public struct Option {
        
        public static var primary: Option {
            .init()
        }
        
        public static func primary(_ options: PrimaryOption...) -> Option {
            .init()
        }
        
        public static var unique: Option {
            .init()
        }
        
        public struct PrimaryOption {
            
            public static var autoIncrement: PrimaryOption {
                .init()
            }
            
//            public static func order(_ order: SortOrder) -> PrimaryOption {
//                .init()
//            }
            
        }
        
    }
    
//    @frozen
//    public enum SortOrder : Hashable, Codable, Sendable {
//        
//        /// The ordering where if compare(a, b) == .orderedAscending,
//        /// a is placed before b.
//        case forward
//        
//        /// The ordering where if compare(a, b) == .orderedAscending,
//        /// a is placed after b.
//        case reverse
//        
//    }
    
}
