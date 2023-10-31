//
//  ModelloIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 26/02/22.
//

import Foundation
import SwiftUI

// Creare Oggetto Ingrediente

/// oggetto di servizio per salvare i dati variabili da utente a utente ad esclusione dell'Id
public struct IngredientModelImage:MyProStarterPack_L0,Codable {
    
    public var id:String
    public var descrizione:String
    public var status:StatusModel
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
} // deprecato

public struct IngredientModel:MyProStarterPack_L01/*MyProToolPack_L1,MyProVisualPack_L1,MyProDescriptionPack_L0,MyProStatusPack_L1,MyProCloudPack_L1*/ /*MyModelStatusConformity */ {
 
    public static func == (lhs: IngredientModel, rhs: IngredientModel) -> Bool {
       return
      lhs.id == rhs.id &&
      lhs.intestazione == rhs.intestazione &&
      lhs.descrizione == rhs.descrizione &&
      lhs.conservazione == rhs.conservazione &&
      lhs.produzione == rhs.produzione &&
      lhs.provenienza == rhs.provenienza &&
      lhs.allergeni == rhs.allergeni &&
      lhs.origine == rhs.origine &&
      lhs.status == rhs.status 
    //  lhs.inventario == rhs.inventario
   
    }
    
   // var id: String { creaID(fromValue: self.intestazione) } // Deprecata 18.08
    public var id: String = UUID().uuidString //

    public var intestazione: String = "" //
    public var descrizione: String? = "" //
    
    public var conservazione: ConservazioneIngrediente = .defaultValue //
    public var produzione: ProduzioneIngrediente = .defaultValue //
    public var provenienza: ProvenienzaIngrediente = .defaultValue //
    
    public var allergeni: [AllergeniIngrediente]? //
    public var origine: OrigineIngrediente = .defaultValue //
    
    public var status: StatusModel = .bozza() //
   // var inventario:Inventario = Inventario()

    // Method


    
 
    
  
    
   /* private var sharedKey:[CodingKeys] = [.allergeni,.conservazione,.conservazione,.intestazione,.origine,.produzione,.provenienza]
    private var privateKey:[CodingKeys] = [.id,.descrizione,.status]
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(descrizione, forKey: .descrizione)
        try container.encode(status, forKey: .status)
        
        
        
    } */

  /* public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.intestazione = try container.decode(String.self, forKey: .intestazione)
        self.descrizione = try container.decode(String.self, forKey: .descrizione)
        self.conservazione = try container.decode(ConservazioneIngrediente.self, forKey: .conservazione)
        self.produzione = try container.decode(ProduzioneIngrediente.self, forKey: .produzione)
        self.provenienza = try container.decode(ProvenienzaIngrediente.self, forKey: .provenienza)
        self.allergeni = try container.decodeIfPresent([AllergeniIngrediente].self, forKey: .allergeni)
        self.origine = try container.decode(OrigineIngrediente.self, forKey: .origine)
        self.status = try container.decode(StatusModel.self, forKey: .status)
    }*/
    
    public init(intestazione:String,descrizione:String,conservazione:ConservazioneIngrediente,produzione:ProduzioneIngrediente,provenienza:ProvenienzaIngrediente,allergeni:[AllergeniIngrediente],origine:OrigineIngrediente,status:StatusModel) {
        
        self.intestazione = intestazione
        self.descrizione = descrizione
        self.conservazione = conservazione
        self.produzione = produzione
        self.provenienza = provenienza
        self.allergeni = allergeni
        self.origine = origine
        self.status = status
        
        // usato nei test. da abolire
    }
    
    public init() {
        
        // creare un init di default
        
    }
    
    public init(id:String) {
        self.id = id
     
    }
    
  /*  public init(frDocID:String,frDoc: [String:Any]) {
        // init da firebase Data
        
        let conservazioneInt = frDoc[DataBaseField.conservazione] as? Int ?? 0
        let produzioneInt = frDoc[DataBaseField.produzione] as? Int ?? 0
        let provenienzaInt = frDoc[DataBaseField.provenienza] as? Int ?? 0
        let origineInt = frDoc[DataBaseField.origine] as? Int ?? 0
        let statusInt = frDoc[DataBaseField.status] as? Int ?? 0
        let allergeniInt = frDoc[DataBaseField.allergeni] as? [Int] ?? []
        
        self.id = frDocID
        self.intestazione = frDoc[DataBaseField.intestazione] as? String ?? ""
        self.descrizione = frDoc[DataBaseField.descrizione] as? String ?? ""
        self.conservazione = ConservazioneIngrediente.convertiInCase(fromNumber: conservazioneInt)
        self.produzione = ProduzioneIngrediente.convertiInCase(fromNumber: produzioneInt)
        self.provenienza = ProvenienzaIngrediente.convertiInCase(fromNumber: provenienzaInt)
        self.origine = OrigineIngrediente.convertiInCase(fromNumber: origineInt)
        self.status = StatusModel.convertiInCase(fromNumber: statusInt)
        self.allergeni = allergeniInt.map({AllergeniIngrediente.convertiInCase(fromNumber: $0)})
  
    }
    
    
    public struct DataBaseField {
        
        public static let intestazione = "intestazione"
        public static let descrizione = "descrizione"
        public static let conservazione = "conservazione"
        public static let produzione = "produzione"
        public static let provenienza = "provenienza"
        public static let allergeni = "allergeni"
        public static let origine = "origine"
        public static let status = "status"
        
        
    } */

    public func conversioneAllergeniInt() -> [Int] {
        
        guard let allergeneIn = self.allergeni else { return []}
        
        let numAllergeni = allergeneIn.map({$0.orderAndStorageValue()})
        return numAllergeni
        
    }

    public func creaID(fromValue: String) -> String {
        fromValue.replacingOccurrences(of: " ", with: "").lowercased()
    } // deprecata in futuro
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    /// Permette di sovrascrivere l'immagine associata all'origine con una immagine riferita agli allergeni che rispecchia meglio il prodotto - pensata e costruita per l'ingredientRow
    public func associaImmagine() -> (name:String,size:Image.Scale) {
        
        var allergeneDiServizio:AllergeniIngrediente = .defaultValue
        //
        let allergeneIn = self.allergeni ?? []
        // 09.02.23 Modifica per farlo funzionare con l'optional che richiede di essere migliorata
        
        if self.origine == .animale {
            
            if allergeneIn.contains(where: {
                
                $0 == .pesce || $0 == .crostacei || $0 == .molluschi
                
            }) { allergeneDiServizio = .pesce }
            
            else if allergeneIn.contains(where: {
                
                $0 == .latte_e_derivati
                
            }) { allergeneDiServizio = .latte_e_derivati }
            
            else if allergeneIn.contains(where: {
                
                $0 == .uova_e_derivati
                
            }) { allergeneDiServizio = .uova_e_derivati }
            
            else { return (self.origine.imageAssociated(),.large) }
            
        } else {
            
            if allergeneIn.contains(where: {
                
                $0 == .glutine
                
            }) { allergeneDiServizio = .glutine
                return (allergeneDiServizio.imageAssociated(),.medium)
            }// { allergeneDiServizio = .glutine }
            
            else if allergeneIn.contains(where: {
                
                $0 == .arachidi_e_derivati || $0 == .fruttaAguscio
                
            }) { allergeneDiServizio = .arachidi_e_derivati }
            
            else { return (self.origine.imageAssociated(),.large)}
    
        }
 
        return (allergeneDiServizio.imageAssociated(),.large)
    }

    /// ritorna true se tutte le proprietà optional sono state compilate, e dunque il modello è completo.
    public func optionalComplete() -> Bool {
        
        self.descrizione != ""// &&
      //  self.produzione != .defaultValue &&
      //  self.provenienza != .defaultValue
    }
}

extension IngredientModel:Codable {
    
    public static let codingInfo:CodingUserInfoKey = CodingUserInfoKey(rawValue: "ingredientModel")!
    
    public enum CodingKeys:String,CodingKey {
        
        case id
        // vanno nel cloud
        case intestazione
        case conservazione
        case produzione
        case provenienza
        case allergeni
        case origine
        // a discrezione dell'utente
        case descrizione
        case status
    }
    
    public init(from decoder: Decoder) throws {
        print("[DECODE]_IngredientModel")
        let decodingCase = decoder.userInfo[Self.codingInfo] as? MyCodingCase ?? .subCollection
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        
        switch decodingCase {
            
        case .mainCollection:
           
            self.intestazione = try container.decode(String.self, forKey: .intestazione)
            self.conservazione = try container.decode(ConservazioneIngrediente.self, forKey: .conservazione)
            self.produzione = try container.decode(ProduzioneIngrediente.self, forKey: .produzione)
            self.provenienza = try container.decode(ProvenienzaIngrediente.self, forKey: .provenienza)
            self.allergeni = try container.decodeIfPresent([AllergeniIngrediente].self, forKey: .allergeni)
            self.origine = try container.decode(OrigineIngrediente.self, forKey: .origine)
            
            self.status = .bozza(.inPausa)
            
        case .subCollection:
            
            self.intestazione = ""
            self.conservazione = .defaultValue
            self.produzione = .defaultValue
            self.provenienza = .defaultValue
            self.allergeni = nil
            self.origine = .defaultValue
            
            self.descrizione = try container.decodeIfPresent(String.self, forKey: .descrizione)
            self.status = try container.decode(StatusModel.self, forKey: .status)
            
        }
 
    }
    
    public func encode(to encoder: Encoder) throws {
        print("[ENCODE]_IngredientModel")
        
        let codingCase = encoder.userInfo[Self.codingInfo] as? MyCodingCase ?? .subCollection
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        
        switch codingCase {
            
        case .mainCollection:
            
            try container.encode(self.intestazione, forKey: .intestazione)
            try container.encode(self.conservazione, forKey: .conservazione)
            try container.encode(self.produzione, forKey: .produzione)
            try container.encode(self.provenienza, forKey: .provenienza)
            try container.encode(self.allergeni, forKey: .allergeni)
            try container.encode(self.origine, forKey: .origine)
            
        case .subCollection:
            
            try container.encodeIfPresent(self.descrizione, forKey: .descrizione)
            try container.encode(self.status, forKey: .status)
            
        }
        
        
    }
    
    
}

public struct IngredientModelInSintesi:Hashable { // ricapire a che serve
    
    var intestazione:String
    var isPrincipal:Bool
    var isTemporaryOff:Bool
    var isBio:Bool
    var hasAllergene:Bool
    var isFreeze:Bool
    
    var idSostituto:String?
    
    public init(
        intestazione: String,
        isPrincipal: Bool,
        isTemporaryOff: Bool,
        isBio: Bool,
        hasAllergene: Bool,
        isFreeze:Bool,
        idSostituto: String? = nil) {
            
        self.intestazione = intestazione
        self.isPrincipal = isPrincipal
        self.isTemporaryOff = isTemporaryOff
        self.isBio = isBio
        self.hasAllergene = hasAllergene
        self.isFreeze = isFreeze
        self.idSostituto = idSostituto
    }
}

extension IngredientModel {
    
    /// Metodo con in quale aggiornamo l'ingredient Model pubblico all'immagine custom data dal singolo User
    public func updateModel(from image:IngredientModelImage) -> Self {
        
        var updatedIng = self
        updatedIng.descrizione = image.descrizione
        updatedIng.status = image.status
        return updatedIng
        
    }
    
    public func retrieveImageFromSelf() -> IngredientModelImage {
        
        return IngredientModelImage(
            id: self.id,
            descrizione: self.descrizione ?? "",
            status: self.status)
    }
    
    
    
} // deprecata in futuro
