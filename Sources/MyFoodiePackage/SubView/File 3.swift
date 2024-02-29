//
//  File 3.swift
//  
//
//  Created by Calogero Friscia on 30/01/23.
//

import Foundation
import SwiftUI

//import MyPackView_L0
//import MyViewPack
/*
public struct BoxDescriptionModel_Generic<M:MyProDescriptionPack_L0>: View {
    // 15.09 passa da MyProModelPack a MyProToolPack
    
    @Binding var itemModel:M
    let labelString: String
    let disabledCondition: Bool
    var backgroundColor: Color = Color.black
    @State private var wannaAddDescription: Bool? = false
    
    public init(
        itemModel: Binding<M>,
        labelString: String,
        disabledCondition: Bool,
        backgroundColor: Color = Color.black) {
        _itemModel = itemModel
        self.labelString = labelString
        self.disabledCondition = disabledCondition
        self.backgroundColor = backgroundColor
   
    }
    
    public var body: some View {
        
        VStack(alignment:.leading) {
            
            CSLabel_1Button(
                placeHolder: labelString,
                imageNameOrEmojy: "scribble",
                backgroundColor: backgroundColor,
                disabledCondition: disabledCondition,
                toggleBottone: $wannaAddDescription)
                                    
            if wannaAddDescription ?? false {

               CSTextField_ExpandingBox(itemModel: $itemModel, dismissButton: $wannaAddDescription, maxDescriptionLenght: 150)
              
                                            
            } else {
                
                Text(itemModel.descrizione == "" ? "Nessuna descrizione inserita. Press [+] " : itemModel.descrizione)
                    .italic()
                    .fontWeight(.light)
            }
            
        }
        
    }
    
}

public struct CSTextField_ExpandingBox<M:MyProDescriptionPack_L0>: View {
   
   @EnvironmentObject var viewModel: FoodieViewModel
   @Binding var itemModel: M
   @Binding var dismissButton: Bool?
   var maxDescriptionLenght: Int
   
   @State private var description: String = ""
   
   @State private var isEditorActive: Bool = false
   @State private var isTextChanged: Bool = false
  
  public init(
    itemModel: Binding<M>,
    dismissButton: Binding<Bool?>,
    maxDescriptionLenght: Int = 300) {
       
       _itemModel = itemModel
       _dismissButton = dismissButton
       let newDescription = itemModel.descrizione.wrappedValue
       _description = State(wrappedValue: newDescription)
       self.maxDescriptionLenght = maxDescriptionLenght
   }

  public var body: some View {
  
           VStack {
                        
               TextField("[+] Inserire una descrizione", text: $description, axis: .vertical)
                   .font(.system(.body,design:.rounded))
                   .foregroundColor(isEditorActive ? Color.white : Color.black)
                   .autocapitalization(.sentences)
                   .disableAutocorrection(true)
                   .keyboardType(.default)
                   .lineLimit(0...5)
                   .padding()
                   .background(Color.white.opacity(isEditorActive ? 0.2 : 0.05))
                   .cornerRadius(5.0)
                   .overlay(alignment: .trailing) {
                       CSButton_image(frontImage: "x.circle.fill", imageScale: .medium, frontColor: Color.white) { cancelAction() }
                       .opacity(description == "" ? 0.6 : 1.0)
                       .disabled(description == "")
                       .padding(.trailing)
                   }
                   .onTapGesture {
                       
                       withAnimation {
                           isEditorActive = true
                       }
                       
                   }
                   .onChange(of: description) { newValue in
                       
                       if newValue != itemModel.descrizione {
                           isTextChanged = true }
                       else { isTextChanged = false}
                       }
               
               if isEditorActive {
                       
                       HStack {
                               CSButton_tight(
                                   title: "Undo",
                                   fontWeight: .heavy,
                                   titleColor: .red,
                                   fillColor: .clear) {
                                       
                                       withAnimation {
                                           self.description = itemModel.descrizione
                                       }
                                   }
                         
                           Spacer()
                           
                           HStack(spacing:0) {
                               
                               Text("\(description.count)")
                                   .fontWeight(.semibold)
                                   .foregroundColor(description.count <= maxDescriptionLenght ? Color.blue : Color.red)
                               Text("/\(maxDescriptionLenght)")
                                   .fontWeight(.light)
                               
                           }
                           
                           CSButton_tight(
                               title: "Salva",
                               fontWeight: .heavy,
                               titleColor: .green,
                               fillColor: .clear) {

                                   self.saveAction()
                                  /* self.isEditorActive = false
                                   csHideKeyboard()
                                   self.itemModel.descrizione = description */
                                 //  self.dismissButton.toggle()
                                   
                               }
                       }
                       .opacity(isTextChanged ? 1.0 : 0.6)
                       .disabled(!isTextChanged)
                   
                   }

               }
         
       }
   
   // Method
   
  /* private func saveText() {
       
       self.isEditorActive = false
       csHideKeyboard()

       viewModel.updateItemModel(messaggio: "Test") { () -> M in
           
           var varianteProperty = itemModel
           varianteProperty.descrizione = description
           return varianteProperty
       }
  
   } */ // Salvataggio spostato nella View MAdre in data 27.06
   
   private func saveAction() {
       
       self.isEditorActive = false
       csHideKeyboard()
       // 22.08
       let newDescription = csStringCleaner(string: description)
       self.itemModel.descrizione = newDescription
       self.dismissButton = false
       //
      // self.itemModel.descrizione = description
      
   }
   
   private func cancelAction() {
       
    //   csHideKeyboard()
       
       withAnimation {
        //   self.isEditorActive = false
         //  self.showPlaceHolder = itemModel.descrizione == ""
         //  self.description = itemModel.descrizione
           self.description = ""
       
       }
       
   }
   
} */


// RIPORTA IN DATA 17.02.23 nella business.



/*
public struct CSTextField_ExpandingBox<M:MyProDescriptionPack_L0>: View {
   
   @EnvironmentObject var viewModel: FoodieViewModel
   @Binding var itemModel: M
   @Binding var dismissButton: Bool?
   var maxDescriptionLenght: Int
   
   @State private var description: String = ""
   
   @State private var isEditorActive: Bool = false
   @State private var isTextChanged: Bool = false
  
  public init(
    itemModel: Binding<M>,
    dismissButton: Binding<Bool?>,
    maxDescriptionLenght: Int = 300) {
       
       _itemModel = itemModel
       _dismissButton = dismissButton
       let newDescription = itemModel.descrizione.wrappedValue
       _description = State(wrappedValue: newDescription)
       self.maxDescriptionLenght = maxDescriptionLenght
   }
   
  public var body: some View {
  
           VStack {
                        
               TextField("[+] Inserire una descrizione", text: $description, axis: .vertical)
                   .font(.system(.body,design:.rounded))
                   .foregroundColor(isEditorActive ? Color.white : Color.black)
                   .autocapitalization(.sentences)
                   .disableAutocorrection(true)
                   .keyboardType(.default)
                   .lineLimit(0...5)
                   .padding()
                   .background(Color.white.opacity(isEditorActive ? 0.2 : 0.05))
                   .cornerRadius(5.0)
                   .overlay(alignment: .trailing) {
                       CSButton_image(frontImage: "x.circle.fill", imageScale: .medium, frontColor: Color.white) { cancelAction() }
                       .opacity(description == "" ? 0.6 : 1.0)
                       .disabled(description == "")
                       .padding(.trailing)
                   }
                   .onTapGesture {
                       
                       withAnimation {
                           isEditorActive = true
                       }
                       
                   }
                   .onChange(of: description) { newValue in
                       
                       if newValue != itemModel.descrizione {
                           isTextChanged = true }
                       else { isTextChanged = false}
                       }
               
               if isEditorActive {
                       
                       HStack {
                               CSButton_tight(
                                   title: "Undo",
                                   fontWeight: .heavy,
                                   titleColor: .red,
                                   fillColor: .clear) {
                                       
                                       withAnimation {
                                           self.description = itemModel.descrizione
                                       }
                                   }
                         
                           Spacer()
                           
                           HStack(spacing:0) {
                               
                               Text("\(description.count)")
                                   .fontWeight(.semibold)
                                   .foregroundColor(description.count <= maxDescriptionLenght ? Color.blue : Color.red)
                               Text("/\(maxDescriptionLenght)")
                                   .fontWeight(.light)
                               
                           }
                           
                           CSButton_tight(
                               title: "Salva",
                               fontWeight: .heavy,
                               titleColor: .green,
                               fillColor: .clear) {

                                   self.saveAction()
                                  /* self.isEditorActive = false
                                   csHideKeyboard()
                                   self.itemModel.descrizione = description */
                                 //  self.dismissButton.toggle()
                                   
                               }
                       }
                       .opacity(isTextChanged ? 1.0 : 0.6)
                       .disabled(!isTextChanged)
                   
                   }

               }
       }
   
   // Method
   
  /* private func saveText() {
       
       self.isEditorActive = false
       csHideKeyboard()

       viewModel.updateItemModel(messaggio: "Test") { () -> M in
           
           var varianteProperty = itemModel
           varianteProperty.descrizione = description
           return varianteProperty
       }
  
   } */ // Salvataggio spostato nella View MAdre in data 27.06
   
   private func saveAction() {
       
       self.isEditorActive = false
       csHideKeyboard()
       // 22.08
       let newDescription = csStringCleaner(string: description)
       self.itemModel.descrizione = newDescription
       self.dismissButton = false
       //
      // self.itemModel.descrizione = description
      
   }
   
   private func cancelAction() {
       
    //   csHideKeyboard()
       
       withAnimation {
        //   self.isEditorActive = false
         //  self.showPlaceHolder = itemModel.descrizione == ""
         //  self.description = itemModel.descrizione
           self.description = ""
       
       }
       
   }
   
} */ // 17.02.23 backup
