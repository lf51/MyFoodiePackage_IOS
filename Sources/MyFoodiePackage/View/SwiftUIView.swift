//
//  SwiftUIView.swift
//  
//
//  Created by Calogero Friscia on 05/01/23.
//

import SwiftUI
import MyPackView_L0

struct SwiftUIView: View {
    
    var body: some View {
        
       // CSZStackVB_OpenFrame {
            
            VStack(alignment: .leading,spacing: 5) {
                
                vbTesto()
              //  Text("Ola")
            }
     //   }
       
        
        }
    
    
    @ViewBuilder private func vbTesto() -> some View {
        
        let string:[String] = ["Latte & derivati","Lupini","Sedano","Uova e derivati","glutine","ferro","acciaio","chi più ne ha più ne metta","qualcosa sicuro","anche meno","troppo","scarto","da elabprare meglio","non is capisce","Latte & derivati","Lupini","Sedano","Uova e derivati","glutine","ferro","acciaio","chi più ne ha più ne metta","qualcosa sicuro","anche meno","troppo","scarto","da elabprare meglio","non is capisce","Latte & derivati","Lupini","Sedano","Uova e derivati","glutine","ferro","acciaio","chi più ne ha più ne metta","qualcosa sicuro","anche meno","troppo","scarto","da elabprare meglio","non is capisce","Latte & derivati","Lupini","Sedano","Uova e derivati","glutine","ferro","acciaio","chi più ne ha più ne metta","qualcosa sicuro","anche meno","troppo","scarto","da elabprare meglio","non is capisce","Latte & derivati","Lupini","Sedano","Uova e derivati","glutine","ferro","acciaio","chi più ne ha più ne metta","qualcosa sicuro","anche meno","troppo","scarto","da elabprare meglio","non is capisce","Latte & derivati","Lupini","Sedano","Uova e derivati","glutine","ferro","acciaio","chi più ne ha più ne metta","qualcosa sicuro","anche meno","troppo","scarto","da elabprare meglio","non is capisce","Latte & derivati","Lupini","Sedano","Uova e derivati","glutine","ferro","acciaio","chi più ne ha più ne metta","qualcosa sicuro","anche meno","troppo","scarto","da elabprare meglio","non is capisce","Latte & derivati","Lupini","Sedano","Uova e derivati","glutine","ferro","acciaio","chi più ne ha più ne metta","qualcosa sicuro","anche meno","troppo","scarto","da elabprare meglio","non is capisce","Latte & derivati","Lupini","Sedano","Uova e derivati","glutine","ferro","acciaio","chi più ne ha più ne metta","qualcosa sicuro","anche meno","troppo","scarto","da elabprare meglio","non is capisce",]
        
        let texts = string.map({toTextFrom(string: $0)})
        
        combinaTesto(text: texts, coloreSeparatore: .white) {
            Text("*")
                .foregroundColor(Color.white)
            +
            Text("Contiene:")
                .bold()
                .font(.caption2)
        }//.multilineTextAlignment(.trailing)
        .lineSpacing(-10)
        
        
        
    }
    
    private func toTextFrom(string:String) -> Text {
        
        Text(string)
            .italic()
            .fontWeight(.semibold)
            .font(.caption2)
            .foregroundColor(Color.black.opacity(0.8))
        
    }
    
   private func combinaTesto(text:[Text],coloreSeparatore:Color,initialText: () ->Text) -> Text {
        
       let iniziale = initialText()
        
      return text.reduce(iniziale) { partialResult, testo in
           
          partialResult
          +
          Text(partialResult == iniziale ? " " : ", ")
              .foregroundColor(coloreSeparatore)
          +
          testo
       }
        
        
    }
    
}

struct SwiftUIView_Previews: PreviewProvider {
    
    static var previews: some View {
       
        CSZStackVB(title: "Test", backgroundColorView: .seaTurtle_1) {
            
            VStack {
                
                ScrollView {
                    
                    SwiftUIView()
                    SwiftUIView()
                    SwiftUIView()
                    SwiftUIView()
                    SwiftUIView()
                    SwiftUIView()
                    SwiftUIView()
                    SwiftUIView()
                    SwiftUIView()
                    SwiftUIView()
                    
                }
                
            }
        }
        
        
    }
}
