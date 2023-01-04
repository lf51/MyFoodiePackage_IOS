//
//  File.swift
//  
//
//  Created by Calogero Friscia on 07/12/22.
//

import Foundation
import SwiftUI
import UIKit

/*public enum CatalogoColori:String {
    
    case seaTurtle_1 = "SeaTurtlePalette_1"
    case seaTurtle_2 = "SeaTurtlePalette_2"
    case seaTurtle_3 = "SeaTurtlePalette_3"
    case seaTurtle_4 = "SeaTurtlePalette_4"
    
   public func color() -> Color {
        
        Color(self.rawValue,bundle: .module)
        
    }
}*/ // deprecata 31.12.22 Sostituita dall'extension al Color

public extension Color {
    
    static let seaTurtle_1 = Color("SeaTurtlePalette_1", bundle: .module)
    static let seaTurtle_2 = Color("SeaTurtlePalette_2", bundle: .module)
    static let seaTurtle_3 = Color("SeaTurtlePalette_3", bundle: .module)
    static let seaTurtle_4 = Color("SeaTurtlePalette_4", bundle: .module)
}


