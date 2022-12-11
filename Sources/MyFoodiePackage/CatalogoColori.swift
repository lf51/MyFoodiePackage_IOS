//
//  File.swift
//  
//
//  Created by Calogero Friscia on 07/12/22.
//

import Foundation
import SwiftUI

public enum CatalogoColori:String {
    
    case seaTurtle_1 = "SeaTurtlePalette_1"
    case seaTurtle_2 = "SeaTurtlePalette_2"
    case seaTurtle_3 = "SeaTurtlePalette_3"
    case seaTurtle_4 = "SeaTurtlePalette_4"
    
   public func color() -> Color {
        
        Color(self.rawValue,bundle: .module)
        
    }
}
