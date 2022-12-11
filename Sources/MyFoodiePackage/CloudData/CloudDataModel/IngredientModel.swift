//
//  ModelloIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 26/02/22.
//

import Foundation
import SwiftUI

// Creare Oggetto Ingrediente

public struct IngredientModel:MyProStarterPack_L0,MyProCloudDownloadPack_L1/*MyProToolPack_L1,MyProVisualPack_L1,MyProDescriptionPack_L0,MyProStatusPack_L1,MyProCloudPack_L1*/ /*MyModelStatusConformity */ {
 
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
    public var descrizione: String = "" //
    
    public var conservazione: ConservazioneIngrediente = .defaultValue //
    public var produzione: ProduzioneIngrediente = .defaultValue //
    public var provenienza: ProvenienzaIngrediente = .defaultValue //
    
    public var allergeni: [AllergeniIngrediente] = [] //
    public var origine: OrigineIngrediente = .defaultValue //
    
    public var status: StatusModel = .bozza() //
   // var inventario:Inventario = Inventario()

    // Method
    
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
    
    public init(frDocID:String,frDoc: [String:Any]) {
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
        
        
    }

    public func conversioneAllergeniInt() -> [Int] {
        
        let numAllergeni = self.allergeni.map({$0.orderAndStorageValue()})
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
        
        if self.origine == .animale {
            
            if self.allergeni.contains(where: {
                
                $0 == .pesce || $0 == .crostacei || $0 == .molluschi
                
            }) { allergeneDiServizio = .pesce }
            
            else if self.allergeni.contains(where: {
                
                $0 == .latte_e_derivati
                
            }) { allergeneDiServizio = .latte_e_derivati }
            
            else if self.allergeni.contains(where: {
                
                $0 == .uova_e_derivati
                
            }) { allergeneDiServizio = .uova_e_derivati }
            
            else { return (self.origine.imageAssociated(),.large) }
            
        } else {
            
            if self.allergeni.contains(where: {
                
                $0 == .glutine
                
            }) { allergeneDiServizio = .glutine
                return (allergeneDiServizio.imageAssociated(),.medium)
            }// { allergeneDiServizio = .glutine }
            
            else if self.allergeni.contains(where: {
                
                $0 == .arachidi_e_derivati || $0 == .fruttaAguscio
                
            }) { allergeneDiServizio = .arachidi_e_derivati }
            
            else { return (self.origine.imageAssociated(),.large)}
    
        }
 
        return (allergeneDiServizio.imageAssociated(),.large)
    }

    /// ritorna true se tutte le proprietà optional sono state compilate, e dunque il modello è completo.
    public func optionalComplete() -> Bool {
        
        self.descrizione != "" &&
        self.produzione != .defaultValue &&
        self.provenienza != .defaultValue
    }
}




