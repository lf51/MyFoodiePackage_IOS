//
//  ProvenienzaIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

public enum ProvenienzaIngrediente:String,MyProEnumPack_L2,Codable /*: MyEnumProtocol, MyEnumProtocolMapConform*/ {
 
    // Nota Vocale 18.10
    
    public static var allCases: [ProvenienzaIngrediente] = [.km0, .italia/*, .europa, .restoDelMondo*/]
    public static var defaultValue: ProvenienzaIngrediente = .noValue
    
    public var id: String { self.createId() }
    
        case km0
        case italia
        case europa
        case restoDelMondo
    
        case noValue
    
    public func simpleDescription() -> String {
        
        switch self {
            
        case .km0: return "Km zero"
        case .italia: return "Made in Italy"
        case .europa: return "UE"
        case .restoDelMondo: return "Extra UE"
        case .noValue: return "n/d"
            
            }
        }
    
    public func shortDescription() -> String { // creata per la lista della spesa
        
        switch self {
            
        case .km0: return "Km0"
        case .italia: return "Italia"
        default: return "no quality Value"
            
            }
    }
    
    public func extendedDescription() -> String {
       
        switch self {
        case .km0:
            return "Prodotto di qualità locale"
        case .italia:
            return "Prodotto di qualità italiana"
        default:
            return "Nessuna etichetta di luogo specificata"
        }

    }
    
    func createId() -> String {
        self.simpleDescription().replacingOccurrences(of:" ", with:"").lowercased()
        }
    
    public func returnTypeCase() -> ProvenienzaIngrediente { self }
   
    public func imageAssociated() -> String {
        
        switch self {
            
        case .km0:
            return "🏠"//"house"
        case .italia:
            return "🇮🇹"
        case .europa:
            return "🇪🇺"
        case .restoDelMondo:
           return "🌍"//"globe.europe.africa"
        case .noValue:
            return "🌍"//"⁉️"
        }
    }
    
    public func orderAndStorageValue() -> Int {
    
        switch self {
        case .km0:
            return 1
        case .italia:
            return 2
        case .europa:
            return 3
        case .restoDelMondo:
            return 4
        case .noValue:
            return 5
        }
    }
    
   /* public static func convertiInCase(fromNumber: Int) -> ProvenienzaIngrediente {
    
        switch fromNumber {
            
        case 1:
            return .km0
        case 2:
            return .italia
        case 3:
            return .europa
        case 4:
            return .restoDelMondo
        default:
            return .defaultValue
        }
    } */

}
