//
//  File.swift
//  
//
//  Created by Calogero Friscia on 20/12/23.
//

import Foundation

public enum CS_FoodieError:Error,LocalizedError {
    
    case initIngredientError
    
    
   public var errorDescription: String? {
        
        switch self {
        case .initIngredientError:
            return NSLocalizedString("[ERRORE]_Il prodotto non può generare un ingrediente asProduct", comment: "Init ingrediente as product Fallito")
        }
        
    }
    
}
