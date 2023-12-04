//
//  ClockSyncroVM.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 05/10/22.
//

import Foundation
import SwiftUI

public enum RoleModel:String,Codable {
    // app business
    case admin
    case collab
    
    case auth // user autenticato non assegnato ad alcuna property
    case guest // user Non Authenticato
    
    public func orderValue() -> Int {
        switch self {
        case .admin:
            return 1
        case .collab:
            return 2
        case .auth:
            return 0
        case .guest:
            return 3
            
        }
    }
}

public struct CloudDataStore {
    
  //  public var setupAccount: AccountSetup // caricato
   // public var inventarioScorte: Inventario // caricato
    
    
    public var allMyIngredients:[IngredientModel] // caricato
    
    public var allMyIngredientsImage:[IngredientModelImage] = [] // deprecata
    
    public var allMyDish:[ProductModel] // caricato
    public var allMyMenu:[MenuModel] // caricato
    //update 23.07.23
  //  public var allMyProperties:[PropertyModel] // deprecata
  //  public var allMyPropertiesRef:[RoleModel:String] // deprecata
    // end update
    public var allMyCategories: [CategoriaMenu] // caricato
    public var allMyReviews:[DishRatingModel] // caricato
    
   public enum CodingKeys:String,CodingKey { // deprecata
    
       case allMyIngredients = "user_ingredients"
       case allMyIngredientsImage = "ingredients_mage"
       case allMyDish = "user_products"
       case allMyMenu = "user_menu"
      // case allMyProperties =  "user_properties"
     //  case allMyPropertiesRef = "user_properties_ref"
       
       case allMyCategories = "user_categories"
       case allMyReviews = "dish_reviews"
       
      // case otherDocument = "property_setting"
       
    }
    
   /* public enum AdditionalInfoKeys:String,CodingKey {
        
      //  case setupAccount = "property_setup"
      //  case inventarioScorte = "property_inventario"
        
    } */
    
    public enum SubCollectionKey:String,CaseIterable {
        
        
        case allMyIngredients = "user_ingredients"
        case allMyDish = "user_products"
        case allMyMenu = "user_menu"
        
        case allMyCategories = "user_categories"
        case allMyReviews = "dish_reviews"
        
        case archivioBolleAcquisto = "archivio_bolle"
        
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
        
       // self.setupAccount = AccountSetup()
       // self.inventarioScorte = Inventario()
       
        self.allMyIngredientsImage = []
        self.allMyIngredients = [] // vanno inseriti gli ing,dish,menu,property fake
        self.allMyDish = []
        self.allMyMenu = []
       // self.allMyProperties = []
       // self.allMyPropertiesRef = [:]
        self.allMyCategories = [] // vanno inserite le categorie di default
        self.allMyReviews = [] // vanno inserite review fake
        
    }
    
  /* public init(accountSetup: AccountSetup, inventarioScorte: Inventario, allMyIngredients: [IngredientModel], allMyDish: [ProductModel], allMyMenu: [MenuModel], allMyProperties: [PropertyModel], allMyCategory: [CategoriaMenu], allMyReviews: [DishRatingModel]) {
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
