//
//  File.swift
//  
//
//  Created by Calogero Friscia on 01/01/23.
//

import Foundation
import SwiftUI

/*
public struct CS_SintesiIngrediente: ViewModifier {
    
    let item: IngredientModelInSintesi
    
    public init(item: IngredientModelInSintesi) {
        self.item = item
    }
    
    public func body(content: Content) -> some View {
        
     content
            .font(.subheadline)
            .foregroundColor(item.isTemporaryOff ? .seaTurtle_1 : .seaTurtle_4)
            .strikethrough(item.isTemporaryOff, color: Color.gray)
            .underline(item.isBio, pattern: .solid, color: Color.green)
            .overlay(alignment:.topTrailing) {
                 if item.hasAllergene {
                     Text("*")
                         .foregroundColor(Color.white)
                         .offset(x: 5, y: -3)
                 }
             }
        
    }
}

public extension View {
    
    func csSintesiIngrediente(item:IngredientModelInSintesi) -> some View {
        
        self.modifier(CS_SintesiIngrediente(item: item))
 
    }
}

*/ // Non Necessario
