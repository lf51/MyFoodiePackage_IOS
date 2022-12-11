//
//  PropertyModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import Foundation
import MapKit
import SwiftUI
//import Firebase

// Nota 19.09
public struct PropertyModel:MyProStarterPack_L0,MyProCloudDownloadPack_L1/*MyProStarterPack_L1,MyProVisualPack_L0,MyProDescriptionPack_L0,MyProCloudPack_L1*/{
  
    public static func == (lhs: PropertyModel, rhs: PropertyModel) -> Bool {
        
        lhs.id == rhs.id  &&
        lhs.intestazione == rhs.intestazione &&
        lhs.descrizione == rhs.descrizione
      
    }
    
   
        
    private static func creaID(coordinates:CLLocationCoordinate2D,cityName:String) -> String {
        
        let city = cityName.uppercased()
        let latitude = String(coordinates.latitude).replacingOccurrences(of: ".", with: "A")
        let longitude = String(coordinates.longitude).replacingOccurrences(of: ".", with: "E")
        
        let codID = latitude + city + longitude
        
        return codID

    }
    
    public var id: String
    public var intestazione: String // deve sostituire il nome
    public var descrizione: String
   
    public var cityName: String
    public var coordinates: CLLocationCoordinate2D
    public var webSite: String
    public var phoneNumber: String
    public var streetAdress: String
    public var numeroCivico: String
    
    // MyProCloudPack_L1
    
    public init(frDocID:String,frDoc: [String:Any]) {
        
        self.id = frDocID
        self.intestazione = frDoc[DataBaseField.intestazione] as? String ?? ""
        self.descrizione = frDoc[DataBaseField.descrizione] as? String ?? ""
        self.cityName = frDoc[DataBaseField.cityName] as? String ?? ""
        self.webSite = frDoc[DataBaseField.webSite] as? String ?? ""
        self.phoneNumber = frDoc[DataBaseField.phoneNumber] as? String ?? ""
        self.streetAdress = frDoc[DataBaseField.streetAdress] as? String ?? ""
        self.numeroCivico = frDoc[DataBaseField.numeroCivico] as? String ?? ""
        
        let latitudeString = frDoc[DataBaseField.latitude] as? String ?? ""
        let latitudeDegree = CLLocationDegrees(latitudeString) ?? 0.0
        
        let longitudeString = frDoc[DataBaseField.longitude] as? String ?? ""
        let longitudeDegree = CLLocationDegrees(longitudeString) ?? 0.0
        
        self.coordinates = CLLocationCoordinate2D(latitude: latitudeDegree, longitude: longitudeDegree)
    }
    
    
    
    public struct DataBaseField {
        
        public static let intestazione = "intestazione"
        public static let descrizione = "descrizione"
        public static let cityName = "cityName"
        public static let webSite = "webSite"
        public static let phoneNumber = "phoneNumber"
        public static let streetAdress = "streetAdress"
        public static let numeroCivico = "numeroCivico"
        public static let latitude = "latitudine"
        public static let longitude = "longitudine"
        
    }
            
    public init() { // utile quando creaiamo la @State NewProperty
        
        let coordinates = CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434)

        self.id = Self.creaID(coordinates: coordinates,cityName: "X")
        self.intestazione = ""
        self.descrizione = ""
        self.cityName = ""
        self.coordinates = coordinates
        self.webSite = ""
        self.phoneNumber = ""
        self.streetAdress = ""
        self.numeroCivico = ""
        
    }
    
    public init (intestazione: String, cityName: String, coordinates: CLLocationCoordinate2D, webSite: String, phoneNumber: String, streetAdress: String, numeroCivico: String) {
        
        self.id = Self.creaID(coordinates: coordinates,cityName: cityName)
        self.intestazione = intestazione
        self.descrizione = ""
        self.cityName = cityName
        self.coordinates = coordinates
        self.webSite = webSite
        self.phoneNumber = phoneNumber
        self.streetAdress = streetAdress
        self.numeroCivico = numeroCivico
    
    }
    
    public init(nome: String) {
        
        let coordinates = CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434)

        self.id = Self.creaID(coordinates: coordinates,cityName: "X")
        self.intestazione = nome
        self.descrizione = ""
        self.cityName = ""
        self.coordinates = coordinates
        self.webSite = ""
        self.phoneNumber = ""
        self.streetAdress = ""
        self.numeroCivico = ""
        
    }
    
    public init(nome: String, coordinates: CLLocationCoordinate2D) {
        
        self.id = Self.creaID(coordinates: coordinates,cityName: "X")
        self.intestazione = nome
        self.descrizione = ""
        self.cityName = ""
        self.coordinates = coordinates
        self.webSite = ""
        self.phoneNumber = ""
        self.streetAdress = ""
        self.numeroCivico = ""
        
    }
    
    // Method

  public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
}

