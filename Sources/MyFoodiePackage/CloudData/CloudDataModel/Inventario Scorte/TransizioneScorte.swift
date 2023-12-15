//
//  File.swift
//  
//
//  Created by Calogero Friscia on 04/12/23.
//

import Foundation
import SwiftUI

public enum TransizioneScorte:String {
    
    case pending
    case inArrivo = "in arrivo"
    case validate
    
    public func imageAssociata() -> String {
        
        switch self {
            
        case .pending:
            return "cart.badge.plus.fill"
        case .inArrivo:
            return "creditcard"
        case .validate:
            return "storefront"
        }
    }
    
    public func coloreAssociato() -> Color {
        
        switch self {

        case .pending:
            return .yellow.opacity(0.7)
       case .inArrivo:
            return .seaTurtle_4.opacity(0.7)
        case .validate:
            return .gray
        }
        
    }
}
