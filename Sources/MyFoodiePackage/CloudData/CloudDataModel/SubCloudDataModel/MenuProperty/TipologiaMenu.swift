//
//  TipologiaMenu.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/04/22.
//

import Foundation

public enum PaxMenuFisso:MyProEnumPack_L1,MyProCloudPack_L0 /*:MyEnumProtocolMapConform */ {
    
    public static var defaultValue: PaxMenuFisso = .uno
    public static var allCases: [PaxMenuFisso] = [.uno,.due]
    
    case uno
    case due
    
    public func simpleDescription() -> String {
        
        switch self {
        case .uno:
            return "1"
        case .due:
            return "2"
        }
    }
    
    public func extendedDescription() -> String {
        
        switch self {
        case .uno:
            return "una persona"
        case .due:
            return "due persone"
        }
    }
    
    public func imageAssociated() -> String {
        
        switch self {
        case .uno:
            return "person.fill"
        case .due:
            return "person.2.fill"
        }
    }
    
    public func returnTypeCase() -> PaxMenuFisso {
        PaxMenuFisso.uno
    }
    
    public func orderAndStorageValue() -> Int {
        switch self {
        case .uno:
            return 1
        case .due:
            return 2
        }
    }
    
    public static func convertiInCase(fromNumber: Int) -> PaxMenuFisso {
        switch fromNumber {
        case 1: return .uno
        case 2: return .due
        default: return .uno
        }
    }
}


public enum TipologiaMenu:Identifiable, Equatable, MyProEnumPack_L2 /*: MyEnumProtocol, MyEnumProtocolMapConform*/ {
   
    public static var allCases: [TipologiaMenu] = [.allaCarta(),.fisso(persone: .uno, costo: "n/d")]
    public static var defaultValue: TipologiaMenu = .noValue
    
    public var id:String {self.createId()}
    
    case fisso(persone:PaxMenuFisso,costo: String)
    case allaCarta(TipologiaMenu.DiSistema? = nil)
  //  case delGiorno
   // case delloChef
    
    case noValue
    
    public func returnMenuPriceValue() -> (asString:String,asDouble:Double) {
        
        switch self {
        case .fisso(_, let costo):
            let dCost = Double(costo) ?? 0.0
            return (costo,dCost)
        default:
            return ("0.00",0.0)
        }
    }
    
    public func simpleDescription() -> String {
        
        switch self {
        case .fisso:
            return "Fisso"
        case .allaCarta(let value):
            let string = value == nil ? "Alla Carta" : value!.simpleDescription()
            return string
      //  case .delGiorno:
        //   return "piatti del Giorno"
       // case .delloChef:
        //    return "i consigliati"
        case .noValue:
            return "Selezionare tipologia menu"

        }
    }
    
    public func extendedDescription() -> String {
        
        switch self {
            
        case .fisso(let persone, let costo):
            return "Il costo del menu è di \(formattaPrezzo(price: costo)) per \(persone.extendedDescription())."
        case .allaCarta:
            return "Il costo del menu non è predeterminato."
      //  case .delGiorno:
        //    return "Vedi Info"
       // case .delloChef:
         //   return "Vedi info"
        case .noValue:
            return "Selezionare tipologia menu"
           
        }

    }
    
    // Valutiamo di Renderla Pubblica, anche se al momento 21.09 abbiamo potuto utilizzare il format con il currencyCode. Qui richiederebbe di modificare una funzione che viene dal protocollo ed è troppo SBATTI
    private func formattaPrezzo(price:String) -> String {
        
        let currencyCode = Locale.current.currency?.identifier ?? "EUR"
        let newPrice:String
 
        if let point = price.firstIndex(of: ".") {
            
            let pre = price.prefix(upTo: point)
            let post = price.suffix(from: point)
          //  let post2 = post.replacingOccurrences(of: ",", with: ".")
            
            if post.count == 1 { newPrice = pre.appending("\(post)00")}
            else if post.count == 2 { newPrice = pre.appending("\(post)0") }
            else { newPrice = pre.appending("\(post)") }
            
        } else {
            newPrice = price.appending(".00")
        }
           
        return "\(currencyCode) \(newPrice)"
    }
    
    func createId() -> String {
       // self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased()
        self.returnTypeCase().simpleDescription().replacingOccurrences(of: " ", with: "").lowercased() // Vedi Nota 09.11
    }
    
    public func editingAvaible() -> Bool {
        
        switch self {
            
        case .fisso:
            return true
        default:
            return false
        }
        
    }
    
    public func returnTypeCase() -> Self {
        
        switch self {
            
        case .fisso(_,_):
            return .fisso(persone: .uno, costo: "n/d")
        
        case .allaCarta(_):
            return .allaCarta()
            
        case .noValue:
            return self
            
        }
    }
    
    public func imageAssociated() -> String {
        
        switch self {
            
        case .fisso(_, _):
            return "dollarsign.circle"
            
        case .allaCarta(let value):
            let image = value == nil ? "cart" : value!.imageAssociated()
            return image
      //  case .delGiorno:
        //    return "clock.arrow.circlepath"
     //   case .delloChef:
       //     return "mustache.fill" //"👨🏻‍🍳"
        case .noValue:
            return "gear.badge.xmark"
        }
    }
    
    public func orderAndStorageValue() -> Int {
        
        switch self {
            
        case .fisso(_, _):
            return 1
        case .allaCarta:
            return 2
        case .noValue:
           return 0
        }
    } // Deprecbile
    
    /// a differenza della funzione standard, questa Plus ritorna un Any, e quindi ci permette di ritornare valori diversi per ogni case.
    public func orderAndStorageValuePlus() -> Any {
        
        switch self {
            
        case .fisso(let pax, let price):
            return ["pax":pax.orderAndStorageValue(),"price":price]
        case .allaCarta(let diSistema):
            let value = diSistema == nil ? 2 : diSistema!.orderAndStorageValue()
            return value
        case .noValue:
           return 0
        }
    }
    
    public static func convertiFromAny(value:Any?) -> TipologiaMenu {
        
        if let int = value as? Int {
            
            switch int {
            case 2: return TipologiaMenu.allaCarta()
            case 3: return TipologiaMenu.allaCarta(.delGiorno)
            case 4: return TipologiaMenu.allaCarta(.delloChef)
            default: return TipologiaMenu.defaultValue
                
            }
            
        } else if let combo = value as? [String:Any] {
            
            let paxInt = combo["pax"] as? Int ?? 1
            let paxCase = PaxMenuFisso.convertiInCase(fromNumber: paxInt)
            let price = combo["price"] as? String ?? ""
            
            return TipologiaMenu.fisso(persone: paxCase, costo: price)
            
        }
        
        else { return TipologiaMenu.noValue }
        
    }
    
    public func isDiSistema() -> Bool {
      //  self == .delGiorno ||
      //  self == .delloChef
        self == .allaCarta(.delGiorno) ||
        self == .allaCarta(.delloChef)
    }
    
    public enum DiSistema {
        
        case delGiorno,delloChef
        
        public  func returnTipologiaMenu() -> TipologiaMenu {
            
            switch self {
                case .delGiorno:
               // return TipologiaMenu.delGiorno
                    return TipologiaMenu.allaCarta(.delGiorno)
                case .delloChef:
                    return TipologiaMenu.allaCarta(.delloChef)
            }
        }
        
        public  func simpleDescription() -> String {
            
            switch self {
                
                case .delGiorno:
                    return "i piatti del Giorno"
                case .delloChef:
                    return "i consigliati"
                
            }
        }
        
        public func extendedDescription() -> String {
            
            switch self {
                case .delGiorno:
                    return "Menu con i piatti del Giorno."
                case .delloChef:
                    return "Menu con i piatti consigliati dallo Chef 👨🏻‍🍳."
                
            }
        }
        
        public func shortDescription() -> String {
            
            switch self {
                case .delGiorno:
                    return "Menu del Giorno"
                case .delloChef:
                    return "Menu dello Chef"
                
            }
        }
        
        public func modelDescription() -> String {
            
            switch self {
                case .delGiorno:
                    return "Rielaborato giornalmente, aggiunge ai menu online dei Piatti del giorno."
                case .delloChef:
                    return "Fra i piatti già inseriti in altri menu, segnala quelli giornalmente consigliati dalla chef."
                
            }
        }
        
        public func imageAssociated() -> String {
            
            switch self {
                
                case .delGiorno:
                    return "clock.arrow.circlepath"
                case .delloChef:
                    return "mustache.fill" //"👨🏻‍🍳"
    
            }
        }
        
        public func orderAndStorageValue() -> Int {
            
            switch self {
                
            case .delGiorno: return 3
            case .delloChef: return 4
            }
        }

       
    }
    
}
