//
//  StatusModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 12/06/22.
//

import Foundation
import SwiftUI

public enum StatusTransition:MyProEnumPack_L0,Equatable {
    
    public static var allCases: [StatusTransition] = [.disponibile,.inPausa,.archiviato]
 //   static var defaultValue: StatusTransition = .archiviato
    
    case disponibile // Rimette in moto da una Pausa
    case inPausa // Stop temporaneo --> Solo per gli ingredienti, quando temporaneamente in pausa vorrei dare la possibilità all'utente di sostituirli.
    case archiviato  // Stop incondizionato

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
    
    func colorAssociated() -> Color {
        
        switch self {
            
        case .disponibile:
            return Color.green
        case .inPausa:
            return Color.yellow
        case .archiviato:
            return Color.red
        }
    }
}

public enum StatusModel:Equatable,MyProCloudPack_L0 { // vedi Nota Consegna 17.07
    
   // case nuovo // deprecato 07.09
    case bozza(StatusTransition? = nil)
    case completo(StatusTransition)
    
    public func imageAssociated() -> String {
        
        switch self {
        case .bozza:
           return "hammer.circle.fill"//"doc.badge.gearshape" //  // moon.fill
        case .completo:
            return "circle.dashed.inset.filled"//"circle.fill"
        }
    }
    
    public func transitionStateColor() -> Color {
        
        switch self {
        case .bozza(let statusTransition):
            return statusTransition?.colorAssociated() ?? Color.gray
        case .completo(let statusTransition):
            return statusTransition.colorAssociated()
        }
        
    }
    
    public func simpleDescription() -> String {
        
        switch self {
        case .bozza(let statusTransition):
            return statusTransition?.simpleDescription() ?? "Nuovo"
        case .completo(let statusTransition):
            return statusTransition.simpleDescription()
        }
    }
    
    public func checkStatusTransition(check:StatusTransition) -> Bool {
        
        switch self {
        case .bozza(let statusTransition):
            return statusTransition == check
        case .completo(let statusTransition):
            return statusTransition == check
        }
        
    }
    
    public func changeStatusTransition(changeIn: StatusTransition) -> Self {
        
        switch self {
        case .bozza(_):
            return .bozza(changeIn)
        case .completo(_):
            return .completo(changeIn)
        }
        
    }
    
    public func checkStatusBozza() -> Bool {
        
        switch self {
        case .bozza(_):
            return true
        default: return false
        }
        
    }
    
    public func orderAndStorageValue() -> Int {
        
        switch self {
        case .bozza(let statusTransition):
            let number = statusTransition == nil ? 0 : (1 + statusTransition!.orderAndStorageValue())
            return number
        case .completo(let statusTransition):
            let number = 4 + statusTransition.orderAndStorageValue()
            return number
        }
    }
    
    public static func convertiInCase(fromNumber: Int) -> StatusModel {
        
        switch fromNumber {
            
        case 0:
            return .bozza()
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
            return .bozza()
        }
    }
    
  /*  func estrapolaStatusTransition() -> StatusTransition? {
        
        switch self {
        case .bozza(let statusTransition):
            return statusTransition
        case .completo(let statusTransition):
            return statusTransition
        }
    } */
    

}
