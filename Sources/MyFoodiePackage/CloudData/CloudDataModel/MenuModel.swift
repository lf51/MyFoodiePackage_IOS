//
//  MenuModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 15/03/22.
//

import Foundation
import SwiftUI
//import Firebase

public struct MenuModel:MyProStarterPack_L0,MyProStarterPack_L01,MyProDescriptionPack_L0 {
     
    public static func == (lhs: MenuModel, rhs: MenuModel) -> Bool {
        
        lhs.id == rhs.id &&
        lhs.intestazione == rhs.intestazione &&
        lhs.descrizione == rhs.descrizione &&
        lhs.rifDishIn == rhs.rifDishIn &&
        lhs.tipologia == rhs.tipologia &&
        lhs.statusCache == rhs.statusCache &&
      //  lhs.isAvaibleWhen == rhs.isAvaibleWhen &&
        lhs.giornoInizio == rhs.giornoInizio &&
        lhs.giornoFine == rhs.giornoFine &&
        lhs.giorniDelServizio == rhs.giorniDelServizio &&
        lhs.oraInizio == rhs.oraInizio &&
        lhs.oraFine == rhs.oraFine
    }
    
    public var id: String
    
    public var intestazione: String // Categoria Filtraggio
    public var descrizione: String?
    public var rifDishIn: [String] // riferimenti del piatti
    
    public var tipologia: TipologiaMenu // Categoria di Filtraggio
  //  public var status: StatusModel
    
   /* public var isAvaibleWhen: AvailabilityMenu { willSet { giorniDelServizio = newValue == .dataEsatta ? [] : GiorniDelServizio.allCases } }*/ // può trasformarsi in una computed
   /* public var dataInizio: Date { willSet {
        dataFine = newValue.advanced(by: 604800)
    }}*/
   // public var dataFine: Date // opzionale perchè possiamo non avere una fine in caso di data fissa
    public var giorniDelServizio:[GiorniDelServizio] // Categoria Filtraggio
    public var oraInizio: Date { willSet {oraFine = newValue.advanced(by: 3600)} }
    public var oraFine: Date
    
    public var statusCache:Int
    
    // update 13.02.24
    public var giornoInizio:Date { willSet {
        giornoFine = setGiornoFine(from: newValue)
    }}
    public var giornoFine:Date?
    
    public init() {
        
        let currentDate = Date()
        
        self.id = UUID().uuidString
        self.intestazione = ""
        self.descrizione = nil 
        self.tipologia = .defaultValue
       // self.status = .bozza(.inPausa)
        self.rifDishIn = []
      //  self.isAvaibleWhen = .defaultValue // deprecare
      // self.dataInizio = currentDate // deprecare
       // self.dataFine = currentDate.advanced(by: 604800) // deprecare
        self.giorniDelServizio = []
        self.oraInizio = currentDate
        self.oraFine = currentDate.advanced(by: 3600)
        
        self.statusCache = 0 //
        
        self.giornoInizio = currentDate
        self.giornoFine = nil
    }
    
    public init(tipologiaDiSistema:TipologiaMenu.DiSistema) {
        
        let currentDate = Date()
        
        switch tipologiaDiSistema {
        case .delGiorno:
            self.tipologia = .allaCarta(.delGiorno)
        case .delloChef:
            self.tipologia = .allaCarta(.delloChef)
        }
        
        self.id = UUID().uuidString
        self.intestazione = tipologiaDiSistema.shortDescription()
        self.descrizione = tipologiaDiSistema.modelDescription()
       // self.status = .bozza(.disponibile)
        self.rifDishIn = []
        
       // self.isAvaibleWhen = .dataEsatta // deprecare
       // self.dataInizio = currentDate // deprecare
       // self.dataFine = currentDate.advanced(by: 604800) // deprecare
        
        let giornoDataInizio = GiorniDelServizio.giornoServizioFromData(dataEsatta: currentDate)
        self.giorniDelServizio = [giornoDataInizio]
        self.oraInizio = Date.distantFuture.advanced(by: -3540)
        self.oraFine = Date.distantFuture.advanced(by: 82740)
       // self.oraFine = Date.distantFuture.advanced(by: 56500)
        
        self.statusCache = 0 // da implementare
        
        self.giornoInizio = currentDate
        self.giornoFine = currentDate
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public enum OnlineStatus:MyProEnumPack_L0 {

        public static var allCases:[OnlineStatus] = [.online,.offline]
        
        case online,offline
        
        public func simpleDescription() -> String {
            switch self {
            case .online:
                return "Online"
            case .offline:
                return "Offline"
            }
        }
        
        public func returnTypeCase() -> MenuModel.OnlineStatus {
            self
        }
        
        public func orderAndStorageValue() -> Int {
            switch self {
            case .online:
                return 1
            case .offline:
                return 0
            }
        }
        
    } // 06.07 deprecata in futuro
    
    public enum CodiceOnOffLive {

        case liveNow
        case inProgrammaToday
        case scadutoToday
        
        case offByStatus
        case inProgrammaNextDays
        case scadutoForEver
        
       public func simpleDescription() -> String {
            
            switch self {
                
            case .liveNow: return "in servizio"
            case .inProgrammaToday: return "in arrivo"
            case .scadutoToday: return "appena chiuso"
            case .offByStatus: return "non attivo"
            case .inProgrammaNextDays: return "apre in futuro"
            case .scadutoForEver: return "scaduto"
                
                
            }
            
        }
        
        public func openCloseDescription() -> String {
             
             switch self {
                 
             case .liveNow: return "Chiude in "
             case .inProgrammaToday: return "Apre in "
             default: return ""
                 
                 
             }
             
         }
        
    }

        
} // end Model

/// Gestione Availability
extension MenuModel {
    
    public var availability:AvailabilityMenu {
        get { getAvailability() }
        set { setAvailability(value:newValue) }
    }
    
    
    private func getAvailability() -> AvailabilityMenu { 
        
        guard let giornoFine else {
            
            return .intervalloAperto
        }
        
        if giornoFine == giornoInizio { return .dataEsatta }
        else { return .intervalloChiuso }
    }
    
    mutating public func setAvailability(value:AvailabilityMenu) {
        
        switch value {
            
        case .dataEsatta:
            setDataEsatta()
        case .intervalloChiuso:
            setIntervalloChiuso()
        case .intervalloAperto:
            setIntervalloAperto()
       /* case .noValue:
            return*/
        }
        
    }
    
   mutating private func setDataEsatta() {
        
        let current = Date.now
        
       // self.dataInizio = current // deprecata in fut
       // self.dataFine = current // deprecato in fut
       
        self.giornoInizio = current
        self.giornoFine = current
        
        self.oraInizio = current
        self.oraFine = current.advanced(by: 3600) // plus one hour
       
        self.setGiornoDataEsatta()
    }
    
    mutating private func setIntervalloAperto() {
         
         let current = Date.now
         
        // self.dataInizio = current // depre in fut
         self.giornoInizio = current
        
       //  self.dataFine = current.advanced(by: 6900999) // deprecato in fut
         self.giornoFine = nil
         
         self.oraInizio = current
         self.oraFine = current.advanced(by: 3600) // plus one hour
        
         self.giorniDelServizio = []
     }
    
    mutating private func setIntervalloChiuso() {
         
         let current = Date.now
         
        // self.dataInizio = current // depre in fut
         self.giornoInizio = current
        
        // self.dataFine = current.advanced(by: 604800) // deprecato in fut
         self.giornoFine = current.advanced(by: 604800)
         
         self.oraInizio = current
         self.oraFine = current.advanced(by: 3600) // plus one hour
        
         self.giorniDelServizio = []
     }
    
     private func setGiornoFine(from day:Date) -> Date? {
        
         switch self.availability {
             
         case .dataEsatta: return day
         case .intervalloAperto: return nil
         case .intervalloChiuso: return day.advanced(by: 604800)
       //  case .noValue: return nil
             
         }
        
    }
    
   mutating private func setGiornoDataEsatta() {
        
       let serviceDay = getGiornoServizioDataEsatta()
        
        self.giorniDelServizio = [serviceDay]
        
    }
    
    public func getGiornoServizioDataEsatta() -> GiorniDelServizio {
        
        let dataEsatta = self.giornoInizio
        let serviceDay = GiorniDelServizio.giornoServizioFromData(dataEsatta: dataEsatta)
        
        return serviceDay
        
    }
        
}

extension MenuModel {
    
    func creaID(fromValue: String) -> String {
        fromValue.replacingOccurrences(of: " ", with: "").lowercased()
    }

    /// ritorna lo status associato al livello di completamento.
    public func optionalComplete() -> Bool {
        
        guard let descrizione,
              !descrizione.isEmpty else { return false }
        
        
        return !self.rifDishIn.isEmpty
    }
}

extension MenuModel:Decodable { 
    
    public enum CodingKeys:String,CodingKey {
       
        case id
        case intestazione
        case descrizione
        case rifDishIn = "rif_dish"
        case tipologia
    
        case dataInizio = "giorno_inizio"
        case dataFine = "giorno_fine"
       
        case oraInizio = "ora_inizio"
        case oraFine = "ora_fine"
        
        case giorniDelServizio = "work_days"
        
        case statusCache = "status_cache"
        
    }
    
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.intestazione = try container.decode(String.self, forKey: .intestazione)
        self.descrizione = try container.decodeIfPresent(String.self, forKey: .descrizione)
        
        self.tipologia = try container.decode(TipologiaMenu.self, forKey: .tipologia)
        self.rifDishIn = try container.decode([String].self, forKey: .rifDishIn)
    
        self.oraInizio = try container.decode(Date.self, forKey: .oraInizio)
        self.oraFine = try container.decode(Date.self, forKey: .oraFine)
        
        self.giorniDelServizio = try container.decode([GiorniDelServizio].self, forKey: .giorniDelServizio)
  
        self.giornoInizio = try container.decode(Date.self, forKey: .dataInizio)
        self.giornoFine = try container.decodeIfPresent(Date.self, forKey: .dataFine)
        
        let statusValue = try container.decode(String.self, forKey: .statusCache)
        self.statusCache = Int(statusValue) ?? 0
    }

}

extension MenuModel:Encodable { 
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.intestazione, forKey: .intestazione)
        try container.encode(self.descrizione, forKey: .descrizione)
        
        try container.encode(self.tipologia, forKey: .tipologia)
        try container.encode(self.rifDishIn, forKey: .rifDishIn)
        
        try container.encode(self.giornoInizio, forKey: .dataInizio)
        try container.encode(self.giornoFine, forKey: .dataFine)
        try container.encode(self.oraInizio, forKey: .oraInizio)
        try container.encode(self.oraFine, forKey: .oraFine)
        
        try container.encode(self.giorniDelServizio, forKey: .giorniDelServizio)
        
        let statusValue = String(self.statusCache)
        try container.encode(statusValue, forKey: .statusCache)
        
    }
    
}

extension MenuModel:MyProTransitionGetPack_L01 {

    /// Se venisse passato un valore nil, ritornerebbe lo status di archiviato. Il valore deve essere passato Mandatory
    public func getStatusTransition(viewModel:FoodieViewModel?) -> StatusTransition {
        
        guard let viewModel else { return .archiviato }
        
        if statusCache == 0 {
            // automatizzato
            return getTransitionAutomatically(viewModel: viewModel)
            
        } else {
            // valore precedentemente forzato
            let currentStatus = StatusTransition.decodeStatus(from: self.statusCache)
            
            return currentStatus
        }
        
    }
    
    private func getTransitionAutomatically(viewModel:FoodieViewModel) -> StatusTransition {
        
        guard !self.rifDishIn.isEmpty else { return .inPausa }
        
        let productsDisponibili:[String] = viewModel.checkDishStatusTransition(of: self.rifDishIn, check: .disponibile)
        
        guard !productsDisponibili.isEmpty else { return .inPausa }
        
        return .disponibile

    }
    
}

/// Gestione isOnAir
extension MenuModel {
    
    /// Di default il check del timeRange viene effettuato. Se messo su false non viene eseguito e dunque viene controllato solo la compatibilità con i giorni. Utile per il monitor Servizio
    private func isOnAir() -> MenuModel.CodiceOnOffLive {
        print("============= FIX isOnAir !!! ========")
        // !! VEDI NOTA VOCALE 17.09 !! UPDATE 03.10 - Nota Vocale !!
        let statusTransition:StatusTransition = .disponibile
        guard statusTransition == .disponibile else { return .offByStatus }
        
        switch self.availability {
            
        case .dataEsatta:
            return isOnAirDataEsatta()
        case .intervalloChiuso:
            return isOnAirClosedRange()
        case .intervalloAperto:
            return isOnAirOpenRange()
       /* case .noValue:
            return .scadutoForEver*///non dovrebbe mai verificarsi
            
        }
        
    }
    
    private func isOnAirDataEsatta() -> MenuModel.CodiceOnOffLive {
        
        let calendario = Calendar(identifier: .gregorian)
        let isSame = calendario.isDateInToday(self.giornoInizio)
        
        guard isSame else {
     
            let isPasted = isInsideFromTheStartDay() // darebbe un => ma l'uguale non lo considera perchè se è uguale il guard continua
            if isPasted { return .scadutoForEver }
            else { return .inProgrammaNextDays}
                }
        
        let timeRange = isOnTimeRange()
        
        return timeRange
        
    }
    
    private func isOnAirOpenRange() -> MenuModel.CodiceOnOffLive { // lf51 18.09.22
        
        let(_,_,currentDay) = dateCalendario()
        let giorniServizioIntegerMap = self.giorniDelServizio.map({$0.orderAndStorageValue()})
        
        let isInTheRange = isInsideFromTheStartDay()
        
        guard isInTheRange else {
            return .inProgrammaNextDays
        }
        
        let isTheDay = giorniServizioIntegerMap.contains(currentDay.weekday!)
        
        guard isTheDay else {
            return .inProgrammaNextDays
        }
        
        let timeRange = isOnTimeRange()
        return timeRange

    }
    
    private func isOnAirClosedRange() -> MenuModel.CodiceOnOffLive { // lf51 18.09.22
        
        let(_,_,currentDay) = dateCalendario()
        let giorniServizioIntegerMap = self.giorniDelServizio.map({$0.orderAndStorageValue()})
        
        let isIn = isInsideFromTheStartDay()
        
        guard isIn else { return .inProgrammaNextDays }
        
        let isInByTheEnd = isInsideByTheEnd()
        
        guard isInByTheEnd else { return .scadutoForEver }
        
        let isTheDay = giorniServizioIntegerMap.contains(currentDay.weekday!)
        
        guard isTheDay else { return .inProgrammaNextDays }
        
        let timeRange = isOnTimeRange()
        
        return timeRange

    }
    
    private func isInsideFromTheStartDay() -> Bool { // lf51 18.09.22
        
        let(startDay,_,currentDay) = dateCalendario()
        
        guard currentDay.year! == startDay.year! else {
            
            return currentDay.year! > startDay.year! }
        
        guard currentDay.month! == startDay.month! else {
            
            return currentDay.month! > startDay.month!
        }
        
        return currentDay.day! >= startDay.day!
    }
    
    private func isInsideByTheEnd() -> Bool {
        
        let(_,endDay,currentDay) = dateCalendario()
        
        guard currentDay.year! == endDay.year! else {
            return currentDay.year! < endDay.year!
        }
        
        guard currentDay.month! == endDay.month! else {
            return currentDay.month! < endDay.month!
        }
        
        return currentDay.day! <= endDay.day!
        
    }
    
    private func isOnTimeRange() -> CodiceOnOffLive { // lf51 18.09.22 // deprecata 05.10
        
        let absoluteStart = csTimeConversione(data: self.oraInizio)
        let absoluteEnd = csTimeConversione(data: self.oraFine)
        let absoluteCurrent = csTimeConversione(data: Date.now)
        
        if (absoluteCurrent >= absoluteStart) && (absoluteCurrent < absoluteEnd) { return .liveNow }
        else if absoluteCurrent < absoluteStart { return .inProgrammaToday }
        else { return .scadutoToday }
        
    }
    
    private func dateCalendario() -> (startDay:DateComponents,endDay:DateComponents,currentDay:DateComponents) { // lf51 18.09.22
        
        let calendario = Calendar(identifier: .gregorian)
        
        let startDay = calendario.dateComponents([.day,.month,.year], from: self.giornoInizio)
        let endDay = calendario.dateComponents([.day,.month,.year], from: self.giornoFine ?? Date.now) // da sistemare
        let currentDay = calendario.dateComponents([.day,.month,.year,.weekday], from: Date.now)

        return(startDay,endDay,currentDay)
        
    }
    
    public func isOnAirValue() -> (today:Bool,now:Bool) {
        // rimpiazza la vecchia isOnAir con checktime range per avere un informazione veloce bool
        let isOn = self.isOnAir()
        
        switch isOn {
        case .liveNow:
            return (true,true)
        case .inProgrammaToday:
            return (true,false)
        case .scadutoToday:
            return (true,false)
            
        default: return (false,false)
        }
    }
    
    public func timeScheduleInfo() -> (codiceTemporale:CodiceOnOffLive,nextCheck:TimeInterval?,countDown:Int?) {
   // volessimo ripristinare la facoltà di scegliere lo start del countDown, quel valore dovrà essere passato qui dal TimerVM
        let isOn = self.isOnAir()
        
        switch isOn {
            
        case .liveNow:
            let (distance,countDown) = calcoloNextCheckToday(oraRiferimento: self.oraFine)
            return(isOn,distance,countDown)
            
        case .inProgrammaToday:
            let (distance,countDown) = calcoloNextCheckToday(oraRiferimento: self.oraInizio)
            return(isOn,distance,countDown)
            
        case .scadutoToday:
            return(isOn,calcoloNextCheckTomorrow(),nil)
            
        case .offByStatus:
            return(isOn,nil,nil)
            
        case .inProgrammaNextDays:
            return(isOn,calcoloNextCheckTomorrow(),nil)
            
        case .scadutoForEver:
            return(isOn,nil,nil)
        }
        
    }
    
    private func calcoloNextCheckTomorrow() -> TimeInterval {
        
        let today = Date.now
  
        let mimuteNow = csTimeConversione(data: today)
        let allMinuteInAday = 24 * 60
        let distanceToMidnight = allMinuteInAday - mimuteNow
        let distanceToMidPlusOne = distanceToMidnight + 1
        let nextCheck = distanceToMidPlusOne * 60
        let nextCheckTimeIn = TimeInterval(nextCheck)
         // Test
       //  let dataNextCheck = Date(timeIntervalSinceNow: nextCheckTimeIn)
         //
         
        return nextCheckTimeIn
    }
    
    private func calcoloNextCheckToday(oraRiferimento:Date) -> (distance:TimeInterval,countDown:Int?) {
        // Valore di default del count down è 30 minuti prima dell'inizio o della fine del servizio // Nota Countdown 06.07

        let today = Date.now
        let currentHourInMinute = csTimeConversione(data: today)
        
        let inizioCount_0 = oraRiferimento.advanced(by: -1800)
        let inizioCount = csTimeConversione(data: inizioCount_0)
        
        let step_2 = inizioCount - currentHourInMinute
        let coundDown = 30 + step_2 // quando scatta il countDown step_2 sarà un numero negativo
        
        let step_3 = step_2 * 60 // convertiamo in secondi
        let distanceFromCountDown = TimeInterval(step_3)
        
        if step_2 > 0 { return (distanceFromCountDown,nil) } // il countDown non è iniziato
        else { return (60.0,coundDown) } // il countDown è iniziato e il timer aggiorna ogni 60sec
        
    }
}




/// 23.02.24 Gestione Programmazione
extension MenuModel {
    
    public var planStatus:CodiceOnOffLive { getPlanStatus() }
    
    private func getPlanStatus() -> CodiceOnOffLive {
    
    
        return .liveNow
        
        
        
    }
    
    
    
    
}
