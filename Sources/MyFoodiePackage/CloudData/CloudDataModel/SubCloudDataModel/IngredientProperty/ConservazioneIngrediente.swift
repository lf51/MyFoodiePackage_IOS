//
//  ConservazioneIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

public enum ConservazioneIngrediente:MyProEnumPack_L2,Codable /*: MyEnumProtocol, MyEnumProtocolMapConform */{
    
    public static var allCases: [ConservazioneIngrediente] = [.fresco,.congelato,.surgelato,.altro]
    public static var defaultValue: ConservazioneIngrediente = .noValue // deprecato in futuro togliere dal protocollo
    
    public var id: String {self.createId()}

    case congelato
    case surgelato
    case fresco
    case altro
    case noValue
 
    public func simpleDescription() -> String {
      /*  print("Dentro Conservazione Ingrediente .simpleDescription() di \(self.hashValue)") */
        
        switch self {

        case .surgelato: return "Surgelato"
        case .congelato: return "Congelato"
        case .fresco: return "Fresco"
        case .altro: return "Altro"
        case .noValue: return ""
            
        }
        
    }
        
    public func extendedDescription() -> String {
        
        switch self {
            
        case .congelato:
            return "potrebbe essere Congelato"
        case .surgelato:
            return "potrebbe essere Surgelato"
        case .fresco:
            return "prodotto fresco"
        case .altro:
            return "metodo di conservazione generico"
        case .noValue:
            return "Indicare metodo di conservazione"

        }

    }
    
    public func createId() -> String {
        self.simpleDescription().replacingOccurrences(of:" ", with: "").lowercased()
    }
    
    public func returnTypeCase() -> ConservazioneIngrediente { self }
    
    public func imageAssociated() -> String {
       
        switch self {
        
        case .congelato:
            return "🥶"
        case .surgelato:
            return "❄️"
        case .fresco:
            return "🌱"
        case .altro:
            return "🥫"//☀️"//"🌞"//"🌀" //heart"
        case .noValue:
            return "circle.slash"
   
        }
     
    }
    
    public func orderAndStorageValue() -> Int {
        
        switch self {
        
        case .congelato:
            return 2
        case .surgelato:
            return 1
        case .fresco:
            return 4
        case .altro:
            return 3
        case .noValue:
            return 0
      
        }
    }
    
  /*  public static func convertiInCase(fromNumber: Int) -> ConservazioneIngrediente {
        
        switch fromNumber {
            
            case 0:
                return .noValue
            case 1:
              return .altro
            case 2:
                return .surgelato
            case 3:
                return .congelato
            default:
                return .noValue
            
        }
    }*/
    
}
