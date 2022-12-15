//
//  AvailabilityMenu.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/04/22.
//

import Foundation

public enum AvailabilityMenu:Hashable,MyProEnumPack_L1,Codable {

    public static var allCases:[AvailabilityMenu] = [.dataEsatta,.intervalloAperto,.intervalloChiuso]
    public static var defaultValue: AvailabilityMenu = .noValue
    
    case dataEsatta
    case intervalloChiuso
    case intervalloAperto
    
    case noValue
    
    public func simpleDescription() -> String {
        
        switch self {
            
        case .dataEsatta:
            return "Data Esatta"
        case .intervalloChiuso:
            return "Intervallo Chiuso"
        case .intervalloAperto:
            return "Intervallo Aperto"
        case .noValue:
            return ""
        }
    }
    
    public func returnTypeCase() -> AvailabilityMenu {
        self
    }
    
    public func orderAndStorageValue() -> Int {
        switch self {
        case .dataEsatta:
            return 1
        case .intervalloChiuso:
            return 2
        case .intervalloAperto:
            return 3
        case .noValue:
            return 0
        }
    }
    
   /* public static func convertiInCase(fromNumber: Int) -> AvailabilityMenu {
        switch fromNumber {
            
        case 1: return .dataEsatta
        case 2: return .intervalloChiuso
        case 3: return .intervalloAperto
        default: return .noValue
        }
    } */
    
    public func shortDescription() -> String {
        
        switch self {
            
        case .dataEsatta:
            return "Esatto"
        case .intervalloChiuso:
            return "Chiuso"
        case .intervalloAperto:
            return "Aperto"
        case .noValue:
            return ""
        }
    }
    
    public func extendedDescription() -> String {
        
        switch self {
            
        case .dataEsatta:
            return "Programma il Menu in una data esatta"
        case .intervalloChiuso:
            return "Programma il Menu con un Inizio e una Fine"
        case .intervalloAperto:
            return "Programma il Menu con un Inizio senza una Fine"
       case .noValue:
            return "Seleziona il tipo di intervallo temporale"
        }
        
    }
    
    public func iteratingAvaibilityMenu() -> (pre:String,post:String,showPostDate:Bool) {
        
        var incipit: String = ""
        var postFix: String = ""
        var showPost: Bool = false
        
        switch self {
            
        case .dataEsatta:
            incipit = "il"
            postFix = ""
        case .intervalloChiuso:
            incipit = "dal"
            postFix = "al"
            showPost = true
        case .intervalloAperto:
            incipit = "dal"
            postFix = "Fine indeterminata"
        case .noValue:
            incipit = ""
            postFix = ""
        }
        
        return (incipit,postFix,showPost)
    }
    
}
