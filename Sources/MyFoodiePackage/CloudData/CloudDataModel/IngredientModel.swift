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

public struct IngredientModel:MyProStarterPack_L01 {
 
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

    public var id: String

    public var intestazione: String
    public var descrizione: String?
    
    public var conservazione: ConservazioneIngrediente
    public var produzione: ProduzioneIngrediente
    public var provenienza: ProvenienzaIngrediente
    
    public var allergeni: [AllergeniIngrediente]?
    public var origine: OrigineIngrediente
    
    public var status: StatusModel
   // var inventario:Inventario = Inventario()

    public init() {
      
        self.id = UUID().uuidString
        self.intestazione = ""
        self.descrizione = nil
        self.conservazione = .defaultValue
        self.produzione = .defaultValue
        self.provenienza = .defaultValue
        self.origine = .defaultValue
        self.allergeni = nil
        self.status = .noStatus
      
    }

    // method

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
        
        guard let descrizione else { return false }
        
        return descrizione != ""

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
        
        let decodingCase = decoder.userInfo[Self.codingInfo] as? MyCodingCase ?? .subCollection
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        
        switch decodingCase {
            
        case .inbound:

            self.conservazione = try container.decode(ConservazioneIngrediente.self, forKey: .conservazione)
            self.produzione = try container.decode(ProduzioneIngrediente.self, forKey: .produzione)
            self.provenienza = try container.decode(ProvenienzaIngrediente.self, forKey: .provenienza)
            self.allergeni = try container.decodeIfPresent([AllergeniIngrediente].self, forKey: .allergeni)
            self.origine = try container.decode(OrigineIngrediente.self, forKey: .origine)
            
            self.intestazione = ""
            self.descrizione = nil
            self.status = .noStatus
            
        case .mainCollection:
           
            self.intestazione = try container.decode(String.self, forKey: .intestazione)
            self.conservazione = try container.decode(ConservazioneIngrediente.self, forKey: .conservazione)
            self.produzione = try container.decode(ProduzioneIngrediente.self, forKey: .produzione)
            self.provenienza = try container.decode(ProvenienzaIngrediente.self, forKey: .provenienza)
            self.allergeni = try container.decodeIfPresent([AllergeniIngrediente].self, forKey: .allergeni)
            self.origine = try container.decode(OrigineIngrediente.self, forKey: .origine)
            
            self.status = .noStatus
            
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

        let codingCase = encoder.userInfo[Self.codingInfo] as? MyCodingCase ?? .subCollection
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        
        switch codingCase {
            
        case .inbound:
            
           // try container.encode(self.intestazione, forKey: .intestazione)
            try container.encode(self.conservazione, forKey: .conservazione)
            try container.encode(self.produzione, forKey: .produzione)
            try container.encode(self.provenienza, forKey: .provenienza)
            try container.encode(self.allergeni, forKey: .allergeni)
            try container.encode(self.origine, forKey: .origine)
          //  try container.encodeIfPresent(self.descrizione, forKey: .descrizione)
           // try container.encode(self.status, forKey: .status)
            
        case .mainCollection:
            
            try container.encode(self.intestazione, forKey: .intestazione)
            try container.encode(self.conservazione, forKey: .conservazione)
            try container.encode(self.produzione, forKey: .produzione)
            try container.encode(self.provenienza, forKey: .provenienza)
            try container.encode(self.allergeni, forKey: .allergeni)
            try container.encode(self.origine, forKey: .origine)
            
        case .subCollection:
            
            try container.encode(self.descrizione, forKey: .descrizione)
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
