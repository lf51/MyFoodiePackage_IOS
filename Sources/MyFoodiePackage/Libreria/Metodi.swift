//
//  File.swift
//  
//
//  Created by Calogero Friscia on 10/12/22.
//

import Foundation
import SwiftUI

/// trasferisci i valori da un fileJson ad un Oggetto
public func csLoad<T:Decodable>(_ filename:String) -> T {
    
    let data:Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {fatalError("Non è possibile trovare \(filename) in the main bundle") }
    
    do {
        data = try Data(contentsOf: file)
    } catch {fatalError("Non è possibile caricare il file \(filename)") }
    
    do { let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {fatalError("Impossibile eseguire il PARSE sul file \(filename) as \(T.self):\n\(error)") }
    
}

public func csTimeFormatter() -> (ora:DateFormatter,data:DateFormatter) {
    // !! Nota Vocale 20.09 AMPM !!
    let time = DateFormatter()
    time.timeStyle = .short
   // time.dateFormat = "HH:mm"
   // time.timeZone = .current
  //  time.timeZone = .gmt

    let date = DateFormatter()
   /* date.weekdaySymbols = ["Lun","Mar","Mer","Gio","Ven","Sab","Dom"]*/
   /* date.monthSymbols = ["Gen","Feb","Mar","Apr","Mag","Giu","Lug","Ago","Set","Ott","Nov","Dic"] */
    date.dateStyle = .long
    date.dateFormat = "dd MMMM yyyy"
 //   date.timeZone = .autoupdatingCurrent
 //   date.weekdaySymbols = ["Lun","Mar"]
    return (time,date)
    
}

/// estrapola l'ora da una data e la trasforma in un numero Assoluto (è il numero di minuti totale) utile per un confronto fra orari
public func csTimeConversione(data:Date) -> Int {
    
    let calendario = Calendar(identifier: .gregorian)
    
    let componentiData = calendario.dateComponents([.hour,.minute], from: data)
    let valoreAssoluto = (componentiData.hour! * 60) + componentiData.minute!
    return valoreAssoluto
}

/// converte un numero intero di minuti in una data ora/minuti
public func csTimeReverse(value:Int) -> Date {
    
    let minute = value % 60
    let hour = (value - minute) / 60
    
    let calendario = Calendar(identifier: .gregorian)
    let timeComponent = DateComponents(hour: hour, minute: minute)
    let reversingDate = calendario.date(from: timeComponent) ?? Date.now
    
    return reversingDate
}

/// Nasconde la Keyboard
public func csHideKeyboard(){
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

public func csCleanAndOrderArray<T:MyProOrganizerPack_L0>(array:[T]) -> [T] {
    
    // T passa da MYEnumProtocolMapConform a MyProOrganizerPack
    
    // Modifiche 27.09
  //  var arrayCentrifugato:[T] = []
    
   /* for eachCase in array {
        
        let element:T = eachCase.returnTypeCase()
        arrayCentrifugato.append(element)
        
    } */
    let arrayCentrifugato:[T] = array.map({$0.returnTypeCase()})
 
    // end Mod 27.09
    
    let secondStep = Array(Set(arrayCentrifugato))
    let lastStep = secondStep.sorted{$0.orderAndStorageValue() < $1.orderAndStorageValue()}
    
   return lastStep
}

/// 06.02.23 In questo ultimo update lo string cleaner pulisce i punti a capo a inizio e fine testo. Quelli nel mezzo li lascia.
public func csStringCleaner(string:String) -> String {
    
   // let firstStep = eliminaPuntoACapo ? string.replacingOccurrences(of: "\n", with: "") : string
    
    let firstStep:String = {
       
        var local = string
        
        while local.hasPrefix("\n") {
            local.removeFirst()
        }
        
        while local.hasSuffix("\n") {
            local.removeLast()
        }
        
        return local
    }()
    
    let subStringaTesto = firstStep.split(separator: " ")
    let newStringaTesto: String = {
        
        var newString:String = ""
        for sub in subStringaTesto {
            
            newString = newString == "" ? String(sub) : (newString + " " + sub)
            
        }
        
        return newString
        
    }()

    return newStringaTesto
    
}

/// ritorna il valore della media Pesata di un array di Recensioni
public func csCalcoloMediaRecensioni(elementi:[DishRatingModel]) -> Double {
    
    let votiEPesi = elementi.map({ ($0.voto.generale,$0.pesoRecensione()) })
       
        var sommaVoti: Double = 0.0
        var sommaPesi: Double = 0.0
        
        for (v,p) in votiEPesi {
            
            let votoPesato = v * p
            
            sommaVoti += votoPesato
            sommaPesi += p
        }
        
        return sommaVoti / sommaPesi

}
