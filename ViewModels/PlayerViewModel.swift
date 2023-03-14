//
//  PlayerViewModel.swift
//  AppleMusic
//
//  Created by Inumaki on 14.03.23.
//

import Foundation
import AVKit

final class PlayerViewModel: ObservableObject {
    @Published var lovedSong: Bool = false
    @Published var audioPlaying: Bool = false
    @Published var seekingAudio: Bool = false
    @Published var currentTime: Int = 0
    @Published var viewShown: Bool = false
    
}
