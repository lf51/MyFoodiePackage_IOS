//
//  SwiftUIView.swift
//  
//
//  Created by Calogero Friscia on 23/02/23.
//

import SwiftUI

public struct MapLabel_MenuVistaCliente: View {
    
    let label:String
    let image:String
    let rowBoundReduction:CGFloat //
    let textSizeAsScreenPercentage:Double //
    let rowColor:Color
    let textColor:Color
    let shadowColor:Color //
    let rowOpacity:Double
        
    private let csWidth:CGFloat
    private let csHeight:CGFloat
    private let size:CGFloat
    
    public init(
        label:String,
        imageName:String,
        rowBoundReduction: CGFloat,
        textSizeAsScreenPercentage:Double,
        rowColor: Color,
        textColor: Color,
        shadowColor: Color,
        rowOpacity: Double) {
            
        self.label = label
        self.image = imageName
        self.rowBoundReduction = rowBoundReduction
        self.textSizeAsScreenPercentage = textSizeAsScreenPercentage
        self.rowColor = rowColor
        self.textColor = textColor
        self.shadowColor = shadowColor
        self.rowOpacity = rowOpacity
                        
        let screenWidth:CGFloat = UIScreen.main.bounds.width - rowBoundReduction
        self.csWidth = screenWidth
        self.csHeight = screenWidth * 0.4//(9/16) //0.45
        self.size = screenWidth * textSizeAsScreenPercentage
    }
    
  public var body: some View {
      
          ZStack(alignment:.bottomTrailing) {
              
              Image("VSample",bundle: .main)
                  .resizable()
                  .scaledToFill()
                  .opacity(0.9)
                  .frame(width:csWidth , height: csHeight)
                  .clipped()
                  .cornerRadius(10)
                  .zIndex(0)
            
              Label {
                  Text(label)
                      .font(.system(size: size, weight: .semibold, design: .default))
                    
                      .foregroundColor(textColor)
                   
              } icon: {
                  Text(image)
                      .font(.system(size: size))
              }
              .padding(.trailing,15)
              .padding([.leading,.vertical],5)
            //  .padding(5)
              .background {
                  rowColor
                      .csCornerRadius(5.0, corners: [.topLeft,.bottomLeft])
                      .opacity(rowOpacity)
              }
              .offset(y: -(csHeight * 0.05))
              .zIndex(1)

          }
          
          //.frame(width:csWidth)
        // .frame(width:csWidth , height: csHeight)
       //  .clipped()
       //  .cornerRadius(10)
         //.frame(height:csHeight)
        // .background(Color.black)
          
     
          
          
      


    }
}
