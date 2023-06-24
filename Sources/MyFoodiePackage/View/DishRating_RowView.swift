//
//  SwiftUIView 2.swift
//  
//
//  Created by Calogero Friscia on 08/02/23.
//

import SwiftUI
import MyPackView_L0

public struct DishRating_RowView: View {
    
    let rating: DishRatingModel
    let frameWidth: CGFloat
    let backgroundColorView:Color
    let backgroundOpacity:CGFloat
    // 25.01 cercando un gesto
    @Binding var frames:[CGRect]?
    let coordinateSpace:String?
    
    private let isStickyActive:Bool
    
    public init(
        rating: DishRatingModel,
        frameWidth: CGFloat = 650,
        riduzioneMainBounds:CGFloat = 20,
        backgroundColorView:Color,
        backgroundOpacity:CGFloat = 0.6,
        frames:Binding<[CGRect]?>? = nil,
        coordinateSpace:String? = nil ) {
        
        let screenWidth: CGFloat = UIScreen.main.bounds.width - riduzioneMainBounds
        
        self.rating = rating
        self.frameWidth = .minimum(frameWidth, screenWidth)
        self.backgroundColorView = backgroundColorView
        self.backgroundOpacity = backgroundOpacity
            
        _frames = frames ?? .constant(nil)
        self.coordinateSpace = coordinateSpace
           
        self.isStickyActive = (frames?.wrappedValue != nil) && (coordinateSpace != nil)
        
    }
        
    public var body: some View {
        
        VStack(alignment:.leading,spacing: 0) {
            
            HStack {
                
                Text("\(rating.voto.generale,format: .number)")
                       // .font(.largeTitle)
                    .font(.system(size: frameWidth * 0.12))
                    .fontWeight(.black)

                    .padding(.horizontal,5)
                    .background(
                       // Color.green
                        rating.rateColor()
                            .csCornerRadius(10, corners: [.topLeft])
                            .opacity(0.7)
                            //.cornerRadius(10.0)
                            
                    )
 
                Text(rating.titolo ?? "Nessun Titolo")
                   // .font(.system(.largeTitle, design: .serif, weight: .semibold))
                    .font(.system(size: frameWidth * 0.1,weight: .black,design: .serif))
                  //  .foregroundColor(.seaTurtle_4)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                
                Spacer()
                
            }
            .foregroundColor(.seaTurtle_4)
            .padding(.trailing,5)
            .background {
               Color.seaTurtle_1
                   //.cornerRadius(10)
                   .csCornerRadius(10, corners: [.topRight,.topLeft])
                   .opacity(0.4)
           }
          // .sticky(frames, coordinateSpace: coordinateSpace)
            .csModifier(isStickyActive, transform: { view in
                view.csSticky(frames!, coordinateSpace: coordinateSpace!)
            })
           .padding(.bottom,10)
            
            VStack(alignment:.leading,spacing:10) {
                
                Image(rating.rifImage ?? "TavolaIngredienti")
                   // temporanea
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .background {
                     //   Color.brown
                    }
                

                Text(rating.commento ?? "Nessun Commento")
                    .font(.system(size:frameWidth * 0.05, weight: .light,design: .serif))
                    .foregroundColor(.black)
                    .opacity(0.8)
                   //.multilineTextAlignment(.center)
                    .background {
                       // Color.orange
                    }
            }
          //  .padding(.bottom,10)
            
            VStack(alignment:.center,spacing:10) {
                
                HStack(spacing:4) {
                    
                    Spacer()
                    Text( csTimeFormatter().data.string(from: Date()) )
                    Text( csTimeFormatter().ora.string(from: Date()) )
                    Text("- user anonimo")
                    
                }
                .italic()
                .font(.system(.caption, design: .serif, weight: .ultraLight))
                .foregroundColor(Color.black)
               // .padding(.bottom,5)
                .background {
                   // Color.white
                }

               /* HStack {
                    
                    Text(Image(systemName:"hand.thumbsup"))
                        .font(.system(size: frameWidth * 0.08))
                    Text("1.4k")
                        .bold()
                  
                }
                .padding(.horizontal,10)
                .padding(.vertical,5)
                .background {
                    Color.blue.cornerRadius(15)
                } */ // 30.01 Upgrade Futuro
                
                
            }
            .padding(.horizontal,5)
            .padding(.vertical,10)
         
            
            
        } // chiusa ZStack
        
      //  .padding(.horizontal,10)
        .background(
            backgroundColorView
          //  .cornerRadius(10)
                .csCornerRadius(10, corners: [.topLeft,.topRight])
            .opacity(backgroundOpacity)
           // .shadow(color: .gray, radius: 1, x: 0, y: 1)
        )

    }
}

/*
public struct DishRating_RowView: View {
    
    let rating: DishRatingModel
    let frameWidth: CGFloat
    let backgroundColorView:Color
    let backgroundOpacity:CGFloat
    // 25.01 cercando un gesto
    @Binding var frames:[CGRect]
    let coordinateSpace:String
    
    public init(
        rating: DishRatingModel,
        frameWidth: CGFloat = 650,
        riduzioneMainBounds:CGFloat = 20,
        backgroundColorView:Color,
        backgroundOpacity:CGFloat = 0.6,
        frames:Binding<[CGRect]>,
        coordinateSpace:String ) {
        
        let screenWidth: CGFloat = UIScreen.main.bounds.width - riduzioneMainBounds
        
        self.rating = rating
        self.frameWidth = .minimum(frameWidth, screenWidth)
        self.backgroundColorView = backgroundColorView
        self.backgroundOpacity = backgroundOpacity
        _frames = frames
        self.coordinateSpace = coordinateSpace
    }
    
    public var body: some View {
        
        VStack(alignment:.leading,spacing: 0) {
            
            HStack {
                
                Text("\(rating.voto.generale,format: .number)")
                       // .font(.largeTitle)
                    .font(.system(size: frameWidth * 0.12))
                    .fontWeight(.black)
                   // .foregroundColor(.seaTurtle_4)
                
                    .padding(.horizontal,5)
                    .background(
                       // Color.green
                        rating.rateColor()
                            .csCornerRadius(10, corners: [.topLeft])
                            .opacity(0.7)
                            //.cornerRadius(10.0)
                            
                    )
 
                Text(rating.titolo ?? "Nessun Titolo")
                   // .font(.system(.largeTitle, design: .serif, weight: .semibold))
                    .font(.system(size: frameWidth * 0.1,weight: .black,design: .serif))
                  //  .foregroundColor(.seaTurtle_4)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                
                Spacer()
                
            }
            .foregroundColor(.seaTurtle_4)
            .padding(.trailing,5)
            .background {
               Color.seaTurtle_1
                   //.cornerRadius(10)
                   .csCornerRadius(10, corners: [.topRight,.topLeft])
                   .opacity(0.4)
           }
           .sticky(frames, coordinateSpace: coordinateSpace)
           .padding(.bottom,10)
            
            VStack(alignment:.leading,spacing:10) {
                
                Image(rating.rifImage ?? "Nessuna Image")
                   
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .background {
                     //   Color.brown
                    }
                

                Text(rating.commento ?? "Nessun Commento")
                    .font(.system(size:frameWidth * 0.05, weight: .light,design: .serif))
                    .foregroundColor(.black)
                    .opacity(0.8)
                   //.multilineTextAlignment(.center)
                    .background {
                       // Color.orange
                    }
            }
          //  .padding(.bottom,10)
            
            VStack(alignment:.center,spacing:10) {
                
                HStack(spacing:4) {
                    
                    Spacer()
                    Text( csTimeFormatter().data.string(from: Date()) )
                    Text( csTimeFormatter().ora.string(from: Date()) )
                    Text("- user anonimo")
                    
                }
                .italic()
                .font(.system(.caption, design: .serif, weight: .ultraLight))
                .foregroundColor(Color.black)
               // .padding(.bottom,5)
                .background {
                   // Color.white
                }

               /* HStack {
                    
                    Text(Image(systemName:"hand.thumbsup"))
                        .font(.system(size: frameWidth * 0.08))
                    Text("1.4k")
                        .bold()
                  
                }
                .padding(.horizontal,10)
                .padding(.vertical,5)
                .background {
                    Color.blue.cornerRadius(15)
                } */ // 30.01 Upgrade Futuro
                
                
            }
            .padding(.horizontal,5)
            .padding(.vertical,10)
         
            
            
        } // chiusa ZStack
        
      //  .padding(.horizontal,10)
        .background(
            backgroundColorView
          //  .cornerRadius(10)
                .csCornerRadius(10, corners: [.topLeft,.topRight])
            .opacity(backgroundOpacity)
           // .shadow(color: .gray, radius: 1, x: 0, y: 1)
        )

    }
} */ // backup 20.02
