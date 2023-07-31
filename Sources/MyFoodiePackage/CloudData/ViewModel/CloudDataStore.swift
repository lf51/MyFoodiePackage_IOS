//
//  ClockSyncroVM.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 05/10/22.
//

import Foundation
import SwiftUI

public enum RoleModel:String,Codable {
    
    case admin
    case collab
    case client
    case guest
    
    public func orderValue() -> Int {
        switch self {
        case .admin:
            return 0
        case .collab:
            return 1
        case .client:
            return 2
        case .guest:
            return 3
            
        }
    }
}

public struct CloudDataStore {
    
    public var setupAccount: AccountSetup // caricato
    public var inventarioScorte: Inventario // caricato
    
    public var allMyIngredients:[IngredientModel] // caricato
    public var allMyDish:[DishModel] // caricato
    public var allMyMenu:[MenuModel] // caricato
    //update 23.07.23
    public var allMyProperties:[PropertyModel] // deprecata
    public var allMyPropertiesRef:[RoleModel:String]
    // end update
    public var allMyCategories: [CategoriaMenu] // caricato
    public var allMyReviews:[DishRatingModel] // caricato
    
   public enum CodingKeys:String,CodingKey {
    
       case allMyIngredients = "allUserIngredients"
       case allMyDish = "allUserProducts"
       case allMyMenu = "allUserMenu"
       case allMyProperties =  "allUserProperties"
       case allMyPropertiesRef = "allUserRolePropertiesRef"
       
       case allMyCategories = "allUserCategories"
       case allMyReviews = "allUserReviews"
       
       case otherDocument = "otherDocuments"
       
    }
    
    public enum AdditionalInfoKeys:String,CodingKey {
        
        case setupAccount = "userAccountSetup"
        case inventarioScorte = "userInventarioScorte"
        
    }
    
   /* public init(userUID:String? = nil) { // deprecata in futuro
        
        self.allMyIngredients = []
        self.allMyDish = []
        self.allMyMenu = []
        self.allMyProperties = []
        self.allMyCategories = []
        self.allMyReviews = []
 
        self.setupAccount = AccountSetup()
        self.inventarioScorte = Inventario()
    } */
    
        
   public init() { // Deprecata in futuro
        
        self.setupAccount = AccountSetup()
        self.inventarioScorte = Inventario()
       
        self.allMyIngredients = [] // vanno inseriti gli ing,dish,menu,property fake
        self.allMyDish = []
        self.allMyMenu = []
        self.allMyProperties = []
        self.allMyPropertiesRef = [:]
        self.allMyCategories = [] // vanno inserite le categorie di default
        self.allMyReviews = [] // vanno inserite review fake
        
    }
    
  /* public init(accountSetup: AccountSetup, inventarioScorte: Inventario, allMyIngredients: [IngredientModel], allMyDish: [DishModel], allMyMenu: [MenuModel], allMyProperties: [PropertyModel], allMyCategory: [CategoriaMenu], allMyReviews: [DishRatingModel]) {
        self.setupAccount = accountSetup
        self.inventarioScorte = inventarioScorte
        self.allMyIngredients = allMyIngredients
        self.allMyDish = allMyDish
        self.allMyMenu = allMyMenu
        self.allMyProperties = allMyProperties
        self.allMyCategories = allMyCategory
        self.allMyReviews = allMyReviews
    }*/ // deprecata in futuro

}
