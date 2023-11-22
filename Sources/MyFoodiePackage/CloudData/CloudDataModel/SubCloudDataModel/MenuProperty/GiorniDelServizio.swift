//
//  GiorniDelServizio.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/04/22.
//

import Foundation

public enum GiorniDelServizio:String,MyProEnumPack_L2,Identifiable,Codable /*: MyEnumProtocol, MyEnumProtocolMapConform*/ {

    public static var allCases:[GiorniDelServizio] = [.lunedi,.martedi,.mercoledi,.giovedi,.venerdi,.sabato,.domenica]
    public static var defaultValue: GiorniDelServizio = .lunedi
   // static var allDayService: [GiorniDelServizio] = [.lunedi,.martedi,.mercoledi,.giovedi,.venerdi,.sabato,.domenica] // abbiamo creato questo array uguale ma diverso dall'AllCases per aprire in futuro lo spazio ad un array con i giorni di attività escluso il giorno di riposo
    public var id: String {self.createId()}
    
    case lunedi
    case martedi
    case mercoledi
    case giovedi
    case venerdi
    case sabato
    case domenica
    
    public func simpleDescription() -> String {
        
        switch self {
        case .lunedi:
            return "Lunedi"
        case .martedi:
            return "Martedi"
        case .mercoledi:
            return "Mercoledi"
        case .giovedi:
            return "Giovedi"
        case .venerdi:
            return "Venerdi"
        case .sabato:
            return "Sabato"
        case .domenica:
            return "Domenica"
        }
    }
    
    public func extendedDescription() -> String {

        return "[DA_SVILUPPARE]"
    }
    
    public func shortDescription() -> String {
        
        switch self {
            
        case .lunedi:
            return "L"
        case .martedi:
            return "M"
        case .mercoledi:
            return "M"
        case .giovedi:
            return "G"
        case .venerdi:
            return "V"
        case .sabato:
            return "S"
        case .domenica:
            return "D"
        }
        
    }
    
    func createId() -> String {
        
        self.simpleDescription().lowercased()
    }
    
    public func imageAssociated() -> String {
        
        switch self {
            
        case .lunedi:
            return "l.circle"
        case .martedi:
            return "m.circle"
        case .mercoledi:
            return "m.circle"
        case .giovedi:
            return "g.circle"
        case .venerdi:
            return "v.circle"
        case .sabato:
            return "s.circle"
        case .domenica:
            return "d.circle"
        }
    }
    
    public func returnTypeCase() -> GiorniDelServizio {
        
      return self // ritorniamo il self perchè al momento (07.04.2022) non ci sono valori associati ai case
    }
    
    public func orderAndStorageValue() -> Int {
        // 17.09 abbiamo conformato l'ordine come lo intendevamo, ossia di apparizione da Lun a Dome, conformando all'ordine dato dal Calendario, ossia da Dom a Sabato
        switch self {
        case .lunedi: return 2//1
        case .martedi: return 3//2
        case .mercoledi: return 4//3
        case .giovedi: return 5//4
        case .venerdi: return 6//5
        case .sabato: return 7//6
        case .domenica: return 1//7
        }
        
    }
    
    public static func fromOrderValue(orderValue:Int) -> GiorniDelServizio {
        
       switch orderValue {
           
       case 1: return .domenica
       case 2: return .lunedi
       case 3: return .martedi
       case 4: return .mercoledi
       case 5: return .giovedi
       case 6: return .venerdi
       case 7: return .sabato
       default: return .defaultValue
           
       }
        
    }
    
    /// Si Usa nel caso di DataEsatta per mostrare il giorno della settimana corrispondente
    public static func giornoServizioFromData(dataEsatta:Date) -> GiorniDelServizio {
        
        let calendario = Calendar(identifier: .gregorian)
        let weekDayComponent = calendario.dateComponents([.weekday], from: dataEsatta)
        let giornoDelServizio = fromOrderValue(orderValue: weekDayComponent.weekday!)
       
        return giornoDelServizio

    }

}
