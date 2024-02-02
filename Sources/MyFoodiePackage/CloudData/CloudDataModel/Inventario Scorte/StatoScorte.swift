//
//  File.swift
//  
//
//  Created by Calogero Friscia on 04/12/23.
//

import Foundation
import SwiftUI

public enum StatoScorte:String,MyProEnumPack_L0 {
    
    public static var allCases:[StatoScorte] = [.inStock,.inEsaurimento,.esaurito]
    
    case inEsaurimento = "in esaurimento"
    case esaurito = "esaurite"
    case inStock = "in stock"
  //  case inArrivo = "in arrivo" // deprecato
    case outOfStock = "out of stock"
    
    public func orderAndStorageValue() -> Int {
        
        switch self {
            
        case .inStock:
            return 0
        case .inEsaurimento:
            return 1
        case .esaurito:
            return 2
       /* case .inArrivo:
            return 1*/
        case .outOfStock:
            return 3
        }

    }
    
    public func simpleDescription() -> String {
     
        switch self {
            
        case .inStock:
            return "in Stock"
        case .inEsaurimento:
            return "ai Minimi"
        case .esaurito:
            return "terminate"
       /* case .inArrivo:
            return "in Arrivo"*/
        case .outOfStock:
            return "out of stock"
        }
    }
    
    public func returnTypeCase() -> StatoScorte {
        self
    }
    
    public func imageAssociata() -> String {
        
        switch self {
            
        case .inStock:
            return "storefront" //"house"
        case .inEsaurimento:
            return "clock.badge.exclamationmark"
        case .esaurito:
            return "alarm.waves.left.and.right"
       /* case .inArrivo:
            return "creditcard"*/
        case .outOfStock:
            return "x.circle"
        }
    }
    
    public func coloreAssociato() -> Color {
        
        switch self {
            
        case .inStock:
            return .seaTurtle_3
        case .inEsaurimento:
            return .yellow.opacity(0.7)
        case .esaurito:
            return .red.opacity(0.7)
      /*  case .inArrivo:
            return .seaTurtle_4.opacity(0.7)*/
        case .outOfStock:
            return .gray
        }
        
    }
    
    public func coloreAssociatoNotOpacity() -> Color {
        
        switch self {
            
        case .inStock:
            return .seaTurtle_3
        case .inEsaurimento:
            return .yellow
        case .esaurito:
            return .red
      /*case .inArrivo:
            return .seaTurtle_4*/
        case .outOfStock:
            return .gray
        }
    }
}

extension StatoScorte:Codable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        
        let value = try container.decode(String.self)
        let number = Int(value)
        
        self = Self.decodeStatus(from: number)
        
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        
        let value = self.encodeAsString()
        
        try container.encode(value)
        
    }
    
    public func encodeAsString() -> String {
        
        let value = self.orderAndStorageValue()
        return String(value)
    }
    
    private static func decodeStatus(from integer:Int?) -> StatoScorte {
        
        switch integer {
            
        case 0:
            return .inStock
        case 1:
            return .inEsaurimento
        case 2:
            return .esaurito
        default:
            return .outOfStock
        
        }
        
    }
    
}
