//
//  File.swift
//  
//
//  Created by Calogero Friscia on 02/02/24.
//

import Foundation
import SwiftUI

public enum ProductAdress {

    public static var allCases:[ProductAdress] = [.preparazione,.composizione,.finito]
    
    case preparazione
    case composizione
    case finito
    
    public func imageAssociated(to productType:ProductType? = nil) -> (system:String,color:Color) {
        
        switch self {
            
        case .finito:
            return ("takeoutbag.and.cup.and.straw",Color.gray)
        case .preparazione:
            if let productType { return productType.imageAssociated() }
            else { return ("fork.knife",Color.yellow) }
        case .composizione:
            return ("swatchpalette",Color.mint)
            
        }
    }
    
    public func tapDescription() -> String {
        
        switch self {
        case .finito:
            return "Prodotto & Ingrediente"
        case .preparazione:
            return "Preparazione standard"
        case .composizione:
            return "Composizione generica"
            
        }
    }
    
    public func pickerDescription() -> String {
        
        switch self {
        case .finito:
            return "Pronto"
        case .preparazione:
            return "Preparazione"
        case .composizione:
            return "Composizione"
            
        }
    }
    
    public func simpleDescription() -> String {
        
        switch self {
            
        case .finito:
            return "Prodotto Pronto"
        case .preparazione:
            return "Preparazione"
        case .composizione:
            return "Composizione"
            
        }
    }
    
    public func boxDescription() -> String {
        
        switch self {
            
        case .composizione:
            return "Descrizione (!)"
        default:
            return "Descrizione (Optional)"
            
        }
        
    }
    
    public func returnTypeCase() -> ProductAdress { return self }
    
    public func genereCase() -> String {
        
        switch self {
        
        case .finito:
            return "Nuovo"
        default:
            return "Nuova"
        }
    }
  /*  public func associatedValue() -> Any? {
        
        switch self {
            
        case .preparazione:
            return nil
        case .composizione(let ing):
            return ing
        case .finito(let rif):
            return rif
        }
    }*/
    
    public func orderAndStorageValue() -> Int {
        
        switch self {
            
        case .finito:
            return 2
        case .preparazione:
            return 0
        case .composizione:
            return 1
            
        }
    }

    public func extendedDescription() -> String {
        
        switch self {
            
        case .finito:
            return "Prodotto di terzi pronto alla vendita. Es: CocaCola. Viene contestualmente creato un ingrediente usabile nelle preparazioni."
        case .composizione:
            return "Composizione descrittiva, per ingredienti variabili e/o generici. Es: Tagliere di Salumi e Formaggi locali "
        case .preparazione:
            return "Combinazione e/o lavorazione in loco di uno o più ingredienti"
            
        }
    }
    
}
