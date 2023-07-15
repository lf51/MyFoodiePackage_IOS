//
//  MenuModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 15/03/22.
//

import Foundation
import SwiftUI
//import Firebase

public struct MenuModel:MyProStarterPack_L0,Codable/*MyProStatusPack_L1,MyProToolPack_L1,MyProDescriptionPack_L0,MyProVisualPack_L1,MyProCloudPack_L1*//*MyModelStatusConformity */ {
     
    public static func == (lhs: MenuModel, rhs: MenuModel) -> Bool {
        
        lhs.id == rhs.id &&
        lhs.intestazione == rhs.intestazione &&
        lhs.descrizione == rhs.descrizione &&
        lhs.rifDishIn == rhs.rifDishIn &&
        lhs.tipologia == rhs.tipologia &&
        lhs.status == rhs.status &&
        lhs.isAvaibleWhen == rhs.isAvaibleWhen &&
        lhs.dataInizio == rhs.dataInizio &&
        lhs.dataFine == rhs.dataFine &&
        lhs.giorniDelServizio == rhs.giorniDelServizio &&
        lhs.oraInizio == rhs.oraInizio &&
        lhs.oraFine == rhs.oraFine
    }
    
    public var id: String
    
    public var intestazione: String // Categoria Filtraggio
    public var descrizione: String
    public var rifDishIn: [String] // riferimenti del piatti
    
    public var tipologia: TipologiaMenu // Categoria di Filtraggio
    public var status: StatusModel
    
    public var isAvaibleWhen: AvailabilityMenu { willSet { giorniDelServizio = newValue == .dataEsatta ? [] : GiorniDelServizio.allCases } }
    public var dataInizio: Date { willSet {
        dataFine = newValue.advanced(by: 604800)
    }}
    public var dataFine: Date // opzionale perchè possiamo non avere una fine in caso di data fissa
    public var giorniDelServizio:[GiorniDelServizio] // Categoria Filtraggio
    public var oraInizio: Date { willSet {oraFine = newValue.advanced(by: 1800)} }
    public var oraFine: Date
    
    public init() {
        
        let currentDate = Date()
        
        self.id = UUID().uuidString
        self.intestazione = ""
        self.descrizione = ""
        self.tipologia = .defaultValue
        self.status = .bozza()
        self.rifDishIn = []
        self.isAvaibleWhen = .defaultValue
        self.dataInizio = currentDate
        self.dataFine = currentDate.advanced(by: 604800)
        self.giorniDelServizio = []
        self.oraInizio = currentDate
        self.oraFine = currentDate.advanced(by: 1800)
        
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
        self.status = .bozza(.disponibile)
        self.rifDishIn = []
        self.isAvaibleWhen = .dataEsatta
        self.dataInizio = currentDate
        self.dataFine = currentDate.advanced(by: 604800)
        let giornoDataInizio = GiorniDelServizio.giornoServizioFromData(dataEsatta: currentDate)
        self.giorniDelServizio = [giornoDataInizio]
        self.oraInizio = Date.distantFuture.advanced(by: -3540)
        self.oraFine = Date.distantFuture.advanced(by: 82740)
       // self.oraFine = Date.distantFuture.advanced(by: 56500)
        
    }

    // MyProCloudPack_L1
    
  /*  public init(frDocID:String,frDoc: [String:Any]) {
        
        let tipologiaAny = frDoc[DataBaseField.tipologia]
        let statusInt = frDoc[DataBaseField.status] as? Int ?? 0
        let availabilityInt = frDoc[DataBaseField.isAvaibleWhen] as? Int ?? 0
        let giorniInt = frDoc[DataBaseField.giorniDelServizio] as? [Int] ?? []
        
        self.id = frDocID
        self.intestazione = frDoc[DataBaseField.intestazione] as? String ?? ""
        self.descrizione = frDoc[DataBaseField.descrizione] as? String ?? ""
        self.rifDishIn = frDoc[DataBaseField.rifDishIn] as? [String] ?? []

        self.tipologia = TipologiaMenu.convertiFromAny(value: tipologiaAny)
        
        self.status = StatusModel.convertiInCase(fromNumber: statusInt)
        self.isAvaibleWhen = AvailabilityMenu.convertiInCase(fromNumber: availabilityInt)
        self.giorniDelServizio = giorniInt.map({GiorniDelServizio.fromOrderValue(orderValue: $0)})
        
        self.dataInizio = frDoc[DataBaseField.dataInizio] as? Date ?? .now
        self.dataFine = frDoc[DataBaseField.dataFine] as? Date ?? .now
        self.oraInizio = frDoc[DataBaseField.oraInizio] as? Date ?? .now
        self.oraFine = frDoc[DataBaseField.oraFine] as? Date ?? .now
    }
    
    
    
    public struct DataBaseField {
        
        public static let intestazione = "intestazione"
        public static let descrizione = "descrizione"
        public static let rifDishIn = "rifDish"
        public static let tipologia = "tipologia" // Nota 16.11
        public static let status = "status"
        public static let isAvaibleWhen = "isAvaibleWhen"
        public static let giorniDelServizio = "giorniDelServizio"
        public static let dataInizio = "dataInizio"
        public static let dataFine = "dataFine"
        public static let oraInizio = "oraInizio"
        public static let oraFine = "oraFine"
        
    } */
    
//
    
     
   
   
    
   
    
 
    
   /* func returnNewModel() -> (tipo: MenuModel, nometipo: String) {
        (MenuModel(), "Menu")
    } */
    
   /* func returnModelTypeName() -> String {
        "Menu"
    } */ // deprecata
    
    // MyProSearchPack
    
   
    
   
    
   
    
    
    // end SearchPack
    
  
    
    func creaID(fromValue: String) -> String {
        fromValue.replacingOccurrences(of: " ", with: "").lowercased()
    }
    

    
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    /// ritorna lo status associato al livello di completamento.
    public func optionalComplete() -> Bool {
        
        self.descrizione != ""
    }
    
    // Metodi riguardanti la programmazione - onLine vs offLine
    
    /// Di default il check del timeRange viene effettuato. Se messo su false non viene eseguito e dunque viene controllato solo la compatibilità con i giorni. Utile per il monitor Servizio
    private func isOnAir() -> MenuModel.CodiceOnOffLive {
        
        // !! VEDI NOTA VOCALE 17.09 !! UPDATE 03.10 - Nota Vocale !!
        
        guard self.status.checkStatusTransition(check: .disponibile) else { return .offByStatus }
        
        switch self.isAvaibleWhen {
            
        case .dataEsatta:
            return isOnAirDataEsatta()
        case .intervalloChiuso:
            return isOnAirClosedRange()
        case .intervalloAperto:
            return isOnAirOpenRange()
        case .noValue:
            return .scadutoForEver//non dovrebbe mai verificarsi
            
        }
        
    }
    
    private func isOnAirDataEsatta() -> MenuModel.CodiceOnOffLive {
        
        let calendario = Calendar(identifier: .gregorian)
        let isSame = calendario.isDateInToday(self.dataInizio)
        
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
 
   /* private func isOnAirClosedRange(checkTimeRange:Bool) -> Bool { // lf51 18.09.22
        
        let(_,endDay,currentDay) = dateCalendario()
        let giorniServizioIntegerMap = self.giorniDelServizio.map({$0.orderAndStorageValue()})
        
        guard giorniServizioIntegerMap.contains(currentDay.weekday!) else { return false }
        guard isOnTimeRange(checkTimeRange: checkTimeRange) else { return false }
        
        guard isInsideFromTheStartDay() else { return false }
        
        guard currentDay.year! == endDay.year! else {
            return currentDay.year! < endDay.year!
        }
        
        guard currentDay.month! == endDay.month! else {
            return currentDay.month! < endDay.month!
        }
        
        return currentDay.day! <= endDay.day!
        
    }*/ // deprecata 03.07.23
    
   /* private func isOnAirOpenRange(checkTimeRange:Bool) -> Bool { // lf51 18.09.22
        
        let(_,_,currentDay) = dateCalendario()
        let giorniServizioIntegerMap = self.giorniDelServizio.map({$0.orderAndStorageValue()})
        
        guard giorniServizioIntegerMap.contains(currentDay.weekday!) else { return false }
        
        guard isOnTimeRange(checkTimeRange: checkTimeRange) else { return false }
        
        return isInsideFromTheStartDay()

        
        // !! NOTA VOCALE 17.09 !!
    } */ // Deprecata 03.07.23
    
   /* private func isOnAirDataEsatta(checkTimeRange:Bool) -> Bool { // lf51 18.09.22
        
       /* let(startDay,_,currentDay) = dateCalendario()
        let startDayPlain = [startDay.year!,startDay.month!,startDay.day!]
        let currentDayPlain = [currentDay.year!,currentDay.month!,currentDay.day!]
        
       // guard startDay == currentDay else { return false }
        guard startDayPlain == currentDayPlain else { return false } */
        
        let calendario = Calendar(identifier: .gregorian)
       // let currentDate = Date()
       /* let sameYear = calendario.isDate(currentDate, equalTo: self.dataInizio, toGranularity: .year)
        guard sameYear else { return false }
        let sameMonth = calendario.isDate(currentDate, equalTo: self.dataInizio, toGranularity: .month)
        guard sameMonth else { return false }
        let sameDay = calendario.isDate(currentDate, equalTo: self.dataInizio, toGranularity: .day)
        guard sameDay else { return false } */
        let isSame = calendario.isDateInToday(self.dataInizio)
        guard isSame else { return false }
        return isOnTimeRange(checkTimeRange: checkTimeRange)
        
    } */ // deprecata 03.07.23

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
    
   /* private func isOnTimeRange(checkTimeRange:Bool) -> Bool { // lf51 18.09.22 // deprecata 05.10
        
        guard checkTimeRange else { return true } // !! Nota Vocale 03.10
         
      //  let(startTime,endTime,currentTime) = timeCalendario() // deprecata 29.10
        
      /* if (currentTime.hour! > startTime.hour!) && (currentTime.hour! < endTime.hour!) { return true }
        
        else if (currentTime.hour! == startTime.hour!) && (currentTime.hour! == endTime.hour!) {
            if (currentTime.minute! >= startTime.minute!) && (currentTime.minute! < endTime.minute!) { return true }
            else { return false }
        }
        
        else if currentTime.hour! == startTime.hour! {
            if currentTime.minute! >= startTime.minute! { return true }
            else { return false }
        }
        else if currentTime.hour! == endTime.hour! {
            if currentTime.minute! < endTime.minute! { return true }
            else { return false }
        }
        else { return false } */
        /*
        let absoluteStart = (startTime.hour! * 60) + startTime.minute!
        let absoluteEnd = (endTime.hour! * 60) + endTime.minute!
        let absoluteCurrent = (currentTime.hour! * 60) + currentTime.minute!
        */ // deprecata 29.10
        let absoluteStart = csTimeConversione(data: self.oraInizio)
        let absoluteEnd = csTimeConversione(data: self.oraFine)
        let absoluteCurrent = csTimeConversione(data: Date.now)
        
        if (absoluteCurrent >= absoluteStart) && (absoluteCurrent < absoluteEnd) { return true }
        else { return false }
        
    } */ // 04.07.23 deprecata
  
    
    private func dateCalendario() -> (startDay:DateComponents,endDay:DateComponents,currentDay:DateComponents) { // lf51 18.09.22
        
        let calendario = Calendar(identifier: .gregorian)
        
        let startDay = calendario.dateComponents([.day,.month,.year], from: self.dataInizio)
        let endDay = calendario.dateComponents([.day,.month,.year], from: self.dataFine)
        let currentDay = calendario.dateComponents([.day,.month,.year,.weekday], from: Date.now)

        return(startDay,endDay,currentDay)
        
    }

  /* private func timeCalendario() -> (startTime:DateComponents,endTime:DateComponents,currentTime:DateComponents) { // lf51 18.09.22
        
        let calendario = Calendar(identifier: .gregorian)
        
        let startTime = calendario.dateComponents([.hour,.minute], from: self.oraInizio)
        let endTime = calendario.dateComponents([.hour,.minute], from: self.oraFine)
        let currentTime = calendario.dateComponents([.hour,.minute], from: Date.now)
        
       
        return(startTime,endTime,currentTime)
    } */ // Deprecata 29.10 -> Sostituita da csTimeConversione
    
    // Test 05.10
   
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
    
    // end Test 05.10
    // Fine Metodi riguardanti la programmazione - onLine vs offLine
    
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
    
   /* public enum CodiceOnOffStatus {
        
        case online(_ :CodiceOnOffTemporale)
        case offline(_ :CodiceOnOffTemporale)
        
        func nextCheck() -> TimeInterval {
            
            switch self {
                
            case .online(let codiceTemp):
                return codiceTemp.nextCheck()
                
            case .offline(let codiceTemp):
                return codiceTemp.nextCheck()
                
                
            }
            
        }
        
    } */// 06.07.23 Deprecata
    
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




