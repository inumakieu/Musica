//
//  FillAspectImage.swift
//  Saikou Beta
//
//  Created by Inumaki on 12.02.23.
//

import SwiftUI

public struct FillAspectImage: View {
    let image: String
    
    @State private var finishedLoading: Bool = false
    @State private var imageWidth: CGFloat = 0
    @State private var offset: CGFloat = 0
    @State private var animLeft: Bool = false
    
    public init(image: String) {
        self.image = image
    }
    
    public var body: some View {
        GeometryReader { proxy in
            Image(image)
                .resizable()
                .scaledToFill()
                .transition(.opacity)
                .opacity(1.0)
                .background(Color(white: 0.05))
                .frame(
                    width: proxy.size.width,
                    height: proxy.size.height,
                    alignment: .center
                )
                .contentShape(Rectangle())
                .clipped()
                .animation(.easeInOut(duration: 0.5), value: finishedLoading)
                
        }
    }
}

struct FillAspectImage_Previews: PreviewProvider {
    static var previews: some View {
        FillAspectImage(image: "cover")
    }
}
