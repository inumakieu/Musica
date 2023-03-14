//
//  AudioViewModel.swift
//  AppleMusic
//
//  Created by Inumaki on 14.03.23.
//

import Foundation
import AVKit

final class AudioViewModel: ObservableObject {
    var audioPlayer = AVAudioPlayer()
    let path = Bundle.main.path(forResource: "tj", ofType: "mp3")
    
    init() {
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: URL(string: path ?? "")!)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.numberOfLoops = -1
            self.audioPlayer.volume = 0.5
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
