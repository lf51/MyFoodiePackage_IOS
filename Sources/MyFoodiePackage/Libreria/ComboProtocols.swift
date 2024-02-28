//
//  File.swift
//  
//
//  Created by Calogero Friscia on 03/12/23.
//

import Foundation

public protocol MyProSubCollectionFullPack:MyProSubCollectionPack,MyProStarterPack_L0,MyProStarterPack_L01,Codable { } // non in uso

/*public protocol MyProToolPack_L0:MyProStarterPack_L0,MyProStarterPack_L01,MyProStatusPack_L1,MyProVisualPack_L0 { }*/

public protocol MyProVisualPack_L1: MyProVisualPack_L0,MyProStarterPack_L1 {}
