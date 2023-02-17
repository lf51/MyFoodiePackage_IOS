//
//  File.swift
//  
//
//  Created by Calogero Friscia on 07/02/23.
//

import Foundation
import SwiftUI

@ViewBuilder public func vbMediaL10(mediaGen:Double,mediaL10:Double,size:Image.Scale = .medium) -> some View {

    if mediaL10 == mediaGen {
        Image(systemName: "minus")
            .imageScale(size)
            .foregroundColor(Color.gray)
    }
    else if mediaL10 > mediaGen {
        Image(systemName: "arrowtriangle.up.fill")
            .imageScale(size)
            .foregroundColor(Color.green)
    }
    else {
        Image(systemName: "arrowtriangle.down")
            .imageScale(size)
            .foregroundColor(Color.red)
    }
    
}
