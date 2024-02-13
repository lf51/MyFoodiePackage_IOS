//
//  File.swift
//  
//
//  Created by Calogero Friscia on 02/02/24.
//

import Foundation
import SwiftUI

public enum ProductType:String,Codable,CaseIterable {
    
    static public var allCases: [ProductType] = [.noValue,.food,.beverage]
    
    case food
    case beverage
    case noValue = "n/d"
    
   public func imageAssociated() -> (system:String,color:Color) {
        
        switch self {
        case .food:
            return ("fork.knife",Color.yellow)
        case .beverage:
            return ("wineglass",Color.orange)
        case .noValue:
            return ("x.circle",Color.red)
        }
    }
}
