//
//  Home.swift
//  AppleMusic
//
//  Created by Inumaki on 14.03.23.
//

import SwiftUI

struct Home: View {
    
    let titles: [String] = [
        "they dont give a fuck",
        "chill morning",
        "hollow",
        "find!",
        "when i go to sleep",
        "obsession",
        "baby girl",
        "pills"
    ]
    
    let downloaded: [Bool] = [
        false,
        false,
        false,
        true,
        false,
        true,
        true,
        false
    ]
    
    let favourite: [Bool] = [
        true,
        false,
        false,
        true,
        false,
        false,
        false,
        false
    ]
    
    @State var showPlayer: Bool = false
    @Namespace var animation
    @StateObject var audioViewModel: AudioViewModel = AudioViewModel()
    @State var audioPlaying: Bool = false
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        GeometryReader {reader in
                            ZStack {
                                FillAspectImage(image: "timmies")
                                    .frame(
                                        width: reader.size.width,
                                        height: reader.size.height + (reader.frame(in: .global).minY > 0 ? reader.frame(in: .global).minY : 0),
                                        alignment: .center
                                    )
                                    .contentShape(Rectangle())
                                    .clipped()
                                    .offset(y: reader.frame(in: .global).minY <= 0 ? 0 : -reader.frame(in: .global).minY)
                                
                                VStack {
                                    HStack(spacing: 20) {
                                        Image(systemName: "chevron.left")
                                        
                                        Image(systemName: "info.circle")
                                        
                                        Spacer()
                                        
                                        Image(systemName: "plus")
                                        
                                        Image(systemName: "ellipsis")
                                    }
                                    
                                    Spacer()
                                    
                                    HStack {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Lofi • 2019")
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                            
                                            HStack(spacing: 20) {
                                                Image(systemName: "sparkles")
                                                Image(systemName: "waveform")
                                            }
                                        }
                                        Spacer()
                                        Image(systemName: "shuffle")
                                            .font(.title2)
                                            .padding(12)
                                            .background {
                                                Circle()
                                                    .fill(Color("accentColor"))
                                            }
                                        Image(systemName: "play")
                                            .font(.title2)
                                            .padding(14)
                                            .background {
                                                Circle()
                                                    .fill(Color("accentColor"))
                                            }
                                    }
                                }
                                .padding(20)
                                .padding(.top, 50)
                                .foregroundColor(.white)
                                .frame(
                                    width: reader.size.width,
                                    height: reader.size.height + (reader.frame(in: .global).minY > 0 ? reader.frame(in: .global).minY : 0),
                                    alignment: .center
                                )
                                .contentShape(Rectangle())
                                .clipped()
                                .offset(y: reader.frame(in: .global).minY <= 0 ? 0 : -reader.frame(in: .global).minY)
                            }
                        }
                        .frame(height: proxy.size.width)
                        
                        VStack {
                            ForEach(0..<8) {index in
                                HStack {
                                    Text("\(index + 1)")
                                        .foregroundColor(Color("accentColor"))
                                    
                                    Text(titles[index])
                                        .font(.callout)
                                        .fontWeight(.medium)
                                    
                                    Spacer()
                                    
                                    if favourite[index] {
                                        Image(systemName: "heart.fill")
                                            .foregroundColor(Color("accentColor"))
                                    }
                                    
                                    if downloaded[index] {
                                        Image(systemName: "arrow.down.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Image(systemName: "ellipsis")
                                }
                                .padding(.vertical, 8)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 160)
                    }
                }
                .ignoresSafeArea()
                .frame(maxWidth: proxy.size.width, maxHeight: proxy.size.height)
                .overlay {
                    VStack {
                        Spacer()
                        
                        HStack(spacing: 12) {
                            Image("liability")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 48, maxHeight: 48)
                                .cornerRadius(8)
                                .matchedGeometryEffect(id: "cover", in: animation)
                            
                            VStack(alignment: .leading) {
                                Text("Liability")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                Text("Lorde")
                                    .font(.callout)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("accentColor"))
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                if(audioViewModel.audioPlayer.isPlaying) {
                                    audioViewModel.audioPlayer.pause()
                                    audioPlaying = false
                                } else {
                                    audioViewModel.audioPlayer.play()
                                    audioPlaying = true
                                }
                            }, label: {
                                Image(systemName: audioPlaying ? "pause.fill" : "play.fill")
                                    .foregroundColor(.black)
                                    .font(.title3)
                            })
                            
                            Image(systemName: "forward.fill")
                                .font(.title3)
                                .padding(.trailing, 8)
                        }
                        .padding(12)
                        .fixedSize(horizontal: false, vertical: true)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white)
                                .matchedGeometryEffect(id: "bg", in: animation)
                        }
                        .onTapGesture {
                            print("show player")
                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                showPlayer = true
                            }
                        }
                        .shadow(color: .gray.opacity(0.4),radius: 20)
                        .padding(.horizontal, 12)
                        .padding(.bottom, 50)
                    }
                }
                .overlay {
                    if showPlayer {
                        ZStack(alignment: .top) {
                            Player(animation: animation, audioViewModel: audioViewModel)
                                .padding(.top, 50)
                                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                    .onEnded({ value in
                                        if value.translation.width < 0 {
                                            // left
                                        }
                                        
                                        if value.translation.width > 0 {
                                            // right
                                        }
                                        if value.translation.height < 0 {
                                            // up
                                        }
                                        
                                        if value.translation.height > 0 {
                                            // down
                                            audioPlaying = audioViewModel.audioPlayer.isPlaying
                                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.7)) {
                                                showPlayer = false
                                            }
                                        }
                                    }))
                            
                            RoundedRectangle(cornerRadius: 6)
                                .fill(.gray)
                                .frame(maxWidth: 40, maxHeight: 4)
                                .padding(.top, 68)
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 0)
                                .fill(.white)
                                .matchedGeometryEffect(id: "bg", in: animation)
                        }
                        .ignoresSafeArea()
                    }
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
