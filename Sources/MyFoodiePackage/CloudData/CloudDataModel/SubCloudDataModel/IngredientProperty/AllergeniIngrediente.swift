//
//  Allergeni.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation
import SwiftUI

public enum AllergeniIngrediente:MyProStarterPack_L0,Codable/*MyProStarterPack_L1,MyProEnumPack_L0,MyProCloudPack_L0*/ /*: MyEnumProtocol, MyProModelPack_L0*/{
    

    
   /* func returnNewModel() -> (tipo: AllergeniIngrediente, nometipo: String) {
        (AllergeniIngrediente.noValue,"Nuovo Allergene")
    } */
    
   /* func returnModelTypeName() -> String {
       "Nuovo Allergene"
    } */ // deprecata
    
    public func returnModelRowView() -> some View {
        EmptyView()
    }
    
   

    public var intestazione: String {get { self.simpleDescription() } set{ } }
    public var descrizione: String { get { self.extendedDescription() } set { } }
    
    public static var allCases: [AllergeniIngrediente] = [.arachidi_e_derivati,.anidride_solforosa_e_solfiti,.crostacei,.fruttaAguscio,.glutine,.latte_e_derivati,.lupini,.molluschi,.pesce,.sedano,.senape,.sesamo,.soia,.uova_e_derivati]
    public static var defaultValue: AllergeniIngrediente = AllergeniIngrediente.noValue
    
    //Potremmo associare un icona ad ogni allergene e utilizzare la simpleDescription() al posto dei RawValue
    case arachidi_e_derivati
    case fruttaAguscio
    case latte_e_derivati
    case molluschi
    case crostacei
    case pesce
    case uova_e_derivati
    case sesamo
    case soia
    case glutine
    case lupini
    case senape
    case sedano
    case anidride_solforosa_e_solfiti
    
    case noValue // lo usiamo per avere un valore di default Nullo
 
    public var id: String { get { self.createId() } set { } }
        
    public func returnTypeCase() -> AllergeniIngrediente {
        return self 
    }
 
    public func simpleDescription() -> String {
        
        switch self {
            
        case .arachidi_e_derivati: return "Arachidi & derivati"
        case .fruttaAguscio: return "Frutta a guscio"
        case .latte_e_derivati: return "Latte & derivati"
        case .molluschi: return "Molluschi"
        case .pesce: return "Pesce"
        case .sesamo: return "Sesamo"
        case .soia: return "Soia"
        case .crostacei: return "Crostacei"
        case .glutine: return "Glutine"
        case .lupini: return "Lupini"
        case .senape: return "Senape"
        case .sedano: return "Sedano"
        case .anidride_solforosa_e_solfiti: return "Anidride Solforosa & Solfiti"
        case .uova_e_derivati: return "Uova & derivati"
        case .noValue: return "Nessun Allergene"
        
        }
        
    }
    
    public func extendedDescription() -> String {
        print("Dentro DishAllergeni. DescrizioneEstesa non sviluppata")
        return ""
    }
    
    public func createId() -> String {
        
        self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased() // standardizziamo le stringhe ID in lowercases senza spazi
    }
    
    public func imageAssociated() -> String {
        
        switch self {
        case .arachidi_e_derivati:
            return "🥜"
        case .latte_e_derivati:
            return "🥛"
        case .pesce:
            return "🐟"
        case .uova_e_derivati:
            return "🐔"
        case .glutine:
            return "laurel.leading"
        default:
            return ""
        }
    }
    
    public func orderAndStorageValue() -> Int {
        
        switch self {
            
        case .arachidi_e_derivati: return 2
        case .fruttaAguscio: return 4
        case .latte_e_derivati: return 6
        case .molluschi: return 8
        case .crostacei: return 3
        case .pesce: return 9
        case .uova_e_derivati: return 14
        case .sesamo: return 12
        case .soia: return 13
        case .glutine: return 5
        case .lupini: return 7
        case .senape: return 11
        case .sedano: return 9
        case .anidride_solforosa_e_solfiti: return 1
            
        case .noValue: return 0
          
        }
        
    }
    
  /*  public static func convertiInCase(fromNumber: Int) -> AllergeniIngrediente {
        
        switch fromNumber {
            
        case 1: return .arachidi_e_derivati
        case 2: return .fruttaAguscio
        case 3: return .latte_e_derivati
        case 4: return .molluschi
        case 5: return .crostacei
        case 6: return .pesce
        case 7: return .uova_e_derivati
        case 8: return .sesamo
        case 9: return .soia
        case 10: return .glutine
        case 11: return .lupini
        case 12: return .senape
        case 13: return .sedano
        case 14: return .anidride_solforosa_e_solfiti
            
        default: return .defaultValue
            
        }
    } */

    public static func returnAllergeniIn(ingredients: [IngredientModel]...) -> [AllergeniIngrediente] {
     
           var allergeniPiatto:[AllergeniIngrediente] = []
           
        for list in ingredients {
            
            for ingredient in list {
                
                let allergeneIngre:[AllergeniIngrediente] = ingredient.allergeni ?? []
                
                allergeniPiatto.append(contentsOf: allergeneIngre)
            }
 
        }

           let setAllergeniPiatto = Set(allergeniPiatto)
      
           return Array(setAllergeniPiatto)
   
    } // deprecata in futuro - Creata una chiamata nel piatto ad una funziona che calcola gli allergeni presenti negli ingredienti
    
    
    
    
    
}
