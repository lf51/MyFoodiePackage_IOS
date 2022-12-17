//
//  File.swift
//  
//
//  Created by Calogero Friscia on 10/12/22.
//

import Foundation

public protocol MyProViewModelPack_L1:ObservableObject {
    
    var allMyIngredients:[IngredientModel] { get set }
    var allMyDish:[DishModel] { get set }
    var allMyMenu:[MenuModel] { get set }
    var allMyProperties:[PropertyModel] { get set }
    var allMyCategories:[CategoriaMenu] { get set }
    var allMyReviews:[DishRatingModel] { get set }
    
    // associatedType V:MyProXXXX
    // var cloudDataStore: V { get set }
    
}

//protocol MyProXXX {
 //   associatedtype CodingKeys:String,CodingKey
//}
