//
//  DishCategory.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation
import SwiftUI

public enum TipoDieta:Identifiable,MyProEnumPack_L0 /*: MyEnumProtocol,MyEnumProtocolMapConform*/ {

  //  var intestazione: String {get{ self.simpleDescription() } set{ }}
  //  var descrizione: String { get {self.extendedDescription() ?? "noDescription"} set { } }
   // var status: StatusModel = .bozza // Non serve a niente. Da Sistemare
    
    public static var allCases: [TipoDieta] = [.vegano,.vegetariano,.zeroLatticini,.glutenFree]
   // public static var defaultValue: TipoDieta = TipoDieta.standard

   // case standard // contiene di tutto
    
    case vegetariano // può contenere latte&derivati - Non può contenere carne o pesce
    case zeroLatticini // non contiene latte animale e prodotti derivati
    case vegano // può contenere solo vegetali
    case glutenFree // lo usiamo per avere un valore di default Nullo
    
    public var id: String { self.createId()}
    
    public func simpleDescription() -> String {
        
        switch self {
            
        case .vegetariano: return "Vegetariana"
        case .zeroLatticini: return "No Latticini"
        case .vegano: return "Vegana"
        case .glutenFree: return "Senza Glutine"
        
        }
    }
    
    func createId() -> String {
        
        self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased() // standardizziamo le stringhe ID in lowercases senza spazi
    }
    
    public func extendedDescription() -> String {
        
        switch self {
        
        case .vegetariano: return "Priva di ingredienti di origine animale (ad eccezione del latte e suoi derivati) e pesce."
        case .zeroLatticini: return "Priva di latte animale e ingredienti derivati."
        case .vegano: return "Contenente solo ingredienti di origine vegetale."
        case .glutenFree: return "Priva di Glutine."
        
        }
        
    }
    
    public func imageAssociated() -> String {
        // 07.01.23 Capire perchè diamo solo questa immagine:
        "square.and.arrow.up.trianglebadge.exclamationmark"
        
        //
     /*   switch self {
            
        case .standard:
            return nil
        case .vegetariano:
            return nil
        case .vegariano:
            return nil
        case .vegano:
            return nil
        case .glutenFree:
            return nil
        } */
    }
    
    public func returnTypeCase() -> TipoDieta {
        
        return self
    }
    
    public func orderAndStorageValue() -> Int {
        
        switch self {
            
        case .vegetariano:
            return 1
        case .zeroLatticini:
            return 2
        case .vegano:
            return 3
        case .glutenFree:
            return 4
        }
    }
    
    public func coloreAssociato() -> Color {
        
        switch self {
            
        case .vegetariano:
            return Color.yellow
        case .zeroLatticini:
            return Color.teal
        case .vegano:
            return Color.green
        case .glutenFree:
            return Color.orange
        }
    }
}
