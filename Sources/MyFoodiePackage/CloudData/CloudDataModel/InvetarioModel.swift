//
//  InvetarioModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 29/09/22.
//

import Foundation
import SwiftUI
//import Firebase

public struct Inventario:Equatable,Codable {

    // Nota 02.10 // Nota 21.11
    public var id:String
    
    public var ingInEsaurimento:[String]
    public var ingEsauriti:[String]
    public var archivioNotaAcquisto: [String:String] // key:IdIngrediente || Value: Nota per l'acquisto
    /// Il value della cronologia è un array di stringge combo (data di acquisto + nota di acquisto)
    public var cronologiaAcquisti:[String:[String]] // key = idIngrediente || Value = [date di acquisto + nota]
    public var lockedId:[String:[String]] // Key: data || value:[id oggetti a cui è stato cambiato lo status]
    public var archivioIngInEsaurimento: [String:[String]] // key:DataCorrente || value = [id ingredienti Esauriti depennati]
    
   public init(id: String, ingInEsaurimento: [String], ingEsauriti: [String], archivioNotaAcquisto: [String : String], cronologiaAcquisti: [String : [String]], lockedId: [String : [String]], archivioIngInEsaurimento: [String : [String]]) {
        
        // Non dovrebbe essere in uso. Deprecabile
        
        self.id = id
        self.ingInEsaurimento = ingInEsaurimento
        self.ingEsauriti = ingEsauriti
        self.archivioNotaAcquisto = archivioNotaAcquisto
        self.cronologiaAcquisti = cronologiaAcquisti
        self.lockedId = lockedId
        self.archivioIngInEsaurimento = archivioIngInEsaurimento
    }
    
    public init() {
        
        self.id = "userInventario"
        self.ingInEsaurimento = []
        self.ingEsauriti = []
        self.archivioNotaAcquisto = [:]
        self.cronologiaAcquisti = [:]
        self.lockedId = [:]
        self.archivioIngInEsaurimento = [:]
        
    }
    
    // MyProCloudPack_L1
    
   /* public init(frDocID:String,frDoc: [String:Any]) {
        
        self.id = frDocID
        
        self.ingInEsaurimento = frDoc[DataBaseField.ingInEsaurimento] as? [String] ?? []
        self.ingEsauriti = frDoc[DataBaseField.ingEsauriti] as? [String] ?? []
        self.archivioNotaAcquisto = frDoc[DataBaseField.archivioNotaAcquisto] as? [String:String] ?? [:]
        self.cronologiaAcquisti = frDoc[DataBaseField.cronologiaAcquisti] as? [String:[String]] ?? [:]
        self.lockedId = frDoc[DataBaseField.lockedId] as? [String:[String]] ?? [:]
        self.archivioIngInEsaurimento = frDoc[DataBaseField.archivioIngInEsaurimento] as? [String:[String]] ?? [:]
        
    }
    
    public func documentDataForFirebaseSavingAction(positionIndex:Int?) -> [String : Any] {
        
        let documentData:[String:Any] = [
        
            DataBaseField.ingInEsaurimento : self.ingInEsaurimento,
            DataBaseField.ingEsauriti : self.ingEsauriti,
            DataBaseField.archivioNotaAcquisto : self.archivioNotaAcquisto,
            DataBaseField.cronologiaAcquisti : self.cronologiaAcquisti,
            DataBaseField.lockedId : self.lockedId,
            DataBaseField.archivioIngInEsaurimento : self.archivioIngInEsaurimento

        ]
        
        return documentData
    }
    
    public struct DataBaseField {
        
        static let ingInEsaurimento = "ingInEsaurimento"
        static let ingEsauriti = "ingEsauriti"
        static let archivioNotaAcquisto = "archivioNotaAcquisto"
        static let cronologiaAcquisti = "cronologiaAcquisti"
        static let lockedId = "lockedId"
        static let archivioIngInEsaurimento = "archivioIngInEsaurimento"
        
    } */
    
    // Method
    
    public func allInventario() -> [String] {
        
        let inArrivo = self.allInArrivo()
        
        return self.ingEsauriti + self.ingInEsaurimento + inArrivo
    }
    
    public func allInArrivo() -> [String] {
        
        let today = csTimeFormatter().data.string(from: Date())

        let inArrivo = cronologiaAcquisti.filter({
            $0.value.contains(where: {$0.hasPrefix(today)})
        })
                
        return inArrivo.map({$0.key})

    }
    
    public func statoScorteIng(idIngredient:String) -> Inventario.TransitoScorte {
        
        if ingInEsaurimento.contains(idIngredient) {
            
            return .inEsaurimento
        }
        
        else if ingEsauriti.contains(idIngredient) {
            
            return .esaurito
        }
        
        else if let key = cronologiaAcquisti[idIngredient] {
            
            let today = csTimeFormatter().data.string(from: Date())
            let filterKey = key.filter({$0.hasPrefix(today)})
            
            if filterKey.isEmpty { return .inStock}
            else { return .inArrivo }

        }
        
        else {
            return .inStock
        }
        
    }
    
   public mutating func cambioStatoScorte(idIngrediente:String,nuovoStato:Inventario.TransitoScorte) {
        
        switch nuovoStato {
            
        case .inEsaurimento:
            self.ingInEsaurimento.append(idIngrediente) // usata nel menuInterattivo
        case .esaurito:
            convertiInEsaurito(idIngrediente: idIngrediente) // usata nel menuInterattivo
        case .inArrivo:
            convertiStatoInArrivo(id: idIngrediente) // usata in lista della spesa
        case .inStock:
            reverseInStock(id: idIngrediente)
        }
    }
    
    /// riporta in stock nel caso di errore manuale di selezione nel menu interattivo. Funziona solo da ingredienti in esaurimento o esauriti.
    private mutating func reverseInStock(id:String) {
     
        if self.ingInEsaurimento.contains(id) {
            self.ingInEsaurimento.removeAll(where: {$0 == id})
            
        } else if self.ingEsauriti.contains(id) {
            self.ingEsauriti.removeAll(where: {$0 == id})
        }
        
    }
    
    private mutating func convertiStatoInArrivo(id:String) {
        
        let dataDiAcquisto = Date.now
        let dataInString = csTimeFormatter().data.string(from: dataDiAcquisto)
     
        var dataPlusNota:String
        
        if let theKey = self.archivioNotaAcquisto[id] {
            
            dataPlusNota = theKey.hasPrefix(dataInString) ? theKey : dataInString
            
        } else {
            dataPlusNota = dataInString
        }
        
        if self.ingInEsaurimento.contains(id) {
            
            self.ingInEsaurimento.removeAll(where: {$0 == id})
           
            if self.archivioIngInEsaurimento[dataInString] != nil {
                self.archivioIngInEsaurimento[dataInString]!.append(id)
            } else {
                self.archivioIngInEsaurimento = [dataInString:[id]]
            }
            
        } else {
            self.ingEsauriti.removeAll(where: {$0 == id})
        }

        guard self.cronologiaAcquisti[id] != nil else {
           return self.cronologiaAcquisti[id] = [dataPlusNota]
        }
        
        self.cronologiaAcquisti[id]!.append(dataPlusNota)

    }
    
    private mutating func convertiInEsaurito(idIngrediente:String) {
        
        if self.ingInEsaurimento.contains(idIngrediente) {
            
            self.ingInEsaurimento.removeAll(where: {$0 == idIngrediente})
           
        }
        
        self.ingEsauriti.append(idIngrediente)
        
    }
    
    /// ritorna la data dell'ultimo acquisto associato ad un idIngrediente
    public func dataUltimoAcquisto(idIngrediente:String) -> String { // torna data in forma di stringa

        let last = self.cronologiaAcquisti[idIngrediente]?.last

        return splitDateFromNote(stringa: last ?? "nessuno").data

    }
    
    /// riceve la stringa di una nota e ne separa le due parti, la data dalla nota.
    public func splitDateFromNote(stringa: String) -> (data:String,nota:String) {
        
        guard stringa.contains("|") else { return (stringa,"Nessuna Nota")}
        
        let split = stringa.split(separator: "|")
        let data = String(split[0])
        let nota = String(split[1])
        return (data,nota)
        
    }
    
    /// ritorna la cronologia degli acquisti associati ad un idingrediente, ossia un array di date-note
    public func logAcquisti(idIngrediente:String) -> [String] {

       return self.cronologiaAcquisti[idIngrediente] ?? []
    }
    
    /// ricava la nota associato ad un id ed una data
    public func estrapolaNota(idIngrediente:String,currentDate:String) -> String {
        
        if let nota = self.archivioNotaAcquisto[idIngrediente] {
            
            if nota.hasPrefix(currentDate) {
                let prefixCount = currentDate.count
                var cleanNote = nota
                cleanNote.removeFirst(prefixCount + 1) // plus One per eliminare il | di demarcazione usato per separare gli elementi nella cronologia acquisti
                return cleanNote
            } else { return "" }
            
        } else { return "" }

    }

    public enum TransitoScorte:String,MyProEnumPack_L0 {
        
        public static var allCases:[TransitoScorte] = [.inStock,.inArrivo,.inEsaurimento,.esaurito]
        
        case inEsaurimento = "in esaurimento"
        case esaurito = "esaurite"
        case inStock = "in stock"
        case inArrivo = "in arrivo"
        
        public func orderAndStorageValue() -> Int {
            
            switch self {
                
            case .inStock:
                return 0
            case .inEsaurimento:
                return 1
            case .esaurito:
                return 2
            case .inArrivo:
                return 0
            }

        }
        
        public func simpleDescription() -> String {
         
            switch self {
                
            case .inStock:
                return "in Stock"
            case .inEsaurimento:
                return "ai Minimi"
            case .esaurito:
                return "Terminate"
            case .inArrivo:
                return "in Arrivo"
            }
        }
        
        public func returnTypeCase() -> Inventario.TransitoScorte {
            self
        }
        
        public func imageAssociata() -> String {
            
            switch self {
                
            case .inStock:
                return "house"
            case .inEsaurimento:
                return "clock.badge.exclamationmark"
            case .esaurito:
                return "alarm.waves.left.and.right"
            case .inArrivo:
                return "creditcard"
            }
        }
        
        public func coloreAssociato() -> Color {
            
            switch self {
                
            case .inStock:
                return .seaTurtle_3
            case .inEsaurimento:
                return .yellow.opacity(0.7)
            case .esaurito:
                return .red.opacity(0.6)
            case .inArrivo:
                return .green.opacity(0.7)
            }
            
        }
        
        public func coloreAssociatoNotOpacity() -> Color {
            
            switch self {
                
            case .inStock:
                return .seaTurtle_3
            case .inEsaurimento:
                return .yellow
            case .esaurito:
                return .red
            case .inArrivo:
                return .green
            }
        }
    }
}
