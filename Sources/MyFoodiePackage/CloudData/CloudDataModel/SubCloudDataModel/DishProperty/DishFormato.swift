//
//  DishFormati.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

public struct DishFormat:Hashable,Codable {
    
    var id:String = "DishFormatPrice_NoneID" // Non serve. Non lo salviamo su firebase e quindi ne viene assegnato uno nuovo ogni volta
    
    public var label: String
    public var price: String
    
    public let type: DishFormatType
   
    public init(type: DishFormatType) {
        self.label = ""
        self.price = ""
        self.type = type
    }
        
    public init(frMapData: [String:Any]) {
        
        let typeInt = frMapData[DataBaseField.type] as? Int ?? 0
        
        self.label = frMapData[DataBaseField.label] as? String ?? ""
        self.price = frMapData[DataBaseField.price] as? String ?? ""
        self.type = DishFormatType.convertiInCase(fromNumber: typeInt)
    }
    
    public func documentDataForFirebaseSavingAction() -> [String : Any] {
        
        let documentData:[String:Any] = [
            DataBaseField.label : self.label,
            DataBaseField.price : self.price,
            DataBaseField.type : self.type.orderAndStorageValue()
        ]
        return documentData
    }
    
    public struct DataBaseField {
        
        static let label = "label"
        static let price = "price"
        static let type = "type"
        
    }
    
    
}

public enum DishFormatType:MyProCloudPack_L0,Codable {
    
    case mandatory,opzionale
    
    public func orderAndStorageValue() -> Int {
        switch self {
        case .mandatory: return 0
        case .opzionale: return 1
        }
    }
    
    public static func convertiInCase(fromNumber: Int) -> DishFormatType {
        switch fromNumber {
        case 0: return .mandatory
        default: return .opzionale
        }
    }

}


