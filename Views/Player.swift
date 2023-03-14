//
//  Player.swift
//  AppleMusic
//
//  Created by Inumaki on 14.03.23.
//

import SwiftUI
import Subsonic

struct MusicProgressView: View {
    
    @Binding var percentage: Double // or some value binded
    @Binding var isDragging: Bool
    var total: Double
    @Binding var isMacos: Bool
    @State var barHeight: CGFloat = 6
    
    
    var body: some View {
        GeometryReader { geometry in
            // TODO: - there might be a need for horizontal and vertical alignments
            ZStack(alignment: .bottomLeading) {
                
                Rectangle()
                    .foregroundColor(.gray.opacity(0.3)).frame(height: barHeight, alignment: .bottom).cornerRadius(12)
                    .gesture(DragGesture(minimumDistance: 0)
                        .onEnded({ value in
                            self.percentage = min(max(0, Double(value.location.x / geometry.size.width * total)), total)
                            self.isDragging = false
                            self.barHeight = isMacos ? 12 : 6
                        })
                            .onChanged({ value in
                                self.isDragging = true
                                self.barHeight = isMacos ? 18 : 10
                                print(value)
                                // TODO: - maybe use other logic here
                                self.percentage = min(max(0, Double(value.location.x / geometry.size.width * total)), total)
                            })).animation(.spring(response: 0.3), value: self.isDragging)
                Rectangle()
                    .foregroundColor(Color("accentColor"))
                    .frame(width: geometry.size.width * CGFloat(self.percentage / total)).frame(height: barHeight, alignment: .bottom).cornerRadius(12)
                
                
            }.frame(maxHeight: .infinity, alignment: .center)
                .cornerRadius(12)
                .gesture(DragGesture(minimumDistance: 0)
                    .onEnded({ value in
                        self.percentage = min(max(0, Double(value.location.x / geometry.size.width * total)), total)
                        self.isDragging = false
                        self.barHeight = isMacos ? 12 : 6
                    })
                        .onChanged({ value in
                            self.isDragging = true
                            self.barHeight = isMacos ? 18 : 10
                            print(value)
                            // TODO: - maybe use other logic here
                            self.percentage = min(max(0, Double(value.location.x / geometry.size.width * total)), total)
                        })).animation(.spring(response: 0.3), value: self.isDragging)
            
        }
    }
}

struct CustomBlurView: UIViewRepresentable {
    var effect: UIBlurEffect.Style
    var onChange: (UIVisualEffectView)->()
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: effect))
        return view
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        DispatchQueue.main.async {
            onChange(uiView)
        }
    }
}

func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int) {
    return ((seconds % 3600) / 60, (seconds % 3600) % 60)
}

func printSecondsToHoursMinutesSeconds(_ seconds: Int) -> String {
  let (m, s) = secondsToHoursMinutesSeconds(seconds)
    return "\(m):\(s < 10 ? "0" : "")\(s)"
}

struct Player: View {
    let animation: Namespace.ID
    @StateObject var audioViewModel: AudioViewModel
    @StateObject var viewModel: PlayerViewModel = PlayerViewModel()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader {proxy in
            VStack {
                ZStack {
                    Image("liability")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .mask(LinearGradient(gradient: Gradient(colors: [.white, .clear]), startPoint: .bottom, endPoint: .top))
                        .cornerRadius(30)
                        .blur(radius: 24)
                        .opacity(viewModel.viewShown ? 0.4 : 0.0)
                        .animation(.spring(response: 0.5), value: viewModel.viewShown)
                        
                    
                    Image("liability")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(30)
                        .padding(.horizontal, 40)
                        .matchedGeometryEffect(id: "cover", in: animation)
                    
                    VStack {
                        Spacer()
                        
                        HStack {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 18))
                                .foregroundColor(Color("accentColor"))
                                .padding(12)
                                .background {
                                    Circle()
                                        .fill(.white)
                                }
                                .onTapGesture {
                                    viewModel.lovedSong.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        viewModel.lovedSong = false
                                    }
                                }
                                .opacity(viewModel.viewShown ? 1.0 : 0.0)
                                .animation(.spring(response: 0.5), value: viewModel.viewShown)
                            
                            Spacer()
                            
                            Image(systemName: "ellipsis")
                                    .font(.title3)
                                    .foregroundColor(Color("accentColor"))
                                    .padding(18)
                            .frame(maxWidth: 46, maxHeight: 46)
                            .background {
                                CustomBlurView(effect: .systemMaterial, onChange: {view in
                                    
                                })
                                .cornerRadius(60)
                            }
                            .opacity(viewModel.viewShown ? 1.0 : 0.0)
                            .animation(.spring(response: 0.5), value: viewModel.viewShown)
                        }
                    }
                    .padding(48)
                }
                .frame(maxWidth: proxy.size.width, maxHeight: proxy.size.width)
                
                VStack {
                    Text("Liability")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Lorde")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(Color("accentColor"))
                    
                    
                    VStack {
                        Image("dolbyAtmosFull")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 50)
                            .foregroundColor(.gray)
                            .padding(.bottom, -20)
                        MusicProgressView(percentage: $audioViewModel.audioPlayer.currentTime, isDragging: $viewModel.seekingAudio, total: audioViewModel.audioPlayer.duration, isMacos: .constant(false))
                            .frame(maxHeight: 32)
                        HStack {
                            Text("\(printSecondsToHoursMinutesSeconds(viewModel.currentTime))")
                                .font(.caption)
                                .foregroundColor(.black.opacity(0.7))
                            
                            Spacer()
                            
                            
                            Text("-\(printSecondsToHoursMinutesSeconds(Int(audioViewModel.audioPlayer.duration) - viewModel.currentTime))")
                                .font(.caption)
                                .foregroundColor(.black.opacity(0.7))
                        }
                        .padding(.horizontal, 8)
                        .padding(.top, -8)
                    }
                    .padding(.top, 40)
                    
                    HStack(spacing: 40) {
                        Button(action: {
                            print("previous song")
                        }, label: {
                            Image(systemName: "backward.fill")
                                .foregroundColor(.black)
                                .font(.system(size: 32))
                        })
                        
                        Button(action: {
                            if(audioViewModel.audioPlayer.isPlaying) {
                                audioViewModel.audioPlayer.pause()
                                viewModel.audioPlaying = false
                            } else {
                                audioViewModel.audioPlayer.play()
                                viewModel.audioPlaying = true
                            }
                        }, label: {
                            Image(systemName: viewModel.audioPlaying ? "pause.fill" : "play.fill")
                                .foregroundColor(.black)
                                .font(.system(size: 40))
                        })
                        
                        Button(action: {
                            print("previous song")
                        }, label: {
                            Image(systemName: "forward.fill")
                                .foregroundColor(.black)
                                .font(.system(size: 32))
                        })
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                    
                    HStack(spacing: 20) {
                        Image(systemName: "volume.1.fill")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Slider(value: $audioViewModel.audioPlayer.volume)
                            .tint(Color("accentColor"))
                        
                        Image(systemName: "volume.3.fill")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, -12)
            }
            // MARK: Loved PopUp
            .overlay(alignment: .top) {
                HStack(spacing: 32) {
                    Image("liability")
                        .resizable()
                        .frame(maxWidth: 40, maxHeight: 40)
                        .cornerRadius(8)
                    
                    VStack {
                        Text("Liability")
                            .font(.callout)
                            .fontWeight(.semibold)
                        
                        Text("Loved")
                            .font(.caption)
                            .fontWeight(.regular)
                            .foregroundColor(Color("accentColor"))
                    }
                    
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color("accentColor"))
                        .padding(.trailing, 6)
                }
                .padding(12)
                .background {
                    CustomBlurView(effect: .systemMaterial, onChange: {view in
                        
                    })
                    .cornerRadius(20)
                    .opacity(0.98)
                }
                .shadow(color: .gray.opacity(0.4),radius: 20, y:6)
                .zIndex(100)
                .opacity(viewModel.lovedSong ? 1.0 : 0.0)
                .offset(y: viewModel.lovedSong ? 0 : -72)
                .scaleEffect(viewModel.lovedSong ? 1.0 : 0.0)
                .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.3), value: viewModel.lovedSong)
                
            }
        }
        .onAppear {
            viewModel.audioPlaying = audioViewModel.audioPlayer.isPlaying
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                viewModel.viewShown = true
            }
        }
        .onDisappear {
            viewModel.viewShown = false
        }
        .onReceive(timer) { time in
            viewModel.currentTime = Int(audioViewModel.audioPlayer.currentTime)
        }
        .preferredColorScheme(.light)
    }
}
