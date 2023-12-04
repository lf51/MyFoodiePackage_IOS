//
//  InvetarioModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 29/09/22.
//

import Foundation
import SwiftUI
//import Firebase

public struct BollaAcquisto:MyProStarterPack_L0{
    
    public let id:String
    
    public var rifIngrediente:String?
    public var nota:String?
    public var data:String?
    public var user:String?
    
    /// Init con data corrente
   public init() {
        self.id = UUID().uuidString
        self.data = csTimeFormatter().data.string(from: Date())
    }
    
    /// init con data nil
    public init(nota: String) {
         self.id = UUID().uuidString
         self.nota = nota
     }
}

extension BollaAcquisto:Decodable {
    
    public static let codingInfo:CodingUserInfoKey = CodingUserInfoKey(rawValue: "BollaAcquisto")!
    
    public enum CodingKeys:String,CodingKey {
        
        case id
        case nota
        case data
        case rif = "rif_ingrediente"
        case user
    }
    
    
    public init(from decoder: Decoder) throws {
        
        let decodingCase = decoder.userInfo[Self.codingInfo] as? MyCodingCase ?? .inbound
        
        switch decodingCase {
        case .mainCollection:
            fallthrough
        case .subCollection:
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.id = try container.decode(String.self, forKey: .id)
            self.rifIngrediente = try container.decode(String.self, forKey: .rif)
            self.data = try container.decode(String.self, forKey: .data)
            self.nota = try container.decodeIfPresent(String.self, forKey: .nota)
            self.user = try container.decode(String.self, forKey: .user)
            
        case .inbound:
            let container = try decoder.singleValueContainer()
            
            let value = try container.decode(String.self)
             self.id = UUID().uuidString
            (self.data,self.nota) = decodeSingleValue(value)
        }
 
    }
    
    private func decodeSingleValue(_ value:String) -> (data:String?,nota:String?) {
        
        guard !value.isEmpty else {
            return (nil,nil)
        }
        
        let strings = value.split(separator: "_:")
        let count = strings.count
        
        guard count == 1 else {
            
            let data = String(strings.first ?? "")
            let nota = String(strings.last ?? "")
            
            return (data,nota)
            
        }
            
            if value.hasSuffix("_:") {
                
                let data = String(strings.first ?? "")
                return(data,nil)
                
            } else {
                
                let nota = String(strings.first ?? "")
                return (nil,nota)
            }

    }
    
}

extension BollaAcquisto:Encodable {
    
    public func encode(to encoder: Encoder) throws {
        
        let codingCase = encoder.userInfo[Self.codingInfo] as? MyCodingCase ?? .inbound
        
        switch codingCase {
        case .mainCollection:
            fallthrough
            
        case .subCollection:
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.id, forKey: .id)
            try container.encode(self.rifIngrediente, forKey: .rif)
            try container.encode(self.data, forKey: .data)
            try container.encodeIfPresent(self.nota, forKey: .nota)
            try container.encode(self.user, forKey: .user)
            
        case .inbound:
            
            var container = encoder.singleValueContainer()
            let value = encodeSingleValue()
            
            try container.encode(value)
            
        }
    }
    
    private func encodeSingleValue() -> String {
        
        let nota = self.nota ?? ""
        let data = self.data ?? ""
        
        guard !nota.isEmpty ||
              !data.isEmpty else { return "" }
        
        let value = "\(data)_:\(nota)"
        
        return value
        
    }

    
}

extension BollaAcquisto:MyProSubCollectionPack {
    
    public typealias Sub = CloudDataStore.SubCollectionKey
    
    public func subCollection() -> CloudDataStore.SubCollectionKey {
        return .archivioBolleAcquisto
    }
    
    public func sortCondition(compare rhs: BollaAcquisto) -> Bool {
        
        let currentData = self.data ?? ""
        let rhsData = rhs.data ?? ""
        return csCompareDateString(lhs: currentData, rhs: rhsData)
    }
}

public struct InventarioScorte:Equatable {
        
    public lazy var currentDate:String = {
        csTimeFormatter().data.string(from: Date())
    }()
    
    public var statusScorte:StatoScorte
    public var dataUltimaBolla:String?
    
    /// Conserviamo temporaneamente il valore dell'ultima bolla durante la compilazione, prima della validazione
    public var bollaCorrente:BollaAcquisto?
    
    public var transitionState:TransizioneScorte? {
        get { getTransition() }
        set { setTransition(value: newValue) }
    }
   
    public init() {
        self.statusScorte = .inStock
    }
        
    // Method
    public func getTransition() -> TransizioneScorte? {
        
        switch statusScorte {
        case .inEsaurimento,.esaurito,.outOfStock:
            
            if let bollaCorrente,
               let _ = bollaCorrente.data {
                return .inArrivo
            } else { return  .pending}

        case .inStock:
            return nil
            
        }
    }
    
   mutating public func setTransition(value:TransizioneScorte?) {
            
       guard let value else { return }
       
        switch value {
            
        case .pending:
            self.reverseInArrivo()
        case .inArrivo:
            self.setTemporaryLast()
        case .validate:
            self.validateAction()
        }

        }
    
    mutating private func validateAction() {
        
        guard let bollaCorrente,
        let data = bollaCorrente.data else {
            // throw error
            return }
        
        self.dataUltimaBolla = data
        self.bollaCorrente = nil
        self.statusScorte = .inStock
        
    }
        
    mutating public func setTemporaryLast() {
        
        if var bollaCorrente {
            
            bollaCorrente.data = self.currentDate
            self.bollaCorrente = bollaCorrente
            
        } else {
            
            let newBolla = BollaAcquisto()
            self.bollaCorrente = newBolla
            
        }
        
    }
    
    mutating public func reverseInArrivo() {
        
        guard var bollaCorrente else { return }
        
        bollaCorrente.data = nil
        self.bollaCorrente = bollaCorrente
        
    }
    
    mutating public func updateTransizioneScorte(to status:TransizioneScorte) {
        
        self.transitionState = status
        
    }
    
    mutating public func updateNotaBolla(note:String) {
        
        if var bollaCorrente {
            
            bollaCorrente.nota = note
            self.bollaCorrente = bollaCorrente
            
        } else {
            let newBolla = BollaAcquisto(nota: note)
            self.bollaCorrente = newBolla
            
        }
    }

    
}

extension InventarioScorte:Codable {
    
    public enum CodingKeys:String,CodingKey {
        
        case status = "stato_scorte"
        case ultimoAcquisto = "ultimo_acquisto"
        case bollaCorrente = "bolla_corrente"

    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.statusScorte = try container.decode(StatoScorte.self, forKey: .status)
        self.dataUltimaBolla = try container.decodeIfPresent(String.self, forKey: .ultimoAcquisto)
        self.bollaCorrente = try container.decodeIfPresent(BollaAcquisto.self, forKey: .bollaCorrente)
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.statusScorte, forKey: .status)
        try container.encode(self.dataUltimaBolla, forKey: .ultimoAcquisto)
        try container.encode(self.bollaCorrente, forKey: .bollaCorrente)
        
    }
    
    
}

public enum TransizioneScorte:String {
    
    case pending
    case inArrivo = "in arrivo"
    case validate
    
    public func imageAssociata() -> String {
        
        switch self {
            
        case .pending:
            return "cart.badge.plus.fill"
        case .inArrivo:
            return "creditcard"
        case .validate:
            return "storefront"
        }
    }
    
    public func coloreAssociato() -> Color {
        
        switch self {

        case .pending:
            return .yellow.opacity(0.7)
       case .inArrivo:
            return .seaTurtle_4.opacity(0.7)
        case .validate:
            return .gray
        }
        
    }
}

public enum StatoScorte:String,MyProEnumPack_L0 {
    
    public static var allCases:[StatoScorte] = [.inStock,.inEsaurimento,.esaurito]
    
    case inEsaurimento = "in esaurimento"
    case esaurito = "esaurite"
    case inStock = "in stock"
  //  case inArrivo = "in arrivo" // deprecato
    case outOfStock = "out of stock"
    
    public func orderAndStorageValue() -> Int {
        
        switch self {
            
        case .inStock:
            return 0
        case .inEsaurimento:
            return 1
        case .esaurito:
            return 2
       /* case .inArrivo:
            return 1*/
        case .outOfStock:
            return 3
        }

    }
    
    public func simpleDescription() -> String {
     
        switch self {
            
        case .inStock:
            return "in Stock"
        case .inEsaurimento:
            return "ai Minimi"
        case .esaurito:
            return "terminate"
       /* case .inArrivo:
            return "in Arrivo"*/
        case .outOfStock:
            return "out of stock"
        }
    }
    
    public func returnTypeCase() -> StatoScorte {
        self
    }
    
    public func imageAssociata() -> String {
        
        switch self {
            
        case .inStock:
            return "storefront" //"house"
        case .inEsaurimento:
            return "clock.badge.exclamationmark"
        case .esaurito:
            return "alarm.waves.left.and.right"
       /* case .inArrivo:
            return "creditcard"*/
        case .outOfStock:
            return "x.circle"
        }
    }
    
    public func coloreAssociato() -> Color {
        
        switch self {
            
        case .inStock:
            return .seaTurtle_3
        case .inEsaurimento:
            return .yellow.opacity(0.7)
        case .esaurito:
            return .red.opacity(0.7)
      /*  case .inArrivo:
            return .seaTurtle_4.opacity(0.7)*/
        case .outOfStock:
            return .gray
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
      /*case .inArrivo:
            return .seaTurtle_4*/
        case .outOfStock:
            return .gray
        }
    }
}

extension StatoScorte:Codable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        
        let value = try container.decode(String.self)
        let number = Int(value)
        
        self = Self.decodeStatus(from: number)
        
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        
        let value = self.encodeAsString()
        
        try container.encode(value)
        
    }
    
    private func encodeAsString() -> String {
        
        let value = self.orderAndStorageValue()
        return String(value)
    }
    
    private static func decodeStatus(from integer:Int?) -> StatoScorte {
        
        switch integer {
            
        case 0:
            return .inStock
        case 1:
            return .inEsaurimento
        case 2:
            return .esaurito
        default:
            return .outOfStock
        
        }
        
    }
    
}




///DEPRECATO-01-12-23
/*public struct Inventario:Equatable,Codable {

    // Nota 02.10 // Nota 21.11
    public var id:String
    
    public var ingInEsaurimento:[String]
    public var ingEsauriti:[String]
    public var archivioNotaAcquisto: [String:String] // key:IdIngrediente || Value: Nota per l'acquisto
    /// Il value della cronologia è un array di stringge combo (data di acquisto + nota di acquisto)
    public var cronologiaAcquisti:[String:[String]] // key = idIngrediente || Value = [date di acquisto + nota]
    public var lockedId:[String:[String]] // Key: data || value:[id oggetti a cui è stato cambiato lo status]
    public var archivioIngInEsaurimento: [String:[String]] // key:DataCorrente || value = [id ingredienti Esauriti depennati]
    
    
    public enum CodingKeys:String,CodingKey {
        
        case id
        case ingInEsaurimento = "ingredienti_in_esaurimento"
        case ingEsauriti = "ingredienti_esauriti"
        case archivioNotaAcquisto = "archivio_nota_acquisto"
        case cronologiaAcquisti = "cronologia_acquisti"
        case lockedId = "ingredienti_locked"
        case archivioIngInEsaurimento = "archivio_ingredienti_in_esaurimento"
        
    }
    
    
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
                return .seaTurtle_4.opacity(0.7)
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
                return .seaTurtle_4
            }
        }
    }
}*/ // deprecata in futuro
