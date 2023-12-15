//
//  ModelloIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 26/02/22.
//

import Foundation
import SwiftUI

/// in uso nel client ingredient Row.. verificare Utilità
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
} // deprecato in futuro

public enum IngredientType:String,Codable {
    
    case standard
    case diSintesi = "di_sintesi" // sintesi di una preparazione
    case asProduct = "as_product" // sottostante un prodotto finito
   // case limited // sottostante di una composizione
    
    public func imageAssociated() -> String {
        
        switch self {
        case .standard:
           return "leaf"
        case .diSintesi:
            return "lasso.badge.sparkles"
        case .asProduct:
            return "takeoutbag.and.cup.and.straw"
      //  case .limited:
        //    return "x.circle"
        }
        
    }
    
    public func simpleDescription() -> String {
        
        switch self {
        case .standard:
           return "standard"
        case .diSintesi:
            return "sintesi preparazione"
        case .asProduct:
            return "prodotto pronto"
       // case .limited:
         //   return "sottostante composizione"
        }
        
    }
    
    public func coloreAssociato() -> Color {
        
        switch self {
        case .standard:
            return Color.yellow
        case .diSintesi:
            return Color.mint
        case .asProduct:
            return Color.gray
      //  case .limited:
        //    return Color.clear
        }
    }
}

public struct IngredientModel:MyProStarterPack_L0,MyProStarterPack_L01,MyProDescriptionPack_L0 {
 
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
      lhs.status == rhs.status &&
      lhs.inventario == rhs.inventario &&
      lhs.type == rhs.type
    }

    public var id: String

    public var intestazione: String
    public var descrizione: String?
    
    public var conservazione: ConservazioneIngrediente
    public var produzione: ProduzioneIngrediente
    public var provenienza: ProvenienzaIngrediente
    
    public var allergeni: [AllergeniIngrediente]?
    public var origine: OrigineIngrediente
    
   // public var status: StatusModel
    public var inventario:InventarioScorte?
    public var type:IngredientType

    public init(_ type:IngredientType = .standard) {
      
        self.id = UUID().uuidString
        self.intestazione = ""
        self.descrizione = nil
        self.conservazione = .defaultValue
        self.produzione = .defaultValue
        self.provenienza = .defaultValue
        self.origine = .defaultValue
        self.allergeni = nil
        self.type = type
        
        switch type {
            
        case .standard,.asProduct:
            self.inventario = InventarioScorte()
        case .diSintesi:
            self.inventario = nil
     
        }
        
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}

extension IngredientModel:Codable {
    
    public static let codingInfo:CodingUserInfoKey = CodingUserInfoKey(rawValue: "ingredientModel")!
    
    public enum CodingKeys:String,CodingKey {
        
        case id
  
        case intestazione
        case descrizione
        case conservazione
        case produzione
        case provenienza
        case allergeni
        case origine
        case type = "tipologia"
        case inventario
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
            self.descrizione = try container.decodeIfPresent(String.self, forKey: .descrizione)
            self.intestazione = ""
            
           // self.status = .noStatus
            self.inventario = nil
            self.type = .standard
            
        case .mainCollection:
           
            self.intestazione = try container.decode(String.self, forKey: .intestazione)
            self.conservazione = try container.decode(ConservazioneIngrediente.self, forKey: .conservazione)
            self.produzione = try container.decode(ProduzioneIngrediente.self, forKey: .produzione)
            self.provenienza = try container.decode(ProvenienzaIngrediente.self, forKey: .provenienza)
            self.allergeni = try container.decodeIfPresent([AllergeniIngrediente].self, forKey: .allergeni)
            self.origine = try container.decode(OrigineIngrediente.self, forKey: .origine)
            
           // self.status = .noStatus
            self.inventario = InventarioScorte()
            self.type = .standard
            
        case .subCollection:
            
            self.intestazione = try container.decode(String.self, forKey: .intestazione)
            self.descrizione = try container.decodeIfPresent(String.self, forKey: .descrizione)
            
            self.conservazione = try container.decode(ConservazioneIngrediente.self, forKey: .conservazione)
            self.produzione = try container.decode(ProduzioneIngrediente.self, forKey: .produzione)
            self.provenienza = try container.decode(ProvenienzaIngrediente.self, forKey: .provenienza)
            self.allergeni = try container.decodeIfPresent([AllergeniIngrediente].self, forKey: .allergeni)
            self.origine = try container.decode(OrigineIngrediente.self, forKey: .origine)
          //  self.status = try container.decode(StatusModel.self, forKey: .status)
            self.inventario = try container.decodeIfPresent(InventarioScorte.self, forKey: .inventario)
            self.type = try container.decode(IngredientType.self, forKey: .type)
            
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
            try container.encodeIfPresent(self.allergeni, forKey: .allergeni)
            try container.encode(self.origine, forKey: .origine)
            try container.encodeIfPresent(self.descrizione, forKey: .descrizione)
           // try container.encode(self.status, forKey: .status)
            
        case .mainCollection:
            // Non in uso
            throw URLError(.cannotConnectToHost)
           /* try container.encode(self.intestazione, forKey: .intestazione)
            try container.encode(self.conservazione, forKey: .conservazione)
            try container.encode(self.produzione, forKey: .produzione)
            try container.encode(self.provenienza, forKey: .provenienza)
            try container.encode(self.allergeni, forKey: .allergeni)
            try container.encode(self.origine, forKey: .origine)*/
            
        case .subCollection:
            
            try container.encode(self.intestazione, forKey: .intestazione)
            try container.encode(self.descrizione, forKey: .descrizione)
            try container.encode(self.conservazione, forKey: .conservazione)
            try container.encode(self.produzione, forKey: .produzione)
            try container.encode(self.provenienza, forKey: .provenienza)
            try container.encode(self.allergeni, forKey: .allergeni)
            try container.encode(self.origine, forKey: .origine)
           // try container.encode(self.status, forKey: .status)//
            try container.encodeIfPresent(self.inventario, forKey: .inventario)
            try container.encode(self.type, forKey: .type)
            
        }
        
        
    }
    
    
}

extension IngredientModel {
    
    public func creaID(fromValue: String) -> String {
        fromValue.replacingOccurrences(of: " ", with: "").lowercased()
    } // deprecata in futuro
    
    public func conversioneAllergeniInt() -> [Int] {
        
        guard let allergeneIn = self.allergeni else { return []}
        
        let numAllergeni = allergeneIn.map({$0.orderAndStorageValue()})
        return numAllergeni
        
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
}
/// Gestione Inventario
extension IngredientModel {
    
    public func statusScorte() -> StatoScorte {
        
        guard let inventario else {
            return .inStock // da sviluppare magari con un altro case che identifica gli ingredienti di sintesi facendo una summa degli ingredienti che compongono il piatto sintetizzato
        }
        
        return inventario.statusScorte
        
    }
    
    public func transitionScorte() -> TransizioneScorte {
        
        guard let inventario else {
            return .validate // da sviluppare magari con un altro case che identifica gli ingredienti di sintesi facendo una summa degli ingredienti che compongono il piatto sintetizzato
        }
        
      /*  guard let transitionState = inventario.transitionState else {
            return .validate
        }*/
        
        return inventario.transitionState
        
    }
    
    public func isDaAcquistare() -> Bool {
        
        guard let inventario else { return false }
        
       // guard let transitionState = inventario.transitionState else { return false }
   
        return inventario.transitionState != .validate
    }
    
    mutating public func changeTransizioneScorte(to status:TransizioneScorte) {
        
        guard var inventario else { 
            // throw error
            return }
        
        inventario.updateTransizioneScorte(to: status)
        self.inventario = inventario
    }
        
    mutating public func addNotaToBolla(nota:String) {
        guard let inventario else { return }
        
        var updateInventario = inventario
        updateInventario.updateNotaBolla(note: nota)
        self.inventario = updateInventario
    }
    
    public func notaBollaCorrente() -> String {
        
        guard let inventario else { return "" }
        
        guard let bollaCorrente = inventario.bollaCorrente else { return "" }
        
        if let nota = bollaCorrente.nota {
            return nota
        } else { return "" }
        
    }
    
    public func lastAcquisto() -> String {
        
        guard let inventario else { return "No_Inventario" }
        
        guard let last = inventario.dataUltimaBolla else {
            return "No recorded Data"
        }
        
        return last
    
    }
    
    mutating public func changeStatusScorte(newValue:StatoScorte) {
        
       guard var inventario else { return }
       
       inventario.statusScorte = newValue
       self.inventario = inventario
       
    }
    
    public func statoScorteDescription() -> String {
        
        guard let inventario else { return "" }
        let transitionState = inventario.transitionState
        
        if transitionState == .inArrivo {
            return transitionState.rawValue
        } else {
            return inventario.statusScorte.simpleDescription()
        }

    }
        
}
/// Lo Status e il transition sono gestiti automaticamente
extension IngredientModel:MyProStatusPack_L01 {
    
   // public var statusCache: Int? { nil }
    
    public var status: StatusModel { self.getStatus() }
    
    public var statusTransition:StatusTransition { self.getStatusTransition() }
    
    private func getStatus() -> StatusModel {
        
      //  guard self.intestazione != "" else { return .noStatus }
        
        if self.optionalComplete() { return .completo }
        else { return .bozza }
        
    }
    
    private func getStatusTransition() -> StatusTransition {
        
        guard let inventario else { return .disponibile/* da Sviluppare */ }
        
        switch inventario.statusScorte {
            
        case .inEsaurimento,.inStock: return .disponibile
        case .esaurito: return .inPausa
        case .outOfStock: return .archiviato
            
        }
    }
    
    public func modelStatusDescription() -> String {
         "Ingrediente (\(self.status.simpleDescription().capitalized))"
     }
   
    /// ritorna true se tutte le proprietà optional sono state compilate, e dunque il modello è completo.
    public func optionalComplete() -> Bool {
        
        guard let descrizione else { return false }
        
        return descrizione != ""

    }
    
    public func fullStatusDescription() -> String {
        
        "\(self.status.simpleDescription()) \(self.statusTransition.simpleDescription())"
    }
    
}
