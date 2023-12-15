//
//  StatusModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 12/06/22.
//

import Foundation
import SwiftUI

public enum StatusTransition:String,MyProEnumPack_L0,Equatable {
    
    public static var allCases: [StatusTransition] = [.disponibile,.inPausa,.archiviato]

    case disponibile
    case inPausa
    case archiviato

    public func simpleDescription() -> String {
        
        switch self {
        case .disponibile:
            return "disponibile"
        case .inPausa:
            return "in Pausa"
        case .archiviato:
            return "non disponibile"
        }
    }
    
    public func returnTypeCase() -> StatusTransition {
        self
    }
    
    public func orderAndStorageValue() -> Int {
        switch self {
        case .disponibile:
            return 0
        case .inPausa:
            return 1
        case .archiviato:
            return 2
        }
    }
    
    public func colorAssociated() -> Color {
        
        switch self {
            
        case .disponibile:
            return Color.green
        case .inPausa:
            return Color.yellow
        case .archiviato:
            return Color.red
        }
    }
    
   public static func decodeStatus(from number: Int) -> StatusTransition {
        
        switch number {
  
        case 0:
            return .disponibile
        case 1:
            return .inPausa
        default:
            return .archiviato

        }
    }
    public func encodeStatusAsString() -> String {
        let value = self.orderAndStorageValue()
        return String(value)
    }
}

public enum StatusModel:Equatable { // vedi Nota Consegna 17.07
    
   // case noStatus
    case bozza//(StatusTransition)
    case completo//(StatusTransition)
    
    public func imageAssociated() -> String {
        
        switch self {
        /*case .noStatus:
            return "x.circle"*/
        case .bozza:
           return "hammer.circle.fill"//"doc.badge.gearshape" //  // moon.fill
        case .completo:
            return "circle.fill"//"circle.dashed.inset.filled"//"circle.fill"
        }
    }
    
    public func transitionStateColor() -> Color {
        
        Color.brown
       /* switch self {
        case .noStatus:
            return Color.gray
        case .bozza(let statusTransition):
            return statusTransition.colorAssociated()
        case .completo(let statusTransition):
            return statusTransition.colorAssociated()
        }*/
        
    } // deprecata in futuro
    
   /* public func simpleDescription() -> String {
        
        switch self {
        case .noStatus:
            return "Nuovo"
        case .bozza(let statusTransition):
            return statusTransition.simpleDescription()
        case .completo(let statusTransition):
            return statusTransition.simpleDescription()
        }
    }*/// Deprecata
    
    public func simpleDescription() -> String {
        
        switch self {
      /* case .noStatus:
            return "Nuovo(???)"*/
        case .bozza:
            return "bozza"
        case .completo:
            return "completo"
        }
    }
    
   /* public func checkStatusTransition(check:StatusTransition) -> Bool {
        
        switch self {
        case .noStatus:
            return false
        case .bozza(let statusTransition):
            return statusTransition == check
        case .completo(let statusTransition):
            return statusTransition == check
        }
        
    }*/ // deprecata
    
   /* public func changeStatusTransition(changeIn: StatusTransition) -> Self {
        
        switch self {
        case .noStatus:
            return .noStatus
        case .bozza(_):
            return .bozza(changeIn)
        case .completo(_):
            return .completo(changeIn)
        }
        
    }*/// deprecata
    
    public func checkStatusBozza() -> Bool {
        
        switch self {
        case .bozza:
            return true
        default: return false
        }
        
    } // deprecata in futuro
    
   /* public func orderAndStorageValue() -> Int {
        
        switch self {
        case .noStatus:
            return 0
        case .bozza(let statusTransition):
            let number = 1 + statusTransition.orderAndStorageValue()
            return number
        case .completo(let statusTransition):
            let number = 4 + statusTransition.orderAndStorageValue()
            return number
        }
    }*/// deprecata in futuro
    public func orderAndStorageValue() -> Int {
         
         switch self {
         /*case .noStatus:
             return 0*/
         case .bozza:
             return 1
         case .completo:
             return 2
         }
     }
}

/*extension StatusModel:Codable {
    
    public static func decodeStatus(from number: Int?) -> StatusModel {
        
        switch number {
  
        case 1:
            return .bozza(.disponibile)
        case 2:
            return .bozza(.inPausa)
        case 3:
            return .bozza(.archiviato)
        case 4:
            return .completo(.disponibile)
        case 5:
            return .completo(.inPausa)
        case 6:
            return .completo(.archiviato)
            
        default:
            return .noStatus

        }
    }
    public func encodeStatusAsString() -> String {
        let value = self.orderAndStorageValue()
        return String(value)
    }

    public init(from decoder: Decoder) throws {
          
          let container = try decoder.singleValueContainer()
          
          let value = try container.decode(String.self)
          let number = Int(value)
          self = Self.decodeStatus(from: number)
      }
      
      public func encode(to encoder: Encoder) throws {
          
          var container = encoder.singleValueContainer()
          
          let value = self.encodeStatusAsString()
          try container.encode(value)
          
      }
    
}*/// deprecata
