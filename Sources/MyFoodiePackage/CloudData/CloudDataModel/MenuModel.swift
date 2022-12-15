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
    public func isOnAir(checkTimeRange:Bool = true) -> Bool {
        
        // !! VEDI NOTA VOCALE 17.09 !! UPDATE 03.10 - Nota Vocale !!
        
        guard self.status.checkStatusTransition(check: .disponibile) else { return false }
        
        switch self.isAvaibleWhen {
            
        case .dataEsatta:
            return isOnAirDataEsatta(checkTimeRange: checkTimeRange)
        case .intervalloChiuso:
            return isOnAirClosedRange(checkTimeRange: checkTimeRange)
        case .intervalloAperto:
            return isOnAirOpenRange(checkTimeRange: checkTimeRange)
        case .noValue:
            return false
            
        }
        
    }
 
    private func isOnAirClosedRange(checkTimeRange:Bool) -> Bool { // lf51 18.09.22
        
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
        
        
    }
    
    private func isOnAirOpenRange(checkTimeRange:Bool) -> Bool { // lf51 18.09.22
        
        let(_,_,currentDay) = dateCalendario()
        let giorniServizioIntegerMap = self.giorniDelServizio.map({$0.orderAndStorageValue()})
        
        guard giorniServizioIntegerMap.contains(currentDay.weekday!) else { return false }
        guard isOnTimeRange(checkTimeRange: checkTimeRange) else { return false }
        
        return isInsideFromTheStartDay()

        
        // !! NOTA VOCALE 17.09 !!
    }
    
    private func isOnAirDataEsatta(checkTimeRange:Bool) -> Bool { // lf51 18.09.22
        
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
    
    private func isOnTimeRange(checkTimeRange:Bool) -> Bool { // lf51 18.09.22 // deprecata 05.10
        
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
        
    }
  
    
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
   
    public func timeScheduleInfo() -> (isOnAirNow:Bool,nextCheck:TimeInterval,invalidateForEver:Bool,countDown:Int) {
        //Nota 06.10 - Da rielaborare. Occorre rielaborare tutte le funzioni che portano all'isOnAir per ottenere maggiorni informazioni, di modo da schedulare meglio il timer ed eventualmente invalidarlo
        let isOn = self.isOnAir()
        
        guard isOn else { return (false,1.0,false,0)} // provvisorio }
        
       /* let(_,end,current) = timeCalendario()
        
        let currentHourInMinute = (current.hour! * 60) + current.minute!
        let endHourInMinute = (end.hour! * 60) + end.minute! */ // deprecato 29.10
        let currentHourInMinute = csTimeConversione(data: Date.now)
        let endHourInMinute = csTimeConversione(data: self.oraFine)
        
        let differenceToEnd = endHourInMinute - currentHourInMinute
            
       return (true,60.0,false,differenceToEnd)
        
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
    }
} // end Model




