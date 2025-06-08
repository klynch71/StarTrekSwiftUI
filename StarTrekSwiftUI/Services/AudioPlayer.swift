//
//  AudioPlayer.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/22/25.
//

import Foundation
import AVFoundation

/*
 A simple wrapper for AVAudioPlayer
 */
class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    
    private var audioPlayer: AVAudioPlayer? = nil
    
    /*
     play the sound loops number of times.  Use loops = -1 for continuous looping.
     */
    func play(_ name: String, loops: Int = 1) {
        let path = Bundle.main.path(forResource: name, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.numberOfLoops = loops
            audioPlayer?.play()
        } catch {
            // couldn't load file :(
            print("failed to load sound file")
        }
    }
    
    func stop() {
        self.audioPlayer?.stop()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            // After successfully finish song playing will stop audio player and remove from memory
            self.audioPlayer?.stop()
            self.audioPlayer = nil
        }
    }
    
}

