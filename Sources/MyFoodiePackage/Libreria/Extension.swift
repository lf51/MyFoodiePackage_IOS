//
//  File.swift
//  
//
//  Created by Calogero Friscia on 20/09/23.
//

import Foundation

extension String {
    
    func capitalizeFirst() -> String {
        
        prefix(1).capitalized + dropFirst()
    }
}
