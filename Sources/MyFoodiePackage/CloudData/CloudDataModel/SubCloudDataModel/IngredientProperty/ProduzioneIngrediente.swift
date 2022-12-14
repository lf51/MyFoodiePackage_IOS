//
//  ProduzioneIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

public enum ProduzioneIngrediente:MyProEnumPack_L2,MyProCloudPack_L0,Codable /*: MyEnumProtocol, MyEnumProtocolMapConform */{
    
    // Nota 18.10
    public static var allCases: [ProduzioneIngrediente] = [.biologico/*,.convenzionale*/]
    
    public static var defaultValue: ProduzioneIngrediente = .noValue
    
    public var id: String { self.createId()}

    case convenzionale
    case biologico
    case noValue
   
    public func simpleDescription() -> String {
        
        switch self {
            
        case .convenzionale: return "Metodo Convenzionale"
        case .biologico: return "Metodo Biologico"
        case .noValue: return "noValue"
        
        }
        
    }
    
    public func extendedDescription() -> String {
        
        switch self {
            
        case .convenzionale:
            return "Prodotto con metodo Convenzionale: Possibile uso intensivo di prodotti di sintesi chimica."
        case .biologico:
            return "Prodotto con metodo Biologico: Esclude l'utilizzo di prodotti di sintesi, salvo deroghe limitate e regolate."
        case .noValue:
            return "Metodo di Produzione non specificato."
        }
     
    }
    
    func createId() -> String {
        self.simpleDescription().replacingOccurrences(of:" ", with:"").lowercased()
    }
    
    public func imageAssociated() -> String {
        
        switch self {
            
        case .convenzionale:
            return "🚜"
        case .biologico:
            return "☘️"//"♻️"
        case .noValue:
            return "⁉️"
       
        }
    }
    
    public func returnTypeCase() -> ProduzioneIngrediente { self }
    
    public func orderAndStorageValue() -> Int {
        
        switch self {
            
        case .convenzionale:
            return 2
        case .biologico:
            return 1
        case .noValue:
            return 0
   
        }
    }
    
    public static func convertiInCase(fromNumber: Int) -> ProduzioneIngrediente {
      
        switch fromNumber {
            
        case 1:
            return .biologico
        case 2:
            return .convenzionale
            
        default:
            return .defaultValue
            
        }
    }
    
    // Fuori dai Protocolli
    
  
    
    
}
